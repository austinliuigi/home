local snippets = {
  s("main", fmt([[
    def main():
      {}

    if __name__ == "__main__":
      main()
  ]], {
    i(0)
  })),
}

return snippets
