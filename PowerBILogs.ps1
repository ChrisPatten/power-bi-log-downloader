Param(
    [DateTime]$StartDate,
    [int]$Days = 15,
    [int]$BatchSize = 5000,
    [int]$MaxResults = 100000000
)

# Calculate end date and set session id for paginated query
$EndDate = $StartDate.AddDays($Days).AddHours(23).AddMinutes(59).AddSeconds(59)
$SessionId = Get-Date

# Reset BatchSize to MaxResults if higher
If ($BatchSize -gt $MaxResults) {
    $BatchSize = $MaxResults
}

Write-Host "Getting Power BI Create/View activity for period $($StartDate.ToString("MM/dd/yyyy")) to $($EndDate.ToString("MM/dd/yyyy"))"

$HasResults = $true

# Do loop to collect results in batches until no more are returned
Do {

    # Update operations to return here
    $QueryResults = Search-UnifiedAuditLog -StartDate $StartDate -EndDate $EndDate `
        -RecordType PowerBIAudit -Operations ViewDashboard,ViewReport,CreateDashboard,CreateReport `
        -SessionId $SessionId -ResultSize $BatchSize

    $ResultSize = $QueryResults.Count

    If ($ResultSize -ge 1) { # If any results returned, save them

        Write-Host "Found $($ResultSize) results..."
        $Results += $QueryResults

    } Else {

        $HasResults = $false

    }

    If ($Results.Count -gt $MaxResults) { # Kill the loop if passes max result size

        Write-Host "Maximum result size ($($MaxResults)) was exceeded!"
        $HasResults = $false

    }
    
} While ($HasResults)

Write-Host "Total: $($Results.Count) results found! Last date: $((($Results | Measure-Object -Property CreationDate -Maximum).maximum).ToString("MM/dd/yyyy"))"

# Save results to CSV
$Results | Select-Object -Property CreationDate, UserIds, Operations, AuditData `
    | Export-Csv -NoTypeInformation -Path "AuditLog_$($StartDate.ToString("yyyy-MM-dd"))_$($EndDate.ToString("yyyy-MM-dd")).csv"


Write-Host "Complete!"