$files = @(
    "chapters/MTH234_Module1.tex",
    "chapters/MTH234_Module1_All_Questions.tex",
    "chapters/MTH234_Module2.tex",
    "chapters/MTH234_Module2_All_Questions.tex"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        # Regex to match [\vec{v}], [\vec{v}\,], [\,\vec{v}], etc. with optional subscripts
        # Matches: \[ (start bracket)
        #          \s*(?:\\,)?\s* (optional thin space/whitespace)
        #          (\\vec\{[a-zA-Z]+\}(?:_[a-zA-Z0-9]+)?) (Capture Group 1: vector + optional subscript)
        #          \s*(?:\\,)?\s* (optional thin space/whitespace)
        #          \] (end bracket)
        $regex = '\[\s*(?:\\,)?\s*(\\vec\{[a-zA-Z]+\}(?:_[a-zA-Z0-9]+)?)\s*(?:\\,)?\s*\]'
        
        # Replacement: [\, Group1 \,]
        $replacement = '[\,$1\,]'
        
        $newContent = $content -replace $regex, $replacement
        
        if ($newContent -ne $content) {
            Set-Content -Path $file -Value $newContent -Encoding UTF8
            Write-Host "Updated $file"
        } else {
            Write-Host "No changes in $file"
        }
    } else {
        Write-Host "File not found: $file"
    }
}
