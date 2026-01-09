
$files = @(
    "chapters/MTH234_Module2.tex",
    "chapters/MTH234_Module2_All_Questions.tex",
    "chapters/MTH234_Module1.tex",
    "chapters/MTH234_Module1_All_Questions.tex"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # DEFINITIONS with matrix
        # u = \begin{bmatrix}
        # Regex: (?<!\\vec\{)\b([uvwxyz])\s*=\s*\\begin\{(?:b|p|v|V|B)matrix
        $pattern = "(?<!\\vec\{)\b([uvwxyz])\s*=\s*\\begin\{(?:b|p|v|V|B)matrix"
        $content = [Regex]::Replace($content, $pattern, "\vec{`$1} = \begin{bmatrix")
        # Note: I force bmatrix in replacement, assuming most are bmatrix. 
        # Actually I should preserve the matrix type.
        # Replacement: \vec{$1} = \begin{$2
        $content = [Regex]::Replace($content, "(?<!\\vec\{)\b([uvwxyz])\s*=\s*\\begin\{(b|p|v|V|B)matrix", "\vec{`$1} = \begin{`$2matrix")
        
        # ISOLATED VECTORS in Math
        # $u$, $v$, $w$
        # Regex: \$\s*([uvw])\s*\$
        $content = [Regex]::Replace($content, "\\\$\s*([uvw])\s*\\\$", "$\vec{`$1}$")
        
        # VECTORS after 'vector' keyword (Thai or English) inside math
        # เวกเตอร์ $u = ...$ -> $u matches definition above.
        # But maybe "เวกเตอร์ $u$" without equals.
        # Pattern: (vector|เวกเตอร์)\s*\$([uvw])
        # Need to be careful not to double vec if already vec.
        # But if it's \vec{u}, regex ($[uvw]) won't match (because of {)
        $content = [Regex]::Replace($content, "(vector|เวกเตอร์)\s*\\\$\s*([uvw])\b", "`$1 $\vec{`$2}")
        
        # Replace $u$ in "เขียน $u$ ในรูป"
        # The isolated regex should handle this.
        
        # Coordinate vectors: [v]_...
        # Already handled by previous script?
        # Check if [v] is still there.
        # Regex for [v] where v is not \vec
        $content = [Regex]::Replace($content, "\[([uvw])\]", "[\vec{`$1}]")
        
        Set-Content -Path $file -Value $content -Encoding UTF8
        Write-Host "Processed $file"
    }
}
