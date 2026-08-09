# 💳 จดบัตรเครดิต

เว็บแอปจดบันทึกรายการใช้จ่ายบัตรเครดิต ใช้ได้หลายคน แต่ละคน login แยกกัน เห็นเฉพาะข้อมูลของตัวเอง

**ความสามารถ**

- แยกได้หลายบัตร ตั้งชื่อ เลือกสีบัตรได้ (มีสีเงินด้วย)
- จดรายการ: วันที่ / ชื่อรายการ / ราคา (มีเครื่องคิดเลขในตัว) / หมวดหมู่พร้อมไอคอน / สถานที่
- กดที่รายการเพื่อดูรายละเอียดเต็มแบบ dropdown พร้อมปุ่มแก้ไข/ลบ
- รวมยอดอัตโนมัติ: ยอดทั้งหมดต่อบัตร, ค้างจ่ายต่อบัตร, ค้างจ่ายรวมทุกบัตร, ใช้ไปเดือนนี้
- ติ๊ก "จ่ายแล้ว / ยังไม่จ่าย" ทีละรายการ หรือกดปุ่ม **จ่ายบิล** เพื่อเลือกหลายรายการแล้วกดยืนยันทีเดียว
- ส่งออกเป็นไฟล์ CSV เปิดใน Excel / Google Sheets ได้
- ติดตั้งเป็นแอปได้ (PWA) ทั้ง Android, iPhone และคอมพิวเตอร์

**เทคโนโลยี:** HTML/JS ล้วน (ไม่ต้อง build) + [Supabase](https://supabase.com) (ฐานข้อมูล Postgres + ระบบ login) + GitHub Pages (โฮสต์ฟรี)

---

## วิธีติดตั้ง (ทำครั้งเดียว ~10 นาที)

### 1) สร้างโปรเจกต์ Supabase

1. สมัคร/เข้าสู่ระบบที่ [supabase.com](https://supabase.com) → **New project**
2. ตั้งชื่อโปรเจกต์ เช่น `credit-card-tracker` เลือก region **Southeast Asia (Singapore)**
3. รอสร้างเสร็จ (~2 นาที)

### 2) สร้างตารางฐานข้อมูล

1. เมนูซ้าย → **SQL Editor** → **New query**
2. คัดลอกเนื้อหาทั้งหมดจากไฟล์ [`supabase-schema.sql`](supabase-schema.sql) มาวาง → กด **Run**

### 3) ปิดการยืนยันอีเมล (แนะนำ เพื่อให้เพื่อนสมัครใช้ได้ทันที)

1. เมนูซ้าย → **Authentication** → **Sign In / Providers** → **Email**
2. ปิดสวิตช์ **Confirm email** → Save

> ถ้าเปิด Confirm email ไว้ ผู้สมัครใหม่ต้องกดยืนยันในอีเมลก่อน และอีเมลฟรีของ Supabase มีโควต้าส่งจำกัดมาก (~2 ฉบับ/ชั่วโมง)

### 4) เอาค่าเชื่อมต่อมาใส่ในแอป

1. เมนูซ้าย → **Project Settings** → **API Keys / Data API**
2. คัดลอก **Project URL** และ **anon public key** (หรือ publishable key `sb_publishable_...`)
3. แก้ไฟล์ [`config.js`](config.js) ใน repo นี้:

```js
window.APP_CONFIG = {
  SUPABASE_URL: "https://xxxx.supabase.co",
  SUPABASE_ANON_KEY: "sb_publishable_... หรือ anon key",
};
```

> คีย์นี้เป็นคีย์ฝั่งหน้าเว็บ (public) เปิดเผยได้ ไม่ใช่ความลับ — ความปลอดภัยของข้อมูลถูกบังคับด้วย Row Level Security ที่ฐานข้อมูล

### 5) เปิด GitHub Pages

1. ที่ repo บน GitHub → **Settings** → **Pages**
2. หัวข้อ **Source** เลือก **GitHub Actions**
3. push โค้ด (หรือกด Re-run workflow ในแท็บ Actions) — เสร็จแล้วจะได้ลิงก์เว็บ เช่น
   `https://<username>.github.io/Credit-card/`

แชร์ลิงก์นี้ให้ใครก็ได้ แต่ละคนสมัครด้วยอีเมล + รหัสผ่านของตัวเอง ข้อมูลแยกกันโดยสมบูรณ์

---

## โครงสร้างไฟล์

| ไฟล์ | หน้าที่ |
|---|---|
| `index.html` | ตัวแอปทั้งหมด (หน้าเว็บ + โค้ด) |
| `config.js` | ค่าเชื่อมต่อ Supabase (URL + public key) |
| `supabase-schema.sql` | สคริปต์สร้างตาราง + Row Level Security |
| `manifest.json` | ทำให้ติดตั้งเป็นแอปบนมือถือได้ (PWA) |
| `.github/workflows/deploy-pages.yml` | Deploy ขึ้น GitHub Pages อัตโนมัติเมื่อ push |

## การติดตั้งเป็นแอปบนมือถือ

- **iPhone:** เปิดเว็บใน Safari → ปุ่มแชร์ ⬆️ → **เพิ่มไปยังหน้าจอโฮม**
- **Android:** เปิดเว็บใน Chrome → จะมีแบนเนอร์/เมนู **ติดตั้งแอป** ให้กด
