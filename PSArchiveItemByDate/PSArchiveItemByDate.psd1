@{
    ModuleVersion = '1.0.0'
    GUID = 'ecbb468e-dee3-4018-926b-19bc22b4b956'
    Author = 'kumarstack55'
    Description = 'Move files or directories to the YYYYMM folder using the first 8 characters of the specified file name, YYYYMMDD.'
    Copyright = '(c) 2022 kumarstack55. All rights reserved.'
    PowerShellVersion = '5.1'
    NestedModules = @('PSArchiveItemByDate.psm1')
    FunctionsToExport = @('Move-ItemToArchiveDirectoryByDateInName')
    CmdletsToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @()
            LicenseUri = 'https://github.com/kumarstack55/PSArchiveItemByDate/blob/main/LICENSE'
            ProjectUri = 'https://github.com/kumarstack55/PSArchiveItemByDate'
        }
    }
}
