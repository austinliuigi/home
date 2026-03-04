---@diagnostic disable: undefined-global

local snippets = {}

table.insert(
  snippets,
  s(
    {
      trig = "manim",
      desc = "Generic manim makefile",
    },
    fmt(
      [[
        SHELL := /usr/bin/env bash

        MANIM = manim
        FILE = scenes.py
        FLAGS = --quality=h {}

        # ADD SCENES NAMES HERE
        SCENES = {}

        .PHONY: all $(SCENES)

        all: $(SCENES)

        $(SCENES):
        	mkdir -p out
        	manim $(FLAGS) src/main.py $@ -o "$$(pwd)/out/$@"
      ]],
      {
        c(1, { t("-s"), t("--format=gif"), t("--format=mp4") }),
        i(2, "Scene1 Scene2"),
      }
    )
  )
)

return snippets
