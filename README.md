# PowerShell Advanced Script

Collection of advanced PowerShell scripts and automation examples for infrastructure health checks, SQL automation, Hyper-V and vCenter management, remoting, Outlook integration, REST API usage, and Excel automation.

This repo contains reusable PowerShell utilities and examples used across service and product environments. The author has worked on automation projects in both the service and product industries and has applied these scripts to real-world operational and provisioning workflows.

## Repository contents

- Health_check.ps1  
  - General server/service health check script for common OS and service-level checks.
  - https://github.com/piyushv080/PowerShell_Advanced_Script/blob/master/Health_check.ps1

- Hyper-v environment health check.ps1  
  - Comprehensive Hyper-V host and VM health checks and reporting.
  - https://github.com/piyushv080/PowerShell_Advanced_Script/blob/master/Hyper-v%20environment%20health%20check.ps1

- Multiple_Server_Ping.ps1  
  - Simple multi-host reachability/ping check with aggregated results.
  - https://github.com/piyushv080/PowerShell_Advanced_Script/blob/master/Multiple_Server_Ping.ps1

- sql_installation.ps1  
  - Automates SQL Server installation tasks and prechecks.
  - https://github.com/piyushv080/PowerShell_Advanced_Script/blob/master/sql_installation.ps1

- sql_patching.ps1  
  - Automates patching/maintenance tasks for SQL Server.
  - https://github.com/piyushv080/PowerShell_Advanced_Script/blob/master/sql_patching.ps1

- vcenter_capacity_management.ps1  
  - vCenter/VMware capacity checks and reporting automation.
  - https://github.com/piyushv080/PowerShell_Advanced_Script/blob/master/vcenter_capacity_management.ps1

Directories:
- Outlook Integration/ — scripts to automate Outlook tasks and send reports
  - https://github.com/piyushv080/PowerShell_Advanced_Script/tree/master/Outlook%20Integration
- PS Remoting/ — examples of PS Remoting usage for multi-host orchestration
  - https://github.com/piyushv080/PowerShell_Advanced_Script/tree/master/PS%20Remoting
- REST API/ — examples for calling and consuming REST APIs from PowerShell
  - https://github.com/piyushv080/PowerShell_Advanced_Script/tree/master/REST%20API
- excel automation/ — Excel automation examples (read/write/export)
  - https://github.com/piyushv080/PowerShell_Advanced_Script/tree/master/excel%20automation

## Quickstart & prerequisites

1. PowerShell
   - Windows PowerShell 5.1 or PowerShell 7.x (depending on the script and modules used).
2. Execution policy
   - Run as Administrator and set policy if necessary: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Modules & permissions
   - Some scripts require additional modules (e.g., VMware.PowerCLI, SqlServer) or administrative privileges.
   - Install required modules using: `Install-Module -Name <ModuleName> -Scope CurrentUser`
4. Credentials
   - Many scripts will prompt for credentials or accept secure credential objects. Use `Get-Credential` when needed.
5. Run examples
   - From an elevated PowerShell prompt: `.\Health_check.ps1 -TargetServer "server01.domain.local" -Verbose`
   - For scripts accepting lists: `Get-Content servers.txt | ForEach-Object { .\Multiple_Server_Ping.ps1 -Server $_ }`

Note: Each script typically contains parameter blocks and inline comments. Open the script to see exact parameters and options.

## Usage tips & best practices

- Review parameters and comments inside each script before running in production.
- Test in a development or staging environment first.
- When automating across many systems, use throttling and error handling (try/catch) to avoid overwhelming services.
- Log outputs to timestamped files and keep a retention policy for logs.
- Use secure credential storage (Windows Credential Manager, Azure Key Vault) instead of hardcoding credentials.

## Examples

- Run a Hyper-V health check and export results to CSV:
  - `.\Hyper-v\ environment\ health\ check.ps1 -ExportCsv "C:\Reports\hv_health_$(Get-Date -Format yyyyMMdd).csv"`

- Patch SQL servers from a list:
  - `Get-Content sql_servers.txt | ForEach-Object { .\sql_patching.ps1 -ServerName $_ -Credential (Get-Credential) }`

(Each script contains its own examples and parameter descriptions. Open the file for specifics.)

## Structure & conventions

- Scripts use param() blocks where appropriate.
- Scripts include comments and basic logging.
- Filenames reflect the primary function for easy discovery.

## Contribution

Contributions, improvements, and bug reports are welcome.

- Create an issue describing your change or enhancement.
- Fork the repo, add your changes on a branch, and open a pull request.
- Follow standard PowerShell best practices and include brief descriptions and usage examples.

## Author & background

Maintained by @piyushv080 (https://github.com/piyushv080).  
Experience: worked on automation projects across both service and product industries — building scripts and tools used for operational health checks, provisioning, capacity management, and deployment automation.
