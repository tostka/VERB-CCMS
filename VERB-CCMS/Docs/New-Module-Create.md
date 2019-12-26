# How to create new module
---

```
$plasterParams = [ordered] @{
    TemplatePath = 'C:\sc\powershell\FullModuleTemplate' ; 
    DestinationPath = 'C:\sc\powershell\ModuleTest' ; 
    ModuleName = 'ModuleTest' ; 
    ModuleDesc = 'New Demo Module' ; 
} ; 
write-host -foregroundcolor green "$((get-date).ToString('HH:mm:ss')):Invoke-Plaster w`n$(($plasterParams|out-string).trim())" ; 
If  (-not(Test-Path  -Path  $plasterParams.DestinationPath  -PathType  Container))  {
    $pltDir=[ordered]@{
        Path=$plasterParams.DestinationPath  ;
        ItemType="Directory" ;
    } ; 
    write-host -foregroundcolor green "$((get-date).ToString('HH:mm:ss')):New-Item w`n$(($pltDir|out-string).trim())" ; 
    New-Item @pltDir |  Out-Null; 
} ;
Invoke-Plaster  @plasterParams ;

```
---
### Will result in:
```
  ____  _           _
 |  _ \| | __ _ ___| |_ ___ _ __
 | |_) | |/ _` / __| __/ _ \ '__|
 |  __/| | (_| \__ \ ||  __/ |
 |_|   |_|\__,_|___/\__\___|_|
                                            v1.1.3
==================================================
Initial module version (0.0.0.1):
Module Author (Todd Kadrie):
Module Author Git ID (Tostka):
Module Author's Public Email Address (tostka@users.noreply.github.com):
Company/Site Name (toddomation.com):
Company/Site URL (https://www.toddomation.com):
Author Twitter ID (@tostka):
Github Username (tostka):
BitBucket Username (tostka):
Github Repo Name For This Module (PowerShell):
Github Repo Url For This Module (https://github.com/tostka/PowerShell/):
Bitbucket Repo Name For This Module (PowerShell):
Bitbucket Repo Url For This Module (https://bitbucket.org/tostka/powershell/):
Minimum PowerShell version (3.0):
Select folders to include with this module
[P] Public
[I] Internal
[C] Classes
[?] Help
(default choices are P,I)
Choice[0]:
Include Git Support?
[Y] Yes  [N] No  [?] Help (default is "Y"):
Select a license for this module
[A] Apache  [M] MIT  [N] None  [?] Help (default is "M"):
Include Pester Tests?
[Y] Yes  [N] No  [?] Help (default is "Y"):
Include VSCode support?
[Y] Yes  [N] No  [?] Help (default is "Y"):
Include Docs folder?
[Y] Yes  [N] No  [?] Help (default is "Y"):
Include Dependancies support?
[Y] Yes  [N] No  [?] Help (default is "Y"):
Destination path: C:\sc\powershell\ModuleTest
          Creating Module:ModuleTest folders...
   Create Public\
   Create Internal\
          Configuring GIT support
   Create .gitignore
   Create README.md
          Adding MIT License file
   Create LICENSE.txt
          Adding CHANGELOG.md file
   Create CHANGELOG.md
          Configuring Pester support
   Verify The required module Pester (minimum version: 3.4.0) is already installed.
          Creating (Pester) Tests folder
   Create Tests\
   Create Tests\ModuleTest.tests.ps1
          Setting up support for VSCode
   Create .vscode\settings.json
   Create .vscode\launch.json
          Setting up support for PlatyPS
   Verify The required module PlatyPS (minimum version: 0.14.0) is already installed.
          Creating Docs folder
   Create Docs\
          Setting up Docs folder
   Create Docs\Cab\
   Create Docs\en-US\
   Create Docs\Markdown\
   Create Docs\Quick-Start-Installation-and-Example.md
   Create ModuleTest\Docs\New-Module-Create.md
          Configuring Dependancies support
   Create requirements.psd1
Creating project ModuleManifest .psd1:
   Create ModuleTest\ModuleTest.psd1
   Create ModuleTest\ModuleTest.psm1
PS> C:\s\powershell$ cd $plasterparams.destinationpath
PS> C:\s\p\ModuleTest$ tree /F
Folder PATH listing for volume OS
Volume serial number is 3869-E592
C:.
│   .gitignore
│   CHANGELOG.md
│   LICENSE.txt
│   README.md
│   requirements.psd1
│
├───.vscode
│       launch.json
│       settings.json
│
├───Docs
│   │   Quick-Start-Installation-and-Example.md
│   │
│   ├───Cab
│   ├───en-US
│   └───Markdown
├───Internal
├───ModuleTest
│   │   ModuleTest.psd1
│   │   ModuleTest.psm1
│   │
│   └───Docs
│           New-Module-Create.md
│
├───Public
└───Tests
        ModuleTest.tests.ps1

```
---
## Now you're ready to commit your module to Git
