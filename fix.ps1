
$files = @(
    "chapters/MTH234_Module2.tex",
    "chapters/MTH234_Module2_All_Questions.tex",
    "chapters/MTH234_Module1.tex",
    "chapters/MTH234_Module1_All_Questions.tex"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Processing $file"
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # 1. (bases) -> (basis)
        $content = $content -replace "\(bases\)", "(basis)"
        
        # 2. Vector arrows
        # \mathbf{x} -> \vec{x}
        $vector_letters = "u", "v", "w", "x", "y", "z", "0", "p", "b", "c"
        foreach ($char in $vector_letters) {
            # escape char for regex just in case, though these are safe
            $content = $content -replace "\\mathbf\{$char\}", "\vec{$char}"
        }
        
        # Regex replacements via .NET
        # v_1 -> \vec{v}_1
        # match v,w,b,u,c,q followed by _ and digit/letter, but NOT preceded by \vec{
        $pattern = "(?<!\\vec\{)\b([vwbucq])_(\d+|[ijk]|n)"
        $content = [Regex]::Replace($content, $pattern, "\\vec{`$1}_`$2")
        
        # [v] -> [\vec{v}]
        $content = [Regex]::Replace($content, "\[([uvw])\]", "[\vec{`$1}]")
        
        # u = \begin{brack...
        $pattern = "(?<![a-zA-Z])([uvwz])\s*=\s*\\begin\{brack"
        $content = [Regex]::Replace($content, $pattern, "\\vec{`$1} = \begin{brack")
        
        # proj_W v -> proj_W \vec{v}
        $content = [Regex]::Replace($content, "proj_W\s+([uvw])", "proj_W \vec{`$1}")
        
        # $v$ -> $\vec{v}$
        # Need to escape $ in regex pattern
        $pattern = "\\\$\s*([uvw])\s*\\\$"
        $content = [Regex]::Replace($content, $pattern, "$\vec{`$1}$")
        
        Set-Content -Path $file -Value $content -Encoding UTF8
    } else {
        Write-Host "File not found: $file"
    }
}
Write-Host "Done"
