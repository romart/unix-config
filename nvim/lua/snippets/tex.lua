local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
-- local f = ls.function_node

return {
  s("beg", {
    t("\\begin{"), i(1), t("}"),
    t({ "", "\t", }), i(0),
    t({ "", "\\end{" }), rep(1), t({ "}" })
  })
}
