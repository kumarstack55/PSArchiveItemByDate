Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"
$Script:ArchiveDirName = "Archive"

class ArchiveItemByDateException : Exception {
    ArchiveItemByDateException([String]$Message) : base([String]$Message) {}
}

class ArchiveDirNotFoundException : ArchiveItemByDateException {
    ArchiveDirNotFoundException([String]$Message) : base([String]$Message) {}
}

class RootDirCannotArchiveException : ArchiveItemByDateException {
    RootDirCannotArchiveException([String]$Message) : base([String]$Message) {}
}

class InvalidDateException : ArchiveItemByDateException {
    InvalidDateException([String]$Message) : base([String]$Message) {}
}

class SourcePath {
    [String]$Path
    SourcePath($Path) {
        $this.Path = $Path
    }
    hidden [String]GetArchiveDirectoryInPath() {
        <#
            .SYNOPSIS
            Get the Archive directory from the path.
        #>
        $Local:Path = $this.Path
        while ($Local:Path.Length -gt 0) {
            $Name = Split-Path $Local:Path -Leaf
            if ($Name -ceq $Script:ArchiveDirName) {
                return $Local:Path
            }
            $Local:Path = Split-Path $Local:Path -Parent
        }
        throw [ArchiveDirNotFoundException]::new('Archive directory not found in path.')

    }
    hidden [bool]IsArchived() {
        <#
            .SYNOPSIS
            If the path is Archived, return True.
        #>
        try {
            $this.GetArchiveDirectoryInPath()
            return $true
        } catch [ArchiveDirNotFoundException] {
            return $false
        }
    }
    hidden [String]GetArchiveDirectory() {
        <#
            .SYNOPSIS
            Get the Archive directory for that path.
        #>
        if ($this.IsArchived()) {
            return $this.GetArchiveDirectoryInPath()
        } else {
            $ParentDir = Split-Path $this.Path -Parent
            if ($ParentDir.Length -eq 0) {
                throw [RootDirCannotArchiveException]
            }
            return Join-Path $ParentDir $Script:ArchiveDirName
        }
    }
    hidden [System.Object]GetDateFromBeginningOfName() {
        <#
            .SYNOPSIS
            Get Date from the beginning of the file name.
        #>
        $Name = Split-Path $this.Path -Leaf
        if ($Name.Length -eq $this.Path.Length) {
            throw [RootDirCannotArchiveException]::new('Root directory cannot archive.')
        }
        if ($Name -match "^(?<Year>\d{4})(?<Month>\d{2})(?<Day>\d{2})\D") {
            try {
                return Get-Date -Year $Matches.Year -Month $Matches.Month -Day $Matches.Day -Hour 0 -Minute 0 -Second 0 -Millisecond 0
            } catch {
                throw [InvalidDateException]::new("Invalid date found.")
            }
        }
        throw [InvalidDateException]"Date string not found."
    }
    [String]GetDestinationDirectory() {
        <#
            .SYNOPSIS
            Get the destination directory.
        #>
        $Now = Get-Date

        try {
            $Date = $this.GetDateFromBeginningOfName()
        } catch [InvalidDateException] {
            return ''
        }

        try {
            $ArchiveDir = $this.GetArchiveDirectory()
        } catch [RootDirCannotArchiveException] {
            return ''
        }
        if ($Date.Year -lt $Now.Year) {
            $ArchiveDir = Join-Path $ArchiveDir (Get-Date $Date -Format 'yyyy')
        }
        return Join-Path $ArchiveDir (Get-Date $Date -Format 'yyyyMM')
    }
}

function Move-ItemToArchiveDirectoryByDateInName {
    <#
        .SYNOPSIS
        Move the file to a directory for archiving.

        .DESCRIPTION
        If the first eight characters of a file's name express a date,
        move the file to a directory for archiving.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [String[]]
        [Parameter(Mandatory,ValueFromRemainingArguments)]
        $Path
    )
    $Path |
    ForEach-Object {
        $AbsPath = Resolve-Path $_
        $SourcePath = [SourcePath]::new($AbsPath)
        $DestDir = $SourcePath.GetDestinationDirectory()
        if ($DestDir -ne '') {
            New-Item -ItemType Directory -Force $DestDir
            Move-Item -Path $AbsPath -Destination $DestDir
        }
    }
}

Export-ModuleMember -Function Move-ItemToArchiveDirectoryByDateInName
