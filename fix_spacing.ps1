
$files = @(
    "chapters/MTH234_Module2.tex",
    "chapters/MTH234_Module2_All_Questions.tex",
    "chapters/MTH234_Module1.tex",
    "chapters/MTH234_Module1_All_Questions.tex"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Replace [\vec{v}] with [\vec{v}\,] to add spacing
        # Pattern: \[\\vec\{([a-zA-Z])\}\]
        # Replacement: [\vec{$1}\,]
        
        # Using Regex
        # We look for [ followed by \vec{...} followed by ]
        # Double backslash for regex escape: \\[ and \\] for brackets
        # \\vec for \vec
        $pattern = "\[\\vec\{([a-zA-Z0-9])\}\]"
        $replacement = "[\vec{`$1}\,]"
        
        # Check if matches exist before writing
        if ($content -match $pattern) {
            $content = [Regex]::Replace($content, $pattern, $replacement)
            Set-Content -Path $file -Value $content -Encoding UTF8
            Write-Host "Fixed spacing in $file"
        }
    }
}
