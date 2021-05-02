{ name = "elasticsearch"
, dependencies =
  [ "console"
  , "effect"
  , "prelude"
  , "psci-support"
  , "aff-promise"
  , "argonaut"
  , "option"
  , "nullable"
  , "assert"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
