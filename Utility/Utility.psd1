@{
    ModuleVersion = '1.0.0'
    GUID = '12345678-1234-1234-1234-123456789012'
    Author = 'Yueyang Li'
    Description = 'Utility module with lazy-loaded optional aliases (A Utility Module for current PC)'
    RootModule = 'utility.psm1'
    FunctionsToExport = '*'
    AliasesToExport = '*'
    PrivateData = @{
        PSData = @{
            Tags = @('utility', 'aliases')
        }
    }
} 
