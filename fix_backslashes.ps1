
$files = @(
    "chapters/MTH234_Module2.tex",
    "chapters/MTH234_Module2_All_Questions.tex",
    "chapters/MTH234_Module1.tex",
    "chapters/MTH234_Module1_All_Questions.tex"
)   

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        # Fix double backslash created by error
        $content = $content.Replace("\\vec{", "\vec{")
        # Fix u = \vec... issue (if any)
        # Check u = \begin{bmatrix}
        # In my script I had: "\\vec{`$1} = \begin{brack"
        # Since I used "\\vec", this also put \\vec{u} = \begin...
        # The replace above "\\vec{" -> "\vec{" fixes this too.
        
        # Check for other \\vec occurrences
        # $v$ -> $\\vec{v}$?
        # My script: "$\vec{`$1}$" -> This one used single backslash?
        # $pattern = "\\\$\s*([uvw])\s*\\\$"
        # $content = [Regex]::Replace($content, $pattern, "$\vec{`$1}$")
        # In PS file, I wrote "$\vec{`$1}$". 
        # So "$\vec{v}$". This one should be correct (single slash).
        
        # Checking:
        # $content = $content -replace "\\mathbf\{$char\}", "\vec{$char}"
        # In script I wrote "\vec{$char}". This is definitely single slash.
        
        # So only the Regex replace lines where I explicitly wrote "\\vec" are affected.
        # Lines 26, 33 were affected.
        
        Set-Content -Path $file -Value $content -Encoding UTF8
        Write-Host "Fixed backslashes in $file"
    }
}
