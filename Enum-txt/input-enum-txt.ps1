# Step 1: Prompt the user to enter the disk and path
$disk = Read-Host -Prompt "Enter the disk to search (e.g., C:)"
$path = Read-Host -Prompt "Enter the path to search (e.g., \Users)"

# Step 2: Enumerate text files
$textFiles = Get-ChildItem -Path "$disk$path" -Filter "*.txt" -Recurse -File -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName

# Step 3: Generate HTML report
$html = @"
<!DOCTYPE html>
<html dir="ltr" lang="ar">
<head>
<meta charset="UTF-8">
<style>
body {
  font-family: Arial, sans-serif;
  margin: 20px;
}
h1 {
  text-align: center;
}
.collapsible {
  background-color: #eee;
  color: #444;
  cursor: pointer;
  padding: 18px;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
  font-size: 15px;
  transition: background-color 0.3s;
}
.active, .collapsible:hover {
  background-color: #ccc;
}
.content {
  padding: 0 18px;
  display: none;
  overflow: hidden;
  background-color: #f1f1f1;
  color: black;
}
pre {
  white-space: pre-wrap;
  word-break: break-all;
  margin-top: 0;
}
</style>
</head>
<body>
<h1>Text Files Enumeration</h1>
"@

foreach ($file in $textFiles) {
    $content = Get-Content -Path $file -Raw -ErrorAction SilentlyContinue
    if ($content) {
        $fileName = Split-Path -Path $file -Leaf
        $filePath = Split-Path -Path $file -Parent
        $fileSize = (Get-Item -Path $file).Length

        # Add collapsible section for each file
        $html += @"
<button class="collapsible">$filePath\$fileName (Size: $fileSize bytes)</button>
<div class="content">
  <pre>$($content -replace "<", "&lt;" -replace ">", "&gt;")</pre>
</div>
"@
    }
}

$html += @"
<script>
var coll = document.getElementsByClassName("collapsible");
var i;

for (i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function() {
        this.classList.toggle("active");
        var content = this.nextElementSibling;
        if (content.style.display === "block") {
            content.style.display = "none";
        } else {
            content.style.display = "block";
        }
    });
}
</script>
</body>
</html>
"@

# Step 4: Save the report
$randomDigit = Get-Random -Minimum 100000 -Maximum 999999
$reportName = "enumtxt-$randomDigit.html"
$reportPath = Join-Path -Path $PSScriptRoot -ChildPath $reportName
$html | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "Report generated: $reportPath"
