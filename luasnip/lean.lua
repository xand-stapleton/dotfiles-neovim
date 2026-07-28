local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Lean declarations and proof structure.
  s({ trig = "import", name = "Import module" }, fmt("import {}", {
    i(1, "Mathlib"),
  })),
  s({ trig = "namespace", name = "Namespace" }, fmt(
    [[
namespace {}

{}

end {}
]],
    { i(1, "Name"), i(0), require("luasnip.extras").rep(1) }
  )),
  s({ trig = "section", name = "Section" }, fmt(
    [[
section {}

{}

end {}
]],
    { i(1, "name"), i(0), require("luasnip.extras").rep(1) }
  )),
  s({ trig = "theorem", name = "Theorem" }, fmt(
    [[
theorem {} {} : {} := by
  {}
]],
    { i(1, "name"), i(2, "{α : Type*}"), i(3, "proposition"), i(0, "sorry") }
  )),
  s({ trig = "lemma", name = "Lemma" }, fmt(
    [[
lemma {} {} : {} := by
  {}
]],
    { i(1, "name"), i(2, "{α : Type*}"), i(3, "proposition"), i(0, "sorry") }
  )),
  s({ trig = "example", name = "Example" }, fmt(
    [[
example {} : {} := by
  {}
]],
    { i(1, "{α : Type*}"), i(2, "proposition"), i(0, "sorry") }
  )),
  s({ trig = "def", name = "Definition" }, fmt(
    "def {} {} : {} :=\n  {}",
    { i(1, "name"), i(2, "(x : α)"), i(3, "α"), i(0, "value") }
  )),
  s({ trig = "have", name = "Have proof" }, fmt(
    "have {} : {} := by\n  {}",
    { i(1, "h"), i(2, "proposition"), i(0, "sorry") }
  )),
  s({ trig = "calc", name = "Calculation block" }, fmt(
    [[
calc
  {} = {} := by {}
  _ = {} := by {}
]],
    { i(1, "lhs"), i(2, "middle"), i(3, "simp"), i(4, "rhs"), i(0, "simp") }
  )),

  -- Small Mathlib conveniences.
  s({ trig = "mathlib", name = "Import Mathlib" }, t("import Mathlib")),
  s({ trig = "bigops", name = "Open big operators" }, t("open scoped BigOperators")),
  s({ trig = "simpa", name = "simpa using" }, fmt("simpa [{}] using {}", {
    i(1),
    i(0, "h"),
  })),
  s({ trig = "rw", name = "Rewrite" }, fmt("rw [{}]", { i(0, "lemma") })),
  s({ trig = "rcases", name = "Destructure with rcases" }, fmt(
    "rcases {} with ⟨{}⟩",
    { i(1, "h"), i(0, "h₁, h₂") }
  )),
  s({ trig = "induction", name = "Induction proof" }, fmt(
    "induction {} with\n| {} =>\n  {}\n| {} =>\n  {}",
    {
      i(1, "n"),
      i(2, "zero"),
      i(3, "simp"),
      i(4, "succ n ih"),
      i(0, "simp_all"),
    }
  )),
}
