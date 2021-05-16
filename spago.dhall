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
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
