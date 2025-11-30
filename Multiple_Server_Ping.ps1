# ===== Console Inputs =====
$RemoteComputer = Read-Host "Enter Remote Computer Name / IP"
$Username      = Read-Host "Enter Username"

Write-Host "Enter Password (input hidden):"
$Password = Read-Host -AsSecureString

$ListPath = Read-Host "Enter Server List File Path (Example: E:\ServerList.txt)"

# ===== Validate Server List File =====
if (!(Test-Path $ListPath)) {
    Write-Host "❌ Server list file not found at $ListPath. Exiting!" -ForegroundColor Red
    exit
}

# ===== Build Credentials Object =====
$Cred = New-Object System.Management.Automation.PSCredential ($Username, $Password)

# ===== Prepare Output Folder =====
$OutputFolder = "E:\PingOutput"
if (!(Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

# ===== Validate Remote Connection =====
Write-Host "🔎 Checking connection to remote computer: $RemoteComputer ..."
$reachable = Test-Connection -ComputerName $RemoteComputer -Count 2 -Quiet

if (!$reachable) {
    Write-Host "❌ Cannot reach $RemoteComputer. Please check name/IP and network. Exiting!" -ForegroundColor Red
    exit
}

Write-Host "✅ Connection successful! Running ping checks remotely..." -ForegroundColor Green

# ===== Remote Execution =====
Invoke-Command -ComputerName $RemoteComputer -Credential $Cred -ArgumentList $ListPath, $OutputFolder -ScriptBlock {

    param($ListPath, $OutputFolder)

    $servers    = Get-Content $ListPath
    $collection = @()

    $outputcsv = Join-Path $OutputFolder "PingStatus.csv"
    $outputtxt = Join-Path $OutputFolder "PingStatus.txt"

    foreach ($server in $servers) {

        if ([string]::IsNullOrWhiteSpace($server)) { continue }

        try {
            $result = Test-Connection -ComputerName $server -IPv4 -Count 1 -ErrorAction Stop -Quiet
            $ping   = if ($result) { "Alive" } else { "Dead" }
        }
        catch {
            $ping = "Unreachable/Error"
        }

        $status = [PSCustomObject]@{
            ServerName = $server.Trim()
            PingStatus = $ping
            TimeStamp  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        $collection += $status
    }

    # Save outputs
    $collection | Out-File $outputtxt
    $collection | Export-CSV -LiteralPath $outputcsv -NoTypeInformation
}

Write-Host "`n📁 Output saved to: $OutputFolder" -ForegroundColor Yellow
Write-Host "✅ Done! Check PingStatus.csv and PingStatus.txt inside the folder."