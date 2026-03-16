# PRD: YayVIP Web — Vernon Indonesia Pintar

**Versi:** 1.0.0
**Tanggal:** 2026-03-16
**Status:** In Progress
**Stack:** Flutter Web
**Platform:** Web (Chrome, Firefox, Safari, Edge)
**Author:** AI-Generated

---

## 1. Overview

### 1.1 Latar Belakang
Yayasan Vernon Indonesia Pintar (VIP) membutuhkan website resmi untuk menginformasikan program beasiswa vokasional, menerima donasi, menampilkan cerita inspiratif penerima beasiswa, dan membuka peluang kemitraan dengan berbagai pihak.

### 1.2 Tujuan
- Menyediakan platform informasi lengkap tentang program beasiswa VIP
- Memudahkan calon penerima beasiswa mendaftar secara online
- Memfasilitasi donatur untuk berdonasi melalui QR Code
- Menampilkan transparansi dan cerita sukses penerima beasiswa
- Membuka channel kemitraan dengan korporat, lembaga pendidikan, dan pemerintah

### 1.3 Scope
**In Scope:**
- Landing page informatif (visi, misi, program, kontak)
- Halaman beasiswa (alur, syarat, 6 program, form pendaftaran)
- Halaman donasi (form donatur terdaftar/anonim, QR Code)
- Halaman cerita VIP (blog berita)
- Halaman partnership (6 jenis kemitraan, kontak)
- Dynamic content via JSON (editable tanpa rebuild)
- Responsive design (desktop, tablet, mobile)

**Out of Scope:**
- Backend API / database
- Autentikasi user
- Payment gateway integration
- CMS admin panel
- Mobile app (terpisah)

---

## 2. Target User
- **Calon Penerima Beasiswa:** Pemuda 17-25 tahun dari keluarga tidak mampu
- **Donatur:** Individu atau perusahaan yang ingin berdonasi
- **Mitra Potensial:** Korporat, lembaga pendidikan, pemerintah, media
- **Masyarakat Umum:** Yang ingin mengetahui program VIP

---

## 3. Screen & Navigation

| Screen | Route | Deskripsi |
|---|---|---|
| Landing Page | `/` | Hero, intro, visi/misi, kriteria beasiswa, sistem beasiswa, sistem donasi, realtime check, kontak |
| Beasiswa | `/beasiswa` | Hero slider, alur beasiswa (5 langkah), syarat, 6 program, form pendaftaran + donasi QR |
| Cerita VIP | `/cerita` | Hero, 1 featured article + 8 artikel grid |
| Partnership | `/partnership` | Hero, 6 jenis kemitraan, kontak partnership |
| Donasi | `/donasi` | Hero slider, form donatur terdaftar/anonim + QR Code, CTA download app |

**Navbar:** Beranda | Beasiswa | Cerita VIP | Partnership | Donasi

---

## 4. Non-Functional Requirements

| Kategori | Target |
|---|---|
| Load time (first paint) | < 3 detik |
| Browser support | Chrome, Firefox, Safari, Edge |
| Responsive | Desktop (≥1024px), Tablet (600-1024px), Mobile (<600px) |
| Content management | JSON files (editable tanpa rebuild) |
| Accessibility | Semantic HTML, keyboard navigation |

---

## 5. Feature Breakdown

### Feature 1: Landing Page
- [x] Hero section dengan tagline dan CTA
- [x] Introduction section
- [x] Vision & Mission section
- [x] Kriteria penerima beasiswa (4 kriteria)
- [x] Sistem beasiswa (3 langkah)
- [x] Sistem donasi (3 keunggulan)
- [x] Realtime check (transparansi)
- [x] Contact section
- [x] Footer

### Feature 2: Halaman Donasi
- [x] Hero slider (3 slide auto-rotate)
- [x] Form donatur terdaftar (nama, email, phone, nominal)
- [x] Donasi anonim langsung QR Code
- [x] CTA download aplikasi VIP

### Feature 3: Halaman Beasiswa
- [x] Hero slider (3 slide)
- [x] Alur beasiswa 5 langkah (horizontal/vertical responsive)
- [x] Syarat pendaftaran (6 syarat)
- [x] 6 program beasiswa (Barista, Digital Marketing, Admin, Desain, Teknisi, Culinary)
- [x] Form pendaftaran beasiswa
- [x] Tab donasi untuk beasiswa + QR Code

### Feature 4: Halaman Cerita VIP
- [x] Hero section
- [x] Featured article card
- [x] Grid artikel (9 kategori berbeda)

### Feature 5: Halaman Partnership
- [x] Hero section
- [x] 6 jenis kemitraan (Korporat, Penempatan Kerja, Magang, Pendidikan, Media, Pemerintah)
- [x] Contact section dengan statistik, telepon, email, alamat

### Feature 6: Dynamic Content System
- [x] ContentProvider service (JSON loader + cache)
- [x] 5 JSON content files
- [x] Semua section membaca dari ContentProvider
- [x] Preload saat app startup

### Feature 7: Branding
- [x] Logo VIP extracted dari proposal PDF
- [x] Favicon (32px), Icon-192, Icon-512, maskable icons
- [x] Color scheme: Merah VIP (#E53935), hitam, abu-abu

---

## 6. Open Questions
- [ ] Backend API belum ditentukan
- [ ] Payment gateway untuk donasi
- [ ] Gambar/foto asli untuk hero sections dan artikel
- [ ] QR Code pembayaran asli
- [ ] Nomor telepon partnership yang benar

---
*Updated: 2026-03-16*
