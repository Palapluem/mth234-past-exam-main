
# 1. Frontmatter Fixes
$frontmatterFiles = Get-ChildItem "frontmatter/*.tex"
foreach ($file in $frontmatterFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if ($content -match "นั้นๆ") {
        $content = $content -replace "นั้นๆ", "นั้น ๆ"
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Fixed 'nut-n' in $($file.Name)"
    }
}

# 2. Module 1 Fixes
$mod1Files = @("chapters/MTH234_Module1.tex", "chapters/MTH234_Module1_All_Questions.tex")
foreach ($path in $mod1Files) {
    if (Test-Path $path) {
        $content = Get-Content $path -Raw -Encoding UTF8
        
        # Q3 (a) Remove outer parens
        $content = $content -replace "\\part ค่าดีเทอร์มิแนนต์ของ \$A\$ \(\$\\det\(A\)\$\)", "\part ค่าดีเทอร์มิแนนต์ของ `$A`$ `$\det A`$"
        # Note: actually regex escaping is tricky. String literal replacement is safer for exact strings.
        # Let's try direct replacement of the string we saw.
        # Original: \part ค่าดีเทอร์มิแนนต์ของ $A$ ($\det(A)$)
        # Target: \part ค่าดีเทอร์มิแนนต์ของ $A$ $\det A$   <-- user said "ไม่ต้องมีวงเล็บ detA", I assume removing parens around detA function call too based on typical notation, or just the outer ones?
        # "ข้อ 3 ตรง (a) ไม่ต้องมีวงเล็บ detA" -> "No parens detA". 
        # "ข้อ B ไม่ต้องมีวงเล็บ (A^(-1))" -> "No parens (A^(-1))".
        # I will remove outer parens for both. And for detA, I will also remove inner parens if they exist in strict notation preference, but let's stick to modifying what's there.
        # Actually, let's look at the file content again.
        # Line 152: \part ค่าดีเทอร์มิแนนต์ของ $A$ ($\det(A)$)
        # Line 155: \part เมทริกซ์ผกผันของ $A$ ($A^{-1}$) (ถ้ามี)
        
        $content = $content.Replace("\part ค่าดีเทอร์มิแนนต์ของ `$A`$ (`$\det(A)`$)", "\part ค่าดีเทอร์มิแนนต์ของ `$A`$ `$\det A`$")
        $content = $content.Replace("\part เมทริกซ์ผกผันของ `$A`$ (`$A^{-1}`$) (ถ้ามี)", "\part เมทริกซ์ผกผันของ `$A`$ `$A^{-1}`$ (ถ้ามี)")

        # Q6 Spacing
        # Pattern:
        # \begin{parts}
        #    \part ไม่มีผลเฉลย (no solution)
        #    \part มีผลเฉลยชุดเดียว (unique solution)
        #    \part มีผลเฉลยมากมายไม่จำกัด (infinitely many solutions)
        # \end{parts}
        
        $q6Old = "\begin{parts}`r`n    \part ไม่มีผลเฉลย (no solution)`r`n    \part มีผลเฉลยชุดเดียว (unique solution)`r`n    \part มีผลเฉลยมากมายไม่จำกัด (infinitely many solutions)`r`n\end{parts}"
        
        $q6New = "\begin{parts}`r`n    \part ไม่มีผลเฉลย (no solution)`r`n    \vfill`r`n    \part มีผลเฉลยชุดเดียว (unique solution)`r`n    \vfill`r`n    \part มีผลเฉลยมากมายไม่จำกัด (infinitely many solutions)`r`n\end{parts}`r`n\vfill"
        
        # Normalize newlines for matching
        if ($content -match "\Q\begin{parts}\E\s+\Q\part ไม่มีผลเฉลย (no solution)\E\s+\Q\part มีผลเฉลยชุดเดียว (unique solution)\E\s+\Q\part มีผลเฉลยมากมายไม่จำกัด (infinitely many solutions)\E\s+\Q\end{parts}\E") {
             # We found it, but exact string replace is safer if whitespace varies.
             # Let's use regex replace.
             $content = $content -replace "(\\begin\{parts\}\s+\\part ไม่มีผลเฉลย \(no solution\)\s+\\part มีผลเฉลยชุดเดียว \(unique solution\)\s+\\part มีผลเฉลยมากมายไม่จำกัด \(infinitely many solutions\)\s+\\end\{parts\})", 
                                          "\begin{parts}`n    \part ไม่มีผลเฉลย (no solution)`n    \vfill`n    \part มีผลเฉลยชุดเดียว (unique solution)`n    \vfill`n    \part มีผลเฉลยมากมายไม่จำกัด (infinitely many solutions)`n\end{parts}`n\vfill"
             Write-Host "Fixed Q6 spacing in $path"
        }
        
        Set-Content -Path $path -Value $content -Encoding UTF8
    }
}

# 3. Module 2 Fixes
$mod2Files = @("chapters/MTH234_Module2.tex", "chapters/MTH234_Module2_All_Questions.tex")
foreach ($path in $mod2Files) {
    if (Test-Path $path) {
        $content = Get-Content $path -Raw -Encoding UTF8
        
        # Q6 (b) Add vector arrow to v
        # Old: ของ $v$ บน
        # New: ของ $\vec{v}$ บน
        if ($content -match "ของ \$v\$ บน") {
            $content = $content -replace "ของ \$v\$ บน", "ของ `$\vec{v}`$ บน"
            Write-Host "Fixed vector v text in $path"
        }
        
        # Old: ($\text{proj}_W v$)
        # New: ($\text{proj}_W \vec{v}$)
        if ($content -match "\(\$\\text\{proj\}_W v\$\)") {
            $content = $content -replace "\(\$\\text\{proj\}_W v\$\)", "(`$\text{proj}_W \vec{v}`$)"
            Write-Host "Fixed vector v in proj in $path"
        }
        
        Set-Content -Path $path -Value $content -Encoding UTF8
    }
}
