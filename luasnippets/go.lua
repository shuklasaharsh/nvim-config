-- Custom Go snippets for json + gorm struct fields.
-- Loaded by: require("luasnip.loaders.from_lua").lazy_load({ paths = { ... } })
--
-- Cheatsheet (trigger -> result):
--   jf        FieldName type `json:"field_name"`
--   jfo       FieldName type `json:"field_name,omitempty"`
--   jfx       FieldName type `json:"-"`                       (ignore)
--   gorm      ... `json:"x" gorm:"column:x"`
--   gormpk    ... gorm:"column:x;primaryKey"
--   gormai    ... gorm:"column:x;primaryKey;autoIncrement"
--   gormnn    ... gorm:"column:x;not null"
--   gormu     ... gorm:"column:x;uniqueIndex"
--   gormidx   ... gorm:"column:x;index"
--   gf        gorm field, cycle the constraint with the choice node (node 3)
--   gfo       gf + json omitempty
--   gormid    ID uuid.UUID ... type:uuid;default:gen_random_uuid();primaryKey
--   gormts    CreatedAt / UpdatedAt timestamp fields
--   gormdel   DeletedAt gorm.DeletedAt soft-delete field
--   gormmodel gorm.Model (embed line)
--   gmodel    full model struct + TableName()
--   gstruct   plain struct
--   cf        config field: json + yaml + mapstructure
--   jval      json + validate
--   jdb       json + db (sqlx)

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local t = ls.text_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

-- PascalCase / camelCase -> snake_case
-- Handles acronyms: MemberID -> member_id, HTTPServer -> http_server, ID -> id
local function to_snake(str)
  local s1 = str:gsub("(%u+)(%u%l)", "%1_%2")
  local s2 = s1:gsub("([%l%d])(%u)", "%1_%2")
  return s2:lower()
end

-- function-node callback: snake_case of the referenced node's text
local snake = function(args)
  return to_snake(args[1][1])
end

-- reusable gorm constraint picker (fresh node each call so it can be reused safely)
local function gorm_constraint(idx)
  return c(idx, {
    t(""),
    t(";primaryKey"),
    t(";primaryKey;autoIncrement"),
    t(";not null"),
    t(";uniqueIndex"),
    t(";index"),
    t(";default:null"),
  })
end

return {
  -------------------------------------------------------------------- json
  s(
    "jf",
    fmta([[<> <> `json:"<>"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
    })
  ),
  s(
    "jfo",
    fmta([[<> <> `json:"<>,omitempty"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
    })
  ),
  s(
    "jfx",
    fmta([[<> <> `json:"-"`]], {
      i(1, "FieldName"),
      i(2, "string"),
    })
  ),

  -------------------------------------------------------------------- gorm (direct triggers)
  s(
    "gorm",
    fmta([[<> <> `json:"<>" gorm:"column:<>"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
      f(snake, { 1 }),
    })
  ),
  s(
    "gormpk",
    fmta([[<> <> `json:"<>" gorm:"column:<>;primaryKey"`]], {
      i(1, "ID"),
      i(2, "uuid.UUID"),
      f(snake, { 1 }),
      f(snake, { 1 }),
    })
  ),
  s(
    "gormai",
    fmta([[<> <> `json:"<>" gorm:"column:<>;primaryKey;autoIncrement"`]], {
      i(1, "ID"),
      i(2, "uint"),
      f(snake, { 1 }),
      f(snake, { 1 }),
    })
  ),
  s(
    "gormnn",
    fmta([[<> <> `json:"<>" gorm:"column:<>;not null"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
      f(snake, { 1 }),
    })
  ),
  s(
    "gormu",
    fmta([[<> <> `json:"<>" gorm:"column:<>;uniqueIndex"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
      f(snake, { 1 }),
    })
  ),
  s(
    "gormidx",
    fmta([[<> <> `json:"<>" gorm:"column:<>;index"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
      f(snake, { 1 }),
    })
  ),

  -------------------------------------------------------------------- gorm (choice node)
  s(
    "gf",
    fmta([[<> <> `json:"<>" gorm:"column:<><>"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
      f(snake, { 1 }),
      gorm_constraint(3),
    })
  ),
  s(
    "gfo",
    fmta([[<> <> `json:"<>,omitempty" gorm:"column:<><>"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
      f(snake, { 1 }),
      gorm_constraint(3),
    })
  ),

  -------------------------------------------------------------------- common ready-made fields
  s("gormid", t([[ID uuid.UUID `json:"id" gorm:"column:id;type:uuid;default:gen_random_uuid();primaryKey"`]])),
  s(
    "gormts",
    t({
      [[CreatedAt time.Time `json:"created_at" gorm:"column:created_at;autoCreateTime"`]],
      [[UpdatedAt time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`]],
    })
  ),
  s("gormdel", t([[DeletedAt gorm.DeletedAt `json:"deleted_at,omitempty" gorm:"column:deleted_at;index"`]])),
  s("gormmodel", t("gorm.Model")),

  -------------------------------------------------------------------- structs
  s(
    "gstruct",
    fmta(
      [[
type <> struct {
	<>
}]],
      { i(1, "Name"), i(2, "") }
    )
  ),

  s(
    "gmodel",
    fmta(
      [[
type <> struct {
	ID uuid.UUID `json:"id" gorm:"column:id;type:uuid;default:gen_random_uuid();primaryKey"`
	<>
	CreatedAt time.Time `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`
}

func (m <>) TableName() string {
	return "<>"
}]],
      {
        i(1, "ModelName"),
        i(2, "// fields"),
        rep(1),
        i(3, "table_name"),
      }
    )
  ),

  -------------------------------------------------------------------- other tag combos
  s(
    "cf",
    fmta([[<> <> `json:"<>" yaml:"<>" mapstructure:"<>"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
      f(snake, { 1 }),
      f(snake, { 1 }),
    })
  ),
  s(
    "jval",
    fmta([[<> <> `json:"<>" validate:"<>"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
      i(3, "required"),
    })
  ),
  s(
    "jdb",
    fmta([[<> <> `json:"<>" db:"<>"`]], {
      i(1, "FieldName"),
      i(2, "string"),
      f(snake, { 1 }),
      f(snake, { 1 }),
    })
  ),
}
