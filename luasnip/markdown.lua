local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s({ trig = "h1", name = "Heading 1" }, fmt("# {}", { i(1, "Heading") })),
  s({ trig = "h2", name = "Heading 2" }, fmt("## {}", { i(1, "Heading") })),
  s({ trig = "link", name = "Link" }, fmt("[{}]({})", {
    i(1, "Link text"),
    i(2, "url"),
  })),
  s({ trig = "img", name = "Image" }, fmt("![{}]({})", {
    i(1, "Alt text"),
    i(2, "image_url"),
  })),
  s({ trig = "item", name = "Itemized list" }, {
    t("- "),
    i(1, "Item"),
    t({ "", "- " }),
    i(2, "Another item"),
    t({ "", "- " }),
    i(3, "Yet another item"),
  }),
  s({ trig = "code", name = "Code block" }, {
    t("```"),
    i(1, "language"),
    t({ "", "" }),
    i(2, "Code here"),
    t({ "", "```" }),
  }),
}
