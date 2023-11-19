# Function to parse log and create HTML report
function Parse-LogToHTMLReport {
    param (
        [string]$logFilePath
    )

    # Check if the log file exists
    if (-not (Test-Path $logFilePath)) {
        Write-Host "Error: The specified log file does not exist."
        return
    }

    # Read the log file
    $logContent = Get-Content -Path $logFilePath

    # Randomly generate a number for the report name
    $reportNumber = Get-Random -Minimum 1000 -Maximum 10000
    $reportName = "Yara-Rule-$reportNumber.html"

    # Create HTML report
    $htmlTemplate = @"
<!DOCTYPE html>
<html>
<head>
    <title>Yara-Rules Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 20px;
        }
        .header {
            text-align: center;
            background-color: #333;
            color: white;
            padding: 10px;
            margin-bottom: 20px;
        }
        .statistics {
            margin-bottom: 20px;
        }
        .section {
            margin-bottom: 20px;
        }
        .alert {
            background-color: #FFB6C1; /* Light Pink */
            padding: 10px;
            margin-bottom: 10px;
        }
        .warning {
            background-color: #FFD700; /* Gold */
            padding: 10px;
            margin-bottom: 10px;
        }
        .notice {
            background-color: #87CEEB; /* Sky Blue */
            padding: 10px;
            margin-bottom: 10px;
        }
        .info {
            background-color: #90EE90; /* Light Green */
            padding: 10px;
            margin-bottom: 10px;
        }
         footer {
            text-align: center;
            background-color: lightgray;
            padding: 10px;
        }

        footer p {
            font-size: small;
            color: gray;
        
        }
        .log-box {
            background-color: #f9f9f9;
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 12px;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Yara-Rules Report</h1>
        <p>Report created by: ENG. Khaled M. Alshammri</p>
        <p>Date and time: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
    </div>

    <div class="statistics">
        <h2>Statistics</h2>
        <p>Alert: $(($logContent | Select-String -Pattern "ALERT").Count)</p>
        <p>Warning: $(($logContent | Select-String -Pattern "WARNING").Count)</p>
        <p>Notice: $(($logContent | Select-String -Pattern "NOTICE").Count)</p>
        <p>Info: $(($logContent | Select-String -Pattern "INFO").Count)</p>
    </div>

    <div class="section">
        <h2>Details</h2>
        <div class="log-box">
"@

    # Add log entries to HTML report
    foreach ($line in $logContent) {
        if ($line -match "ALERT") {
            $htmlTemplate += "<p class='alert'>$line</p>"
        }
        elseif ($line -match "WARNING") {
            $htmlTemplate += "<p class='warning'>$line</p>"
        }
        elseif ($line -match "NOTICE") {
            $htmlTemplate += "<p class='notice'>$line</p>"
        }
        elseif ($line -match "INFO") {
            $htmlTemplate += "<p class='info'>$line</p>"
        }
        else {
            $htmlTemplate += "<p>$line</p>"
        }
    }

    # Close HTML template
    $htmlTemplate += @"
        </div>
    </div>
          <footer>
    <p>Powered by <a href="https://github.com/ik0z">ENG. Khaled</a></p>
  </footer>
</body>
</html>
"@

    # Save HTML report to file
    $htmlReportPath = Join-Path -Path (Get-Location) -ChildPath $reportName
    $htmlTemplate | Out-File -FilePath $htmlReportPath

    Write-Host "HTML report generated: $htmlReportPath"
}

# Prompt user for log file path
$logFilePath = Read-Host "Enter the path to the log file"

# Parse the log and create HTML report
Parse-LogToHTMLReport -logFilePath $logFilePath
