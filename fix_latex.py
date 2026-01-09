
import re
import os

files = [
    r"chapters\MTH234_Module2.tex",
    r"chapters\MTH234_Module2_All_Questions.tex",
    r"chapters\MTH234_Module1.tex",
    r"chapters\MTH234_Module1_All_Questions.tex"
]

def process_file(filepath):
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return

    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    # 1. Replace (bases) with (basis)
    content = content.replace("(bases)", "(basis)")
    
    # 2. Vector Arrows
    # Replace \mathbf{x} with \vec{x} for specific letters
    # u, v, w, x, y, z, 0, p
    # Note: 0 should be \vec{0}
    vector_letters = ['u', 'v', 'w', 'x', 'y', 'z', '0', 'p', 'b', 'c']
    for char in vector_letters:
        content = content.replace(f"\\mathbf{{{char}}}", f"\\vec{{{char}}}")

    # Explicit indexed vectors: v_1, w_2, etc. when not preceded by \vec
    # Avoid double replacing if I run script twice, but regex should handle raw v_1
    # Look for v_ followed by digit or char, but we want to wrap v in \vec
    # Patterns to match: " v_1 ", " w_2 ", "= v_1"
    # Be careful not to match things that are already part of a command or text.
    # Usually in math mode $...$ or \[...\]
    
    # Strategy: Replace specific known vector occurrences based on the file content analysis
    
    # v_i, w_i, b_i, c_i, u_i, q_i
    # e.g., v_1 -> \vec{v}_1
    # Regex: (?<!\\vec{)\b([vwbucq])_(\d+|[a-z])
    # This matches 'v_1' but not '\vec{v}_1'
    content = re.sub(r"(?<!\\vec\{)\b([vwbucq])_(\d+|[ijk]|n)", r"\\vec{\1}_{\2}", content)
    
    # Standalone vectors u, v, w, z in math context
    # This is risky for 'v' (velocity? just letter v?) or 'w' (weight?).
    # In this Linear Algebra context, u, v, w are almost always vectors.
    # Common patterns:
    # "u ="
    # "= u"
    # "[u]"
    # "u,"
    # "u "
    # " u "
    # "$u$"
    
    # We will be conservative.
    # Replace [v] -> [\vec{v}]
    content = re.sub(r"\[([uvw])\]", r"[\\vec{\1}]", content)
    
    # Replace " u = " etc.
    content = re.sub(r"(?<![a-zA-Z])([uvwz])\s*=\s*\\begin\{brack", r"\\vec{\1} = \\begin{brack", content) # u = [matrix]
    
    # Replace " u " in span definitions or lists: " u, " or " u}" or "{u "
    # but be careful of "u" in text.
    # We can try to target specific lines or nearby context if needed, but let's try a general safe-ish math regex.
    # Actually, simpler: looking at the provided file content,
    # u = ..., v = ...
    # S = {v_1, ...} -> handled by v_i replace above.
    # proj_W v -> proj_W \vec{v}
    content = re.sub(r"proj_W\s+([uvw])", r"proj_W \\vec{\1}", content)
    
    # Distance: distance(v, W) or similar? 
    # "จงหาระยะทาง (distance) จากเวกเตอร์ v" -> Here 'v' is in thai text but likely inside $v$.
    # "$v$" -> "$\vec{v}$"
    # We need to find all isolated $v$, $u$, $w$ and replace them.
    # Regex for $v$: \$\s*v\s*\$
    content = re.sub(r"\$\s*([uvw])\s*\$", r"$\\vec{\1}$", content)
    
    # Also $v, w$ in lists: $v, u$
    # Maybe just replace all isolated v, u, w in math mode?
    # It's hard to parse "Math mode" with simple regex.
    # However, in these files, u, v, w seem to be EXCLUSIVELY vectors when single letters.
    # Exception: w in "width" or something? Unlikely in this exam.
    # Reference to "row operations" might use u, v? No.
    # Let's try replacing `\b([uvwz])\b` but only if it looks like math.
    # Actually, let's look for specific definitions in the questions provided in prompt.
    
    # Contexts:
    # 1. $S = \{v_1, \dots\}$ -> v_1 handled.
    # 2. $u = \begin{bmatrix} ... $ -> handled.
    # 3. $v = ...$ -> handled.
    # 4. proj_W v -> handled.
    # 5. [v]_B -> handled.
    # 6. "Determine if vector u is in W" -> "vector $u$" -> handled by $u$.
    
    # Special case: u, v in Inner product <u, v> or similar?
    # Q9 in Extra: u, v, w, z defined.
    # They are already using \mathbf{...} which we convert to \vec{...}
    
    # Homogenous system: Ax = 0.
    # "x" here is a vector.
    # System equations like x_1 + x_2 ... -> x_1 is scalar.
    # So we should NOT replace x_1 with \vec{x}_1.
    # My regex `re.sub(r"(?<!\\vec\{)\b([vwbucq])_(\d+|[ijk]|n)", ...` INCLUDED 'x'?
    # No, I used `[vwbucq]`. I did NOT include 'x'. Good.
    # Because x_1 is scalar component.
    
    # But A\mathbf{x} = \mathbf{0} -> \vec{x}, \vec{0}.
    # My \mathbf replace handles this.
    
    # Check if there are instances of `Ax = 0` without mathbf.
    # "A\mathbf{x} = \mathbf{0}" in Question 4. Handled.
    
    # Module 1:
    # 2A - 3X -> X is matrix. Leave it.
    # Ax = b ?
    # "x + 2y + 5z = 15" -> scalars.
    
    # Module 2 Q4:
    # B = {p_1(x), ...}
    # p_1(x) -> p_1 is a vector (polynomial).
    # I did not include 'p' in my indexed regex.
    # Should I?
    # "p_1(x)" -> "\vec{p}_1(x)"?
    # Usually we don't arrow polynomials.
    # User said "If any are vectors, please write an arrow above them".
    # Polynomials ARE vectors in P_3.
    # But "p(x) = ax^3..."
    # Maybe leave polynomials alone unless they are referred to as just $p$.
    # e.g. "coordinate vector [p(x)]_B".
    # Users request: "ถ้าอันไหนเป็นเวกเตอร์ ช่วยเขียนลูกศรข้างบนด้วย"
    # I will stick to geometric vectors (column vectors) u, v, w, x.
    # And p if bolded.
    
    # Q5 Q6 in Module 2 have bases B, B'.
    # Vectors in basis: \begin{bmatrix}...
    # They don't have names.
    
    # "coordinate vector [v]_B" -> handled.
    
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Processed {filepath}")

for p in files:
    process_file(p)
