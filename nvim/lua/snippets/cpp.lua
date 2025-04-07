local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep

return {
  s("for", {
    t("for ("), i(0), t("; "), i(1), t("; "), i(2), t(") {"),
    t({ "", "\t" }), i(3),
    t({ "", "}" })
  }),

  s("whl", {
    t("while ("), i(0), t(") {"),
    t({ "", "\t" }), i(1),
    t({ "", "}" })
  }),

  s("dwl", {
    t("do {"),
    t({ "", "\t" }), i(1),
    t({ "", "while (" }), i(0), t(");"),
  }),

  s("ifelse", {
    t("if ("), i(0), t(") {"),
    t({ "", "\t" }), i(1),
    t({ "", "} else {" }),
    t({ "", "\t" }), i(2),
    t({ "", "}" })
  }),

  s("iff", {
    t("if ("), i(0), t(") {"),
    t({ "", "\t" }), i(1),
    t({ "", "}" })
  })
}
