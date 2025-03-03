@{
    RootModule = 'meta_module.psm1'
    ModuleVersion = '1.0.0'
    GUID = [guid]::NewGuid().ToString()
    Author = 'Yueyang Li'
    Description = 'Meta module for PowerShell functionality'
    FunctionsToExport = '*'
    AliasesToExport = '*'
    PrivateData = @{
        PSData = @{
            Tags = @('meta', 'utility')
        }
    }
} 