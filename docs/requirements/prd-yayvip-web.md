# PRD: YayVIP Web — Vernon Indonesia Pintar

**Versi:** 1.1.0
**Tanggal:** 2026-03-17
**Status:** In Progress
**Stack:** Flutter Web (Frontend)
**Platform:** Web (Chrome, Firefox, Safari, Edge)
**Author:** AI-Generated
**Related Docs:**
- Backend API Spec: `docs/requirements/backend-api-specification.md`
- Backend Request: `docs/requirements/backend-request-template.md`

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

**Out of Scope (Frontend):**
- Backend API / database (lihat: `backend-api-specification.md`)
- Server-side authentication (handled by backend)
- Payment gateway integration (handled by backend)
- CMS admin panel (separate backend project)
- Mobile app (terpisah, future phase)

**Security Notes:**
- Frontend tidak store token/credential di localStorage (use HTTP-only cookies)
- Semua API calls via HTTPS only
- CORS headers validation (trusted origins only)
- Input validation pada client-side (redundant safety layer)
- Tidak expose sensitive data di console/logs
- Regular security audit & dependency updates

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

## 6. Open Questions (RESOLVED)
- [x] Backend API specification → `backend-api-specification.md`
- [x] Payment gateway untuk donasi → See backend spec (Midtrans/Xendit)
- [ ] Gambar/foto asli untuk hero sections dan artikel
- [ ] QR Code pembayaran asli (generated by backend)
- [ ] Nomor telepon partnership yang benar

---

## 7. Frontend-Backend Integration

### Authentication & Tokens
- Token stored in **HTTP-only, Secure, SameSite cookies** (NOT localStorage)
- Token refresh automatic via refresh token endpoint
- Logout clears cookies & invalidates tokens
- 2FA handled by backend, validated on frontend

### API Calls
- All requests via HTTPS (enforce in production)
- Authorization header: `Authorization: Bearer {token}`
- CORS validation: browser enforces same-origin policy
- Retry logic for failed requests (exponential backoff)
- Request timeout: 30 seconds

### Form Submissions
- Client-side validation (UX improvement)
- Server-side validation enforced (security)
- Error messages from server used in UI
- Loading states during API calls

### Sensitive Data
- **Never** store passwords, tokens, or sensitive data locally
- **Never** log tokens, passwords, or PII in console
- **Never** expose error details (server stack traces, SQL queries)
- Use generic error messages: "Something went wrong, please try again"

---

## 8. Security Considerations

### Frontend Security
- **HTTPS only:** All API communication via HTTPS
- **Token management:** HTTP-only cookies (no XSS access to tokens)
- **CORS:** Browser enforces same-origin policy
- **CSP headers:** Prevent inline scripts, restrict resource loading
- **Input validation:** Sanitize user inputs before submission
- **Dependency security:** Regular npm audit & updates
- **No hardcoded secrets:** API keys/credentials via environment variables

### Coordination with Backend
- Backend enforces authentication on all endpoints
- Backend validates all inputs (never trust client)
- Backend implements rate limiting
- Backend logs all security events
- Backend encrypts sensitive data
- See: `backend-api-specification.md` for security details

### Related Documentation
- **Complete Backend Security Spec:** `docs/requirements/backend-api-specification.md`
- **OWASP Top 10 Coverage:** See backend spec sections 11-12
- **PCI-DSS Compliance:** Backend handles payment security

---

## 9. Testing Requirements

### Frontend Testing
- [ ] Unit tests for components (min 70% coverage)
- [ ] Integration tests for pages & navigation
- [ ] E2E tests for critical user flows
- [ ] Responsive design tests (mobile, tablet, desktop)
- [ ] Accessibility tests (keyboard nav, screen readers)
- [ ] Security tests (no sensitive data in console/logs)

### Security Testing
- [ ] No tokens/credentials in localStorage
- [ ] HTTPS enforced (test with HTTP → HTTPS redirect)
- [ ] CORS headers validated
- [ ] Input validation prevents XSS
- [ ] No hardcoded secrets in code
- [ ] Dependency vulnerability scan

---
*Updated: 2026-03-17*
