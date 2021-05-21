{ name = "elasticsearch"
, dependencies =
  [ "console"
  , "effect"
  , "prelude"
  , "psci-support"
  , "aff-promise"
  , "argonaut"
  , "assert"
  , "untagged-union"
  , "literals"
  , "aff"
  , "foreign-object"
  , "maybe"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
