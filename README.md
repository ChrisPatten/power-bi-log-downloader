# power-bi-log-downloader
A PowerShell script to handle downloading Power BI audit logs for further analysis. Run with `./Get-PowerBILogs.ps1`. 

# Table of Contents

* [Requirements](#requirements)
* [Syntax](#syntax)
* [Parameters](#parameters)
* [Output](#output)

# Requirements
You must have auditing enabled for your Power BI tenant (more info on [Power BI Admin Portal](https://docs.microsoft.com/en-us/power-bi/service-admin-portal#audit-logs) and [Using Auditing Within your Organization](https://docs.microsoft.com/en-us/power-bi/service-admin-auditing)). Additionally, you must be a Power BI Service admin, have an Exchange Online license, and have an Exchange admin role that provides access to the audit log.

This script uses the Exchange Online PowerShell module ([instructions here](https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/connect-to-exchange-online-powershell?view=exchange-ps)). My org uses multi-factor authentication, so I used [these instructions](https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps) to get started.

If you're using the normal Exchange Online module, you'll need to create your session first. If you're using the MFA version you'll need to launch the special PowerShell session and run the script from there.

# Syntax
```powershell
Get-PowerBILogs
  [-StartDate <ExDateTime>]
  [-Days <Int32>]
  [-BatchSize <Int32>]
  [-MaxResults <Int32>]
```

# Parameters
## `-StartDate`
The earliest date to return logs for. If you don't include a timestamp in the value for this parameter, the default timestamp is 12:00 AM on the specified date.

| | |
| --- | --- |
| Type: | ExDateTime |
| Position: | 1 |
| Default value: | 16 days before current date |
| Accept pipeline input: | False |
| Accept wildcard characters: | False |

## `-Days`
The number of days from `-StartDate` to return logs for.

| | |
| --- | --- |
| Type: | Int32 |
| Position: | 2 |
| Default value: | 15 |
| Accept pipeline input: | False |
| Accept wildcard characters: | False |

## `-BatchSize`
The number of records to return per query callout. The default and maximum are 5,000

| | |
| --- | --- |
| Type: | Int32 |
| Position: | Named |
| Default value: | 5000 |
| Accept pipeline input: | False |
| Accept wildcard characters: | False |

## `-MaxResults`
The maximum number of records to return.

| | |
| --- | --- |
| Type: | Int32 |
| Position: | Named |
| Default value: | 100,000,000 |
| Accept pipeline input: | False |
| Accept wildcard characters: | False |

# Output
Saves a CSV file with the results to the same directory with a filename `AuditLog_<StartDate>_<EndDate>.csv` (e.g. `AuditLog_2018-08-01_2018-08-15.csv`).

By default, the script only returns ViewDashboard, ViewReport, CreateDashboard, and CreateReport operations.
