local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({ trig = "go", name = "Simple Go program" }, {
    t({ 'package main', '', 'import "fmt"', '', 'func main() {', '\t' }),
    i(1),
    t({ '', '}' }),
  }),
}
