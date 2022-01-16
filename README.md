# PSArchiveItemByDate

Move files or directories to the YYYYMM folder using the first 8 characters of
the specified file name, YYYYMMDD.

## Requirements

* Microsoft Windows 11
* PowerShell 5.1

## Usage

```powershell
# See what happens when you run it.
Move-ItemToArchiveDirectoryByDateInName $HOME\19610412_dark_and_blue.txt -WhatIf

# Move the file to '$HOME\Archive\1961\196104\19610412_dark_and_blue.txt'.
Move-ItemToArchiveDirectoryByDateInName $HOME\19610412_dark_and_blue.txt
```

## Installation

### Install from PowerShell Gallery

```powershell
Install-Module -Name PSArchiveItemByDate
```

### Install from source

```powershell
# Install the module into LocalApp directory.
cd $env:LOCALAPPDATA
gh repo clone kumarstack55/PSArchiveItemByDate
cd .\PSArchiveItemByDate\PSArchiveItemByDate

# If you want to run it with "Send to" in Explorer, create a shortcut.
function New-ShortcutLinkItemExecutedByPowershell {
    param(
        [parameter(Mandatory)][String]$LiteralPath,
        [parameter(Mandatory)][String]$Value
    )
    $ShortcutParentPath = Split-Path $LiteralPath -Parent
    $ShortcutParentItem = Get-Item -LiteralPath $ShortcutParentPath
    $ShortcutName = Split-Path $LiteralPath -Leaf
    $ShortcutFullName = Join-Path $ShortcutParentItem.FullName $ShortcutName

    $Ps1Item = Get-Item -LiteralPath $Value
    $Ps1FullName = $Ps1Item.FullName

    $Shell = New-Object -ComObject WScript.Shell
    $Shortcut = $Shell.CreateShortcut($ShortcutFullName)
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-File `"$Ps1FullName`" -InformationAction Continue"
    $Shortcut.Save()
}

$SendToDir = Join-Path $env:APPDATA Microsoft\Windows\SendTo
$ShortcutFilePath = Join-Path $SendToDir "Move Items To Archive Directory.lnk"

New-ShortcutLinkItemExecutedByPowershell -LiteralPath $ShortcutFilePath `
    -Value PSArchiveItemByDate.ps1

# Import the module.
Import-Module -Name $env:LOCALAPPDATA\PSArchiveItemByDate\PSArchiveItemByDate\PSArchiveItemByDate.psd1 -Force -Verbose
```

## TODO

* Write tests.
* Write documents.