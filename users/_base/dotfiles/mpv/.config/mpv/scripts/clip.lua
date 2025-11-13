mp.utils = require("mp.utils")
mp.msg = require("mp.msg")
mp.options = require("mp.options")

local timestamps = {}
local msg_timer
local msg_timer_duration = 5

--==============================================================================
-- OPTIONS
--==============================================================================

local opts = {
  async = true,
  only_active_streams = false,
  preserve_mpv_vfilters = true,
  extra_vfilters = "",
  extra_args = "-an -sn -c:v libx264 -crf 10",
  output_file_format = "$f-clip.mp4",
  output_directory = "",
}
mp.options.read_options(opts, "clip")

-- TODO: implement functionality that uses this
--   - may need separate presets for different containers and/or codecs
--   - as user to input container, codec, and corresponding preset
local quality_presets = {
  copy = { video_codec = "copy", audio_codec = "copy" },
  high = { video_codec = "libx264", crf = "18", preset = "slower", audio_codec = "aac", audio_bitrate = "192k" },
  medium = { video_codec = "libx264", crf = "20", preset = "medium", audio_codec = "aac", audio_bitrate = "128k" },
  fast = { video_codec = "libx264", crf = "23", preset = "fast", audio_codec = "aac", audio_bitrate = "96k" },
  tiny = { video_codec = "libx264", crf = "28", preset = "ultrafast", audio_codec = "aac", audio_bitrate = "64k" },
}

--==============================================================================
-- UTILS
--==============================================================================

local function log(msg, indefinitely, level)
  level = level or "info"

  if msg_timer then
    msg_timer:kill()
  end

  mp.msg.log(level, msg)

  local function log_to_osd()
    mp.osd_message(msg, msg_timer_duration)
  end
  log_to_osd()
  if indefinitely then
    msg_timer = mp.add_periodic_timer(msg_timer_duration, log_to_osd)
  end
end

local function append_table(lhs, rhs)
  for i = 1, #rhs do
    lhs[#lhs + 1] = rhs[i]
  end
  return lhs
end

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function get_extension(path)
  return string.match(path, "%.([^.]+)$") or ""
end

local function seconds_to_time_string(seconds, full)
  local ret =
    string.format("%02d:%02d.%03d", math.floor(seconds / 60) % 60, math.floor(seconds) % 60, seconds * 1000 % 1000)
  if full or seconds > 3600 then
    ret = string.format("%d:%s", math.floor(seconds / 3600), ret)
  end
  return ret
end

local function get_output_path(dir, format, input, input_extension, title, from, to)
  local res = mp.utils.readdir(dir)
  if not res then
    return nil
  end
  local files = {}
  for _, f in ipairs(res) do
    files[f] = true
  end

  local output = format
  output = string.gsub(output, "$f", function()
    return input
  end)
  output = string.gsub(output, "$t", function()
    return title
  end)
  output = string.gsub(output, "$s", function()
    return seconds_to_time_string(from, true)
  end)
  output = string.gsub(output, "$e", function()
    return seconds_to_time_string(to, true)
  end)
  output = string.gsub(output, "$d", function()
    return seconds_to_time_string(to - from, true)
  end)
  output = string.gsub(output, "$x", function()
    return input_extension
  end)

  return output
end

local function get_video_filters()
  local filters = {}
  for _, vf in ipairs(mp.get_property_native("vf")) do
    local name = vf["name"]
    name = string.gsub(name, "^lavfi%-", "")
    local filter
    if name == "crop" then
      local p = vf["params"]
      print(mp.utils.to_string(vf))
      print(mp.utils.to_string(p))
      filter = string.format("crop=%d:%d:%d:%d", p.w, p.h, p.x, p.y)
    elseif name == "mirror" then
      filter = "hflip"
    elseif name == "flip" then
      filter = "vflip"
    elseif name == "rotate" then
      local rotation = vf["params"]["angle"]
      -- rotate is NOT the filter we want here
      if rotation == "90" then
        filter = "transpose=clock"
      elseif rotation == "180" then
        filter = "transpose=clock,transpose=clock"
      elseif rotation == "270" then
        filter = "transpose=cclock"
      end
    end
    filters[#filters + 1] = filter
  end
  return filters
end

local function get_input_info(default_path, only_active)
  local is_active = {
    video = true,
    audio = not mp.get_property_bool("mute"),
    sub = mp.get_property_bool("sub-visibility"),
  }

  local ret = {}
  for _, stream in ipairs(mp.get_property_native("track-list")) do
    local filepath_containing_stream = stream["external-filename"] or default_path
    if not only_active or (stream["selected"] and is_active[stream["type"]]) then
      ret[filepath_containing_stream] = ret[filepath_containing_stream] or {}
      table.insert(ret[filepath_containing_stream], stream["ff-index"])
    end
  end
  return ret
end

--==============================================================================
-- MAIN
--==============================================================================

local function create_clip(from, to)
  local args = {
    "ffmpeg",
    "-y",
    "-hide_banner",
  }
  local append_args = function(table)
    args = append_table(args, table)
  end

  local path = mp.get_property("path")
  local is_stream = not file_exists(path)
  if is_stream then
    path = mp.get_property("stream-path")
  end

  --------------------------------------------------
  -- args for each input file
  --------------------------------------------------
  local stream_selection_args = {}
  local start = seconds_to_time_string(from, false)
  local input_index = 0
  for input_path, streams in pairs(get_input_info(path, opts.only_active_streams)) do
    append_args({
      "-ss",
      start,
      "-i",
      input_path,
    })
    if opts.only_active_streams then
      for _, stream_index in ipairs(streams) do
        stream_selection_args =
          append_table(stream_selection_args, { "-map", string.format("%d:%d", input_index, stream_index) })
      end
    else
      stream_selection_args = append_table(stream_selection_args, { "-map", tostring(input_index) })
    end
    input_index = input_index + 1
  end

  --------------------------------------------------
  -- args for output file
  --------------------------------------------------
  append_args({ "-to", tostring(to - from) })
  append_args(stream_selection_args)

  -- video filters
  ------------------------------
  local filters = {}
  if opts.preserve_mpv_vfilters then
    filters = get_video_filters()
  end
  if opts.extra_vfilters ~= "" then
    filters[#filters + 1] = opts.extra_vfilters
  end
  if #filters > 0 then
    append_args({ "-filter:v", table.concat(filters, ",") })
  end

  -- extra user-configured args
  ------------------------------
  for arg in string.gmatch(opts.extra_args, "[^%s]+") do
    args[#args + 1] = arg
  end

  -- output path
  ------------------------------

  -- output dir
  local output_dir = opts.output_directory
  if output_dir == "" then
    if is_stream then
      output_dir = "."
    else
      output_dir, _ = mp.utils.split_path(path)
    end
  else
    output_dir = string.gsub(output_dir, "^~", os.getenv("HOME") or "~")
  end

  -- output file
  local input_name = mp.get_property("filename/no-ext") or "cut"
  local title = mp.get_property("media-title")
  local input_extension = get_extension(path)
  local output_basename =
    get_output_path(output_dir, opts.output_file_format, input_name, input_extension, title, from, to)
  local output_path = mp.utils.join_path(output_dir, output_basename)
  args[#args + 1] = output_path

  -- create clip
  ------------------------------

  -- output msg
  local msg = ""
  for _, arg in ipairs(args) do
    if arg:find("%s") then
      msg = string.format('%s "%s"', msg, arg)
    else
      msg = string.format("%s %s", msg, arg)
    end
  end
  mp.msg.info(msg)

  -- execute ffmpeg process
  if opts.async then
    mp.command_native_async({
      name = "subprocess",
      args = args,
      capture_stdout = true,
      capture_stderr = true,
      playback_only = false,
    }, function(success, result)
      if success then
        log("Clip saved to " .. output_path)
      else
        log("Failed to create clip, check log")
        mp.msg.error(mp.utils.to_string(result))
      end
    end)
  else
    local res =
      mp.utils.subprocess({ args = args, capture_stdout = true, capture_stderr = true, playback_only = false })
    if res.status == 0 then
      log("Clip saved to " .. output_path)
    else
      log("Failed to create clip, check ffmpeg log")
      mp.msg.error(mp.utils.to_string(res))
    end
  end
end

local function reset_state()
  timestamps = {}
  mp.remove_key_binding("clip_cancel")
  mp.osd_message("", 0)
end

local function set_timestamp()
  if not mp.get_property("path") then
    log("No file currently playing")
    return
  end
  if not mp.get_property_bool("seekable") then
    log("Cannot encode non-seekable media")
    return
  end

  if #timestamps == 0 then
    table.insert(timestamps, mp.get_property_number("time-pos"))
    log("clip: first timestamp set to " .. seconds_to_time_string(timestamps[1], false), true)
    mp.add_forced_key_binding("ESC", "clip_cancel", reset_state)
  elseif #timestamps == 1 then
    table.insert(timestamps, mp.get_property_number("time-pos"))
    local from = math.min(timestamps[1], timestamps[2])
    local to = math.max(timestamps[1], timestamps[2])

    reset_state()

    log(
      string.format(
        "clip: creating clip from %s to %s",
        seconds_to_time_string(from, false),
        seconds_to_time_string(to, false)
      ),
      true
    )

    -- include the current frame
    local fps = mp.get_property_number("container-fps") or 30
    to = to + ((1 / fps) / 2)

    create_clip(from, to)
  end
end

mp.add_key_binding(nil, "clip-set-timestamp", set_timestamp)
