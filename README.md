# MTH234 Past Exam Repository

Repository นี้รวบรวมไฟล์ข้อสอบเก่าและแม่แบบสำหรับการจัดทำข้อสอบรายวิชา **MTH234 Linear Algebra** ของ มจธ. (KMUTT) โดยจัดเตรียมในรูปแบบ LaTeX พร้อมสำหรับการ Compile และใช้งาน

## โครงสร้างโปรเจกต์ (Project Structure)

```text
root/
├── MTH234_Module1_main.tex  # ไฟล์หลักสำหรับ Compile ข้อสอบ Module 1
├── MTH234_Module2_main.tex  # ไฟล์หลักสำหรับ Compile ข้อสอบ Module 2
├── MTH234_Module3_main.tex  # ไฟล์หลักสำหรับ Compile ข้อสอบ Module 3
├── chapters/                # เก็บไฟล์เนื้อหาข้อสอบ (Questions Body)
│   ├── MTH234_Module1.tex   # เนื้อหาข้อสอบ Module 1
│   ├── MTH234_Module2.tex   # เนื้อหาข้อสอบ Module 2
│   ├── MTH234_Module3.tex   # เนื้อหาข้อสอบ Module 3
├── frontmatter/             # เก็บไฟล์หน้าปก (Cover Pages)
│   ├── cover_MTH234_Module 1.tex
│   ├── cover_MTH234_Module 2.tex
│   ├── cover_MTH234_Module 3.tex
│   └── cover.tex            # แม่แบบหน้าปกมาตรฐาน
├── fonts/                   # โฟลเดอร์เก็บฟอนต์ (THSarabunNew)
├── images/                  # รูปภาพ logo และรูปประกอบข้อสอบ
└── README.md                # ไฟล์คำอธิบายโปรเจกต์
```

## รายละเอียดเนื้อหาในแต่ละไฟล์หลัก (Main Files)

### 1. MTH234_Module1.pdf (Matrices & Systems of Linear Equations)
*   **ครอบคลุมเนื้อหา**:
    *   การดำเนินการของเมทริกซ์ (Matrix Operations)
    *   ทรานสโพส (Transpose) และสมบัติพื้นฐาน
    *   การประยุกต์ใช้เมทริกซ์เบื้องต้น
    *   (เนื้อหารวมถึง Row Operations และ Determinants ในบริบทที่เกี่ยวข้อง)

### 2. MTH234_Module2.pdf (Vector Spaces)
*   **ครอบคลุมเนื้อหา**:
    *   ปริภูมิเวกเตอร์ (Vector Space) และ ปริภูมิย่อย (Subspace)
    *   การพิสูจน์คุณสมบัติของ Subspace ใน $P_3$ (พหุนาม)
    *   การแผ่ทั่ว (Span) และ การรวมเชิงเส้น (Linear Combination)
    *   ความเป็นอิสระเชิงเส้น (Linear Independence)
    *   ฐานหลัก (Basis) และ มิติ (Dimension)

### 3. MTH234_Module3.pdf (Linear Transformations & Diagonalization)
*   **ครอบคลุมเนื้อหา**:
    *   การแปลงเชิงเส้น (Linear Transformations)
    *   เคอร์เนล (Kernel), เรนจ์ (Range), นัลลิตี้ (Nullity), และ แรงค์ (Rank)
    *   การตรวจสอบฟังก์ชันหนึ่งต่อหนึ่ง (One-to-one) และทั่วถึง (Onto)
    *   ค่าเจาะจง (Eigenvalues) และ เวกเตอร์เจาะจง (Eigenvectors)
    *   การแปลงเป็นเมทริกซ์ทแยงมุม (Diagonalization)

## วิธีการใช้งาน (Usage)
โปรเจกต์นี้ใช้ **XeLaTeX** ในการ Compile เพื่อรองรับภาษาไทยได้อย่างสมบูรณ์

1.  **ติดตั้ง Font**: ตรวจสอบว่ามีฟอนต์ `THSarabunNew` ในเครื่อง หรือวางไว้ในโฟลเดอร์ `fonts/`
2.  **Compile**: สั่ง Run ไฟล์ `_main.tex` ของแต่ละ Module
    ```bash
    xelatex MTH234_Module1_main.tex
    ```
    *ระบบจะทำการรวมหน้าปก (จาก `frontmatter/`) และเนื้อหาข้อสอบ (จาก `chapters/`) เข้าด้วยกันเป็นไฟล์ PDF ฉบับสมบูรณ์โดยอัตโนมัติ*

## การแก้ไข (Editing)
*   **แก้ไขหน้าปก**: ไปที่โฟลเดอร์ `frontmatter/` เลือกไฟล์ `.tex` ที่ต้องการ
*   **แก้ไขโจทย์/เนื้อหา**: ไปที่โฟลเดอร์ `chapters/` เลือกไฟล์ตาม Module
*   **เพิ่มรูปภาพ**: นำไฟล์รูปลงใน `images/` (รองรับ `.png`, `.jpg`, `.svg`)

---
*Last Updated: 10 Jan 2026*
