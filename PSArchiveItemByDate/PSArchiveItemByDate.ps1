[CmdletBinding(SupportsShouldProcess)]
Param([String[]][Parameter(Mandatory,ValueFromRemainingArguments)]$Item)

Set-StrictMode -Version Latest

Import-Module -Name $PSCommandPath.Replace('.ps1', '.psd1')

$Item | ForEach-Object {
    Move-ItemToArchiveDirectoryByDateInName $_ | Out-Null
}
