local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local function visual(position, default)
  return d(position, function(_, parent)
    local selected = parent.snippet.env.LS_SELECT_RAW
    if type(selected) == "table" and #selected > 0 then
      return sn(nil, i(1, table.concat(selected, "\n")))
    end
    return sn(nil, i(1, default or ""))
  end)
end

local function slugify(lines)
  local value = table.concat(lines or {}, " ")
  value = value:gsub("\\[%a@]+%*?", "")
  value = value:gsub("[{}]", "")
  value = value:lower():gsub("[^%w]+", "_")
  value = value:gsub("^_+", ""):gsub("_+$", "")
  return value ~= "" and value or "label"
end

local function label(position, source)
  return d(position, function(args)
    return sn(nil, i(1, slugify(args[1])))
  end, { source })
end

local function heading(trigger, command, prefix, default)
  return s({ trig = trigger, name = command .. " with label" }, fmta(
    [[
\<>{<>}%
\label{<>:<>}

<>
]],
    {
      t(command),
      visual(1, default),
      t(prefix),
      label(2, 1),
      i(0),
    }
  ))
end

local function table_from_capture(_, parent)
  local captures = parent.snippet.captures or {}
  local columns = math.min(math.max(tonumber(captures[1]) or 1, 1), 20)
  local rows = math.min(math.max(tonumber(captures[2]) or 1, 1), 20)
  local nodes = {
    t("\\begin{tabular}{"),
    i(1, string.rep("c", columns)),
    t({ "}", "\t" }),
  }
  local index = 2

  for row = 1, rows do
    for column = 1, columns do
      nodes[#nodes + 1] = i(index, "cell")
      index = index + 1
      if column < columns then
        nodes[#nodes + 1] = t(" & ")
      end
    end

    if row < rows then
      nodes[#nodes + 1] = t({ " \\\\", "\t" })
    else
      nodes[#nodes + 1] = t({ " \\\\", "\\end{tabular}" })
    end
  end

  nodes[#nodes + 1] = i(0)
  return sn(nil, nodes)
end

local function row_from_capture(_, parent)
  local captures = parent.snippet.captures or {}
  local columns = math.min(math.max(tonumber(captures[1]) or 1, 1), 20)
  local nodes = {}

  for column = 1, columns do
    nodes[#nodes + 1] = i(column, "cell")
    if column < columns then
      nodes[#nodes + 1] = t(" & ")
    end
  end

  nodes[#nodes + 1] = t(" \\\\")
  nodes[#nodes + 1] = i(0)
  return sn(nil, nodes)
end

local function colour(trigger, colour, multiline)
  local body
  if multiline then
    body = fmta(
      [[
{\color{<>}
<>
}
]],
      { t(colour), visual(1) }
    )
  else
    body = fmta([=[{\color{<>} <>}]=], { t(colour), visual(1) })
  end

  return s({
    trig = trigger,
    name = ("Colour %s%s"):format(colour, multiline and " block" or ""),
  }, body)
end

return {
  s({ trig = "sim", name = "Simple LaTeX document" }, fmta(
    [[
\documentclass{article}
\usepackage{graphicx}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{braket}
\begin{document}

\title{<>}
\author{Alexander Stapleton}

\maketitle

<>
\end{document}
]],
    { i(1, "title"), i(0) }
  )),

  s({ trig = "b", name = "Begin/end environment" }, fmta(
    [[
\begin{<>}
	<>
\end{<>}
]],
    { i(1, "environment"), visual(2), rep(1) }
  )),

  s({ trig = "tab", name = "Tabular/array environment" }, fmta(
    [[
\begin{<>}{<>}
	<>
\end{<>}
]],
    {
      c(1, { t("tabular"), t("array") }),
      i(2, "c"),
      i(0),
      rep(1),
    }
  )),

  s({
    trig = "gentbl(%d+)x(%d+)",
    name = "Generate table from dimensions",
    dscr = "gentbl3x2 creates a three-column, two-row tabular",
    regTrig = true,
    wordTrig = false,
  }, d(1, table_from_capture)),

  s({
    trig = "tr(%d+)",
    name = "Generate table row",
    dscr = "tr3 creates a three-cell row",
    regTrig = true,
    wordTrig = false,
  }, d(1, row_from_capture)),

  s({ trig = "table", name = "Table float" }, fmta(
    [[
\begin{table}[<>]
	\centering
	\caption{<>}
	\label{tab:<>}
	\begin{<>}{<>}
		<>
	\end{<>}
\end{table}
]],
    {
      i(1, "htpb"),
      i(2, "caption"),
      i(3, "label"),
      c(4, { t("tabular"), t("array") }),
      i(5, "c"),
      i(0),
      rep(4),
    }
  )),

  s({ trig = "cent", name = "Center environment" }, fmta(
    [[
\begin{center}
	<>
\end{center}
]],
    { visual(1) }
  )),

  s({ trig = "fig", name = "Figure environment" }, fmta(
    [[
\begin{figure}[<>]
	\centering
	\includegraphics[width=<>\linewidth]{<>}
	\caption{<>}%
	\label{fig:<>}
\end{figure}
]],
    {
      i(1, "htpb"),
      i(2, "0.8"),
      i(3, "name.ext"),
      i(4, "caption"),
      i(0, "label"),
    }
  )),

  s({ trig = "graph", name = "Include graphics" }, fmta(
    [[\includegraphics[width=<>\linewidth]{<>}]],
    { i(1, "0.8"), i(0, "name.ext") }
  )),

  s({ trig = "enum", name = "Enumerate" }, fmta(
    [[
\begin{enumerate}
	\item <>
\end{enumerate}
]],
    { visual(1) }
  )),

  s({ trig = "item", name = "Itemize" }, fmta(
    [[
\begin{itemize}
	\item <>
\end{itemize}
]],
    { visual(1) }
  )),

  s({ trig = "eqlab", name = "Equation label" }, fmta(
    [[\label{eqn:<>} <>]],
    { i(1, "label"), i(0) }
  )),
  s({ trig = "lab", name = "Label" }, fmta(
    [[\label{<>} <>]],
    { i(1, "label"), i(0) }
  )),

  s({ trig = "desc", name = "Description list" }, fmta(
    [[
\begin{description}
	\item[<>] <>
\end{description}
]],
    { i(1, "term"), visual(2) }
  )),
  s({ trig = "it", name = "List item" }, fmta([[\item <>]], { visual(1) })),

  heading("cha", "chapter", "cha", "chapter name"),
  heading("sec", "section", "sec", "section name"),
  heading("sec*", "section*", "sec", "section name"),
  heading("sub", "subsection", "sub", "subsection name"),
  heading("sub*", "subsection*", "sub", "subsection name"),
  heading("ssub", "subsubsection", "ssub", "subsubsection name"),
  heading("ssub*", "subsubsection*", "ssub", "subsubsection name"),
  heading("par", "paragraph", "par", "paragraph name"),
  heading("subp", "subparagraph", "par", "subparagraph name"),

  s({ trig = "frame", name = "Beamer frame" }, fmta(
    [[
\begin{frame}{<>}
<>
\end{frame}
<>
]],
    { i(1, "frame title"), visual(2), i(0) }
  )),

  s({ trig = "ac", name = "Acronym" }, fmta([[\ac{<>}<>]], {
    i(1, "acronym"),
    i(0),
  })),
  s({ trig = "acl", name = "Expanded acronym" }, fmta([[\acl{<>}<>]], {
    i(1, "acronym"),
    i(0),
  })),
  s({ trig = "ni", name = "No-indent paragraph" }, fmta(
    "\\noindent\n<>",
    { i(0) }
  )),

  s({ trig = "pac", name = "Use package" }, fmta([[\usepackage<>{<>}<>]], {
    c(1, {
      t(""),
      sn(nil, { t("["), i(1, "options"), t("]") }),
    }),
    i(2, "package"),
    i(0),
  })),

  s({ trig = "(", name = "Parentheses", wordTrig = false }, fmta(
    "(<>)<>",
    { visual(1, "contents"), i(0) }
  )),
  s({ trig = "{", name = "Braces", wordTrig = false }, fmta(
    "{<>}<>",
    { visual(1, "contents"), i(0) }
  )),
  s({ trig = "[", name = "Brackets", wordTrig = false }, fmta(
    "[<>]<>",
    { visual(1, "contents"), i(0) }
  )),
  s({ trig = "lp", name = "Scalable parentheses" }, fmta(
    [[\left(<>\right)<>]],
    { visual(1, "contents"), i(0) }
  )),
  s({ trig = "tb", name = "Bold text" }, fmta([[\textbf{<>}]], {
    visual(1),
  })),
  s({ trig = "ti", name = "Italic text" }, fmta([[\textit{<>}]], {
    visual(1),
  })),

  s({ trig = "sq", name = "Square root" }, fmta([[\sqrt{<>}]], {
    visual(1),
  })),
  s({ trig = "cub", name = "Cube root" }, fmta([[\sqrt[3]{<>}]], {
    visual(1),
  })),
  s({ trig = "mb", name = "Math boldface" }, fmta([[\mathbf{<>}]], {
    visual(1),
  })),
  s({ trig = "mib", name = "Inline math boldface" }, fmta(
    [[$\mathbf{<>}$ <>]],
    { visual(1), i(0) }
  )),
  s({ trig = "mi", name = "Math italics" }, fmta([[\mathit{<>}]], {
    visual(1),
  })),
  s({ trig = "text", name = "Math text" }, fmta([[\text{<>}]], {
    visual(1),
  })),
  s({ trig = "fr", name = "Fraction" }, fmta([[\frac{<>}{<>} <>]], {
    i(1, "numerator"),
    i(2, "denominator"),
    i(0),
  })),

  s({ trig = "eqnn", name = "Unnumbered equation" }, fmta(
    [[
\begin{equation*}
	<>
\end{equation*}
]],
    { visual(1) }
  )),
  s({ trig = "eq", name = "Equation" }, fmta(
    [[
\begin{equation}
	<>
\end{equation}
]],
    { visual(1) }
  )),
  s({ trig = "al", name = "Align" }, fmta(
    [[
\begin{align}
	<>
\end{align}
]],
    { visual(1) }
  )),
  s({ trig = "aln", name = "Unnumbered align" }, fmta(
    [[
\begin{align*}
	<>
\end{align*}
]],
    { visual(1) }
  )),
  s({ trig = "sp", name = "Split environment" }, fmta(
    [[
\begin{split}
	<>
\end{split}
]],
    { visual(1) }
  )),
  s({ trig = "eqa", name = "Equation array" }, fmta(
    [[
\begin{eqnarray}
	<> & <> & <>
\end{eqnarray}
]],
    { i(1), i(2), i(0) }
  )),
  s({ trig = "eqann", name = "Unnumbered equation array" }, fmta(
    [[
\begin{eqnarray*}
	<> & <> & <>
\end{eqnarray*}
]],
    { i(1), i(2), i(0) }
  )),

  s({ trig = "imp", name = "Implies" }, t("\\implies")),
  s({ trig = "mbb", name = "Blackboard bold" }, fmta([[\mathbb{<>} <>]], {
    i(1),
    i(0),
  })),
  s({ trig = "innt", name = "Indefinite integral" }, fmta(
    [[\int <> \, \mathrm{d}<> <>]],
    { i(1, "f(x)"), i(2, "x"), i(0) }
  )),
  s({ trig = "int", name = "Definite integral" }, fmta(
    [[\int_{<>}^{<>} <> \, \mathrm{d}<> <>]],
    { i(1, "a"), i(2, "b"), i(3, "f(x)"), i(4, "x"), i(0) }
  )),
  s({ trig = "inft", name = "Integral over the real line" }, fmta(
    [[\int_{-\infty}^{\infty} <> \, \mathrm{d}<> <>]],
    { i(1, "f(x)"), i(2, "x"), i(0) }
  )),
  s({ trig = "part", name = "Partial derivative" }, fmta(
    [[\frac{\partial <>}{\partial <>} <>]],
    { i(1, "f"), i(2, "x"), i(0) }
  )),
  s({ trig = "der", name = "Derivative" }, fmta(
    [[\frac{\mathrm{d} <>}{\mathrm{d} <>} <>]],
    { i(1, "f"), i(2, "x"), i(0) }
  )),
  s({ trig = "fun", name = "Functional derivative" }, fmta(
    [[\frac{\delta <>}{\delta <>} <>]],
    { i(1, "F"), i(2, "f"), i(0) }
  )),
  s({ trig = "sum", name = "Sum" }, fmta(
    [[\sum_{<>}^{<>} <> <>]],
    { i(1, "i=0"), i(2, "n"), i(3, "a_i"), i(0) }
  )),
  s({ trig = "bs", name = "Bold symbol" }, fmta([[\boldsymbol{<>}]], {
    visual(1),
  })),

  s({ trig = "dv", name = "Physics derivative" }, fmta(
    [=[\dv[<>]{<>}{<>}]=],
    { i(1), i(2), i(0) }
  )),
  s({ trig = "pdv", name = "Physics partial derivative" }, fmta(
    [=[\pdv[<>]{<>}{<>}]=],
    { i(1), i(2), i(0) }
  )),
  s({ trig = "SI", name = "SI unit" }, fmta([[\SI{<>}{<>}]], {
    visual(1),
    i(0, "unit"),
  })),
  s({ trig = "bra", name = "Bra" }, fmta([[\bra{<>}]], { visual(1) })),
  s({ trig = "ket", name = "Ket" }, fmta([[\ket{<>}]], { visual(1) })),
  s({ trig = "bket", name = "Braket" }, fmta([[\braket{<>}]], { visual(1) })),
  s({ trig = "Bra", name = "Expanding bra" }, fmta([[\Bra{<>}]], { visual(1) })),
  s({ trig = "Ket", name = "Expanding ket" }, fmta([[\Ket{<>}]], { visual(1) })),
  s({ trig = "Bket", name = "Expanding braket" }, fmta([[\Braket{<>}]], {
    visual(1),
  })),
  s({ trig = "del", name = "Partial operator" }, t("\\partial")),
  s({ trig = "dag", name = "Dagger" }, t("^\\dagger")),

  colour("red", "red", false),
  colour("Red", "red", true),
  colour("pink", "pink", false),
  colour("Pink", "pink", true),
  colour("purple", "purple", false),
  colour("Purple", "purple", true),

  s({ trig = "td", name = "TODO marker" }, t(
    "{\\color{red} TODO: $<$------Complete Line------$>$}"
  )),
}
