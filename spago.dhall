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
  , "untagged-union"
  , "literals"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
