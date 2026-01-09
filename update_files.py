import os
import sys
import traceback

def safe_print(msg):
    try:
        print(msg)
    except:
        pass

def update_file(filepath, callback):
    if not os.path.exists(filepath):
        safe_print(f"File not found: {filepath}")
        return
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        safe_print(f"Error reading {filepath}: {e}")
        return
    
    safe_print(f"Reading {filepath}, size: {len(content)}")
    
    try:
        new_content = callback(content)
    except Exception as e:
        safe_print(f"Error processing {filepath}: {e}")
        traceback.print_exc()
        return

    if content != new_content:
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            safe_print(f"Updated: {filepath}")
        except Exception as e:
            safe_print(f"Error writing {filepath}: {e}")
    else:
        safe_print(f"No changes: {filepath}")

def process_mod1(content):
    if "\\det(A)" in content:
        safe_print("Found det(A) in content")
    else:
        safe_print("Did NOT find det(A) in content")

    content = content.replace("\\det(A)", "\\det A")
    
    # Check for the Thai block using repr to be safe
    idx = content.find("(a) ไม่มีผลเฉลย")
    if idx != -1:
        # Check if following lines match what we expect
        expected_block = "(a) ไม่มีผลเฉลย\n(b) มีผลเฉลยชุดเดียว\n(c) มีผลเฉลยมากมายไม่จำกัด"
        
        # Check if it matches
        if expected_block in content:
            safe_print("Found expected Thai block")
            replacement = "(a) ไม่มีผลเฉลย\\vfill\n(b) มีผลเฉลยชุดเดียว\\vfill\n(c) มีผลเฉลยมากมายไม่จำกัด"
            content = content.replace(expected_block, replacement)
        else:
            safe_print("Found (a) but not the full block exactly as expected.")
            safe_print(f"Actual around (a): {repr(content[idx:idx+80])}")

    return content

def process_mod2(content):
    old_v = "ของ $v$ บน"
    if old_v in content:
        safe_print("Found vector v text 1")
    content = content.replace(old_v, "ของ $\\vec{v}$ บน")
    
    old_v2 = "จากเวกเตอร์ $v$ ไปยัง"
    if old_v2 in content:
         safe_print("Found vector v text 2")
    content = content.replace(old_v2, "จากเวกเตอร์ $\\vec{v}$ ไปยัง")
    return content

def process_frontmatter(content):
    if "นั้นๆ" in content:
        safe_print("Found thai grammar issue")
    content = content.replace("นั้นๆ", "นั้น ๆ")
    return content

try:
    # Main execution
    base_dir = r"d:\mth234-past-exam-main"

    safe_print("--- Processing Module 1 ---")
    update_file(os.path.join(base_dir, "chapters", "MTH234_Module1_All_Questions.tex"), process_mod1)

    safe_print("--- Processing Module 2 ---")
    update_file(os.path.join(base_dir, "chapters", "MTH234_Module2_All_Questions.tex"), process_mod2)

    safe_print("--- Processing Frontmatter ---")
    frontmatter_dir = os.path.join(base_dir, "frontmatter")
    if os.path.exists(frontmatter_dir):
        for filename in os.listdir(frontmatter_dir):
            if filename.endswith(".tex"):
                update_file(os.path.join(frontmatter_dir, filename), process_frontmatter)
except Exception as e:
    safe_print(f"Global error: {e}")
    traceback.print_exc()
