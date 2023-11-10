local snippets = {
  s("img", fmt([[
    <div align="center">

    ![{}]({})
    *{}*

    </div>
    {}
  ]], {
      i(1, "caption"),
      i(2, "path/to/image"),
      rep(1),
      i(0)
  }))
}

return snippets
