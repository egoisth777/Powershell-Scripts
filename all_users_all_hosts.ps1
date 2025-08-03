$metaModulePath = ".\meta_module.psm1"

# Testing Path and Import Module
if (Test-Path $metaModulePath) {
  Import-Module $metaModulePath -ErrorAction SilentlyContinue
}
