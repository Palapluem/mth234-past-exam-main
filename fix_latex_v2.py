
import os
import re

files = [
    "chapters/MTH234_Module2.tex",
    "chapters/MTH234_Module2_All_Questions.tex",
    "chapters/MTH234_Module1.tex",
    "chapters/MTH234_Module1_All_Questions.tex"
]

def process_file(filepath):
    print(f"Processing {filepath}...")
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return

    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return

    # 1. Replace (bases) with (basis)
    content = content.replace("(bases)", "(basis)")
    
    # 2. Vector Arrows
    # Replace \mathbf{x} with \vec{x}
    vector_letters = ['u', 'v', 'w', 'x', 'y', 'z', '0', 'p', 'b', 'c']
    for char in vector_letters:
        content = content.replace(f"\\mathbf{{{char}}}", f"\\vec{{{char}}}")

    # v_i, w_i -> \vec{v}_i
    content = re.sub(r"(?<!\\vec\{)\b([vwbucq])_(\d+|[ijk]|n)", r"\\vec{\1}_{\2}", content)
    
    # [v] -> [\vec{v}]
    content = re.sub(r"\[([uvw])\]", r"[\\vec{\1}]", content)
    
    # Definitions u = ...
    content = re.sub(r"(?<![a-zA-Z])([uvwz])\s*=\s*\\begin\{brack", r"\\vec{\1} = \\begin{brack", content) 
    
    # Projections
    content = re.sub(r"proj_W\s+([uvw])", r"proj_W \\vec{\1}", content)
    
    # Isolated variables in math $v$
    content = re.sub(r"\$\s*([uvw])\s*\$", r"$\\vec{\1}$", content)

    try:
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Successfully processed {filepath}")
    except Exception as e:
        print(f"Error writing {filepath}: {e}")

if __name__ == "__main__":
    for p in files:
        process_file(p)
