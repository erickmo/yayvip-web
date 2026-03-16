# YayVIP Web - Backend API Specification

**Version:** 1.0
**Last Updated:** 2026-03-17
**Status:** Ready for Backend Development

---

## Table of Contents
1. [Overview](#overview)
2. [Response Format](#response-format)
3. [Authentication](#authentication)
4. [Data Donatur](#data-donatur)
5. [Data Beasiswa](#data-beasiswa)
6. [Pendaftaran Beasiswa](#pendaftaran-beasiswa)
7. [Data Siswa](#data-siswa)
8. [Data Donasi](#data-donasi)
9. [User Management](#user-management)
10. [General Requirements](#general-requirements)
11. [Security Requirements](#security-requirements)
12. [OWASP Top 10 Mitigation](#owasp-top-10-mitigation)
13. [Recommended Tech Stack](#recommended-tech-stack)

---

## Overview

YayVIP Web Backend API supports 7 main features:
- **Authentication**: OAuth + JWT + 2FA
- **Data Donatur**: Self-service + Admin management
- **Data Beasiswa**: Workflow-based (Draft → Approved → Active → Closed)
- **Pendaftaran Beasiswa**: Application tracking (Draft → Submit → Review → Approved)
- **Data Siswa**: Admin-managed student master data
- **Data Donasi**: Payment gateway integration
- **User Management**: Role-based access control with fine-grained permissions

**Key Constraints:**
- No DELETE for: donations, donors, students, users (soft-delete only)
- All responses must follow standard JSON structure
- All timestamps in ISO 8601 format (UTC)
- All IDs auto-generated with prefixes

---

## Response Format

All API responses must follow this structure:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": {},
  "errors": null
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Validation failed",
  "data": null,
  "errors": {
    "field_name": ["error message 1", "error message 2"]
  }
}
```

**HTTP Status Codes:**
- `200` - Success
- `201` - Created
- `400` - Bad request (validation error)
- `401` - Unauthorized
- `403` - Forbidden (insufficient permissions)
- `404` - Not found
- `409` - Conflict (duplicate resource)
- `429` - Rate limited
- `500` - Server error

---

## Authentication

**Type:** OAuth 2.0 + JWT + 2FA
**Token Expiry:** Access Token (15 min), Refresh Token (7 days)
**Roles:** super-admin, admin, staff, donatur, siswa

### Endpoints

#### 1. Register User
```
POST /auth/register
Content-Type: application/json

Request:
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "role": "donatur|siswa|staff|admin"
}

Response (201):
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user_id": "USR-12345",
    "email": "user@example.com",
    "role": "donatur"
  }
}
```

#### 2. Login with Email/Password
```
POST /auth/login
Content-Type: application/json

Request:
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}

Response (200):
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user_id": "USR-12345",
    "email": "user@example.com",
    "role": "donatur",
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "expires_in": 900
  }
}
```

**Validations:**
- Email unique & valid format
- Password: min 8 chars, uppercase, number, special char
- Rate limit: max 5 attempts per 15 minutes (per IP)

#### 3. Google OAuth Login
```
POST /auth/google-login
Content-Type: application/json

Request:
{
  "id_token": "google_id_token_here",
  "role": "donatur|siswa"
}

Response (200):
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user_id": "USR-12346",
    "email": "user@gmail.com",
    "role": "donatur",
    "access_token": "...",
    "refresh_token": "...",
    "is_new_user": true
  }
}
```

#### 4. Facebook OAuth Login
```
POST /auth/facebook-login
Content-Type: application/json

Request:
{
  "access_token": "facebook_access_token_here",
  "role": "donatur|siswa"
}

Response (200): Same as Google OAuth
```

#### 5. Refresh Access Token
```
POST /auth/refresh-token
Content-Type: application/json

Request:
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
}

Response (200):
{
  "success": true,
  "message": "Token refreshed",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "expires_in": 900
  }
}
```

#### 6. Request Password Reset
```
POST /auth/password-reset
Content-Type: application/json

Request:
{
  "email": "user@example.com"
}

Response (200):
{
  "success": true,
  "message": "Reset link sent to email",
  "data": null
}
```

**Logic:**
- Generate token valid for 1 hour
- Send reset link via email
- Token should be single-use

#### 7. Reset Password with Token
```
POST /auth/reset-password/{reset_token}
Content-Type: application/json

Request:
{
  "new_password": "NewSecurePass123!"
}

Response (200):
{
  "success": true,
  "message": "Password reset successful"
}
```

#### 8. Request 2FA Code
```
POST /auth/2fa/request
Authorization: Bearer {access_token}

Request:
{
  "method": "sms|email"
}

Response (200):
{
  "success": true,
  "message": "2FA code sent to registered phone/email"
}
```

#### 9. Verify 2FA Code
```
POST /auth/2fa/verify
Authorization: Bearer {access_token}

Request:
{
  "code": "123456"
}

Response (200):
{
  "success": true,
  "message": "2FA verified",
  "data": {
    "is_verified": true
  }
}
```

**Logic:**
- Code valid for 10 minutes
- Max 3 attempts per request

#### 10. Logout
```
POST /auth/logout
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "message": "Logged out successfully"
}
```

**Logic:**
- Invalidate refresh token
- Log logout event

#### 11. Get Auth Audit Log
```
GET /auth/audit-log?limit=20&offset=0&user_id={user_id}
Authorization: Bearer {access_token}
(Admin only)

Response (200):
{
  "success": true,
  "data": {
    "logs": [
      {
        "audit_log_id": "AUD-1001",
        "user_id": "USR-12345",
        "action": "login|logout|password_change|2fa_verify",
        "ip_address": "192.168.1.1",
        "user_agent": "Mozilla/5.0...",
        "status": "success|failed",
        "timestamp": "2026-03-17T10:30:00Z"
      }
    ],
    "total": 150,
    "limit": 20,
    "offset": 0
  }
}
```

---

## Data Donatur

**Description:** Donor profile & management
**CRUD:** Create (Admin), Read (Admin/Self), Update (Admin/Self), Delete (Soft-delete)
**Auto-generate ID:** Yes (format: DID-XXXXX)
**Status:** active, inactive

### Endpoints

#### 1. Create Donatur (Admin Only)
```
POST /donatur
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin only)

Request:
{
  "nama": "Budi Santoso",
  "email": "budi@example.com",
  "phone": "08123456789",
  "jenis_donor": "personal|corporate",
  "alamat": "Jl. Merdeka No. 123",
  "kota": "Jakarta",
  "provinsi": "DKI Jakarta",
  "bank_account": "123456789",
  "nama_bank": "BCA",
  "nama_pemilik_rekening": "Budi Santoso"
}

Response (201):
{
  "success": true,
  "message": "Donatur created",
  "data": {
    "donor_id": "DID-ABC123",
    "nama": "Budi Santoso",
    "email": "budi@example.com",
    "status": "active",
    "created_at": "2026-03-17T10:30:00Z"
  }
}
```

**Validations:**
- Email: unique, valid format
- Phone: unique, valid Indonesian format
- Bank account: numeric, required if jenis_donor=personal

#### 2. List Donatur (Admin Only)
```
GET /donatur?limit=20&offset=0&search=&status=&sort_by=nama&sort_order=asc
Authorization: Bearer {access_token}
(Admin only)

Response (200):
{
  "success": true,
  "data": {
    "donatur": [
      {
        "donor_id": "DID-ABC123",
        "nama": "Budi Santoso",
        "email": "budi@example.com",
        "phone": "08123456789",
        "jenis_donor": "personal",
        "status": "active",
        "total_donasi": 5000000,
        "created_at": "2026-03-17T10:30:00Z"
      }
    ],
    "total": 100,
    "limit": 20,
    "offset": 0
  }
}
```

**Query Parameters:**
- `limit` (default: 20, max: 100)
- `offset` (default: 0)
- `search` - search by nama, email, phone
- `status` - filter by status
- `sort_by` - nama, email, created_at
- `sort_order` - asc, desc

#### 3. Get Donatur Detail
```
GET /donatur/{donor_id}
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "donor_id": "DID-ABC123",
    "nama": "Budi Santoso",
    "email": "budi@example.com",
    "phone": "08123456789",
    "jenis_donor": "personal",
    "alamat": "Jl. Merdeka No. 123",
    "kota": "Jakarta",
    "provinsi": "DKI Jakarta",
    "bank_account": "123456789",
    "nama_bank": "BCA",
    "nama_pemilik_rekening": "Budi Santoso",
    "status": "active",
    "created_at": "2026-03-17T10:30:00Z",
    "updated_at": "2026-03-17T10:30:00Z"
  }
}
```

**Access:**
- Admin: dapat access semua donatur
- Donatur: hanya access profil sendiri (token user_id = donor_id)

#### 4. Update Donatur (Admin + Self)
```
PUT /donatur/{donor_id}
Authorization: Bearer {access_token}
Content-Type: application/json

Request:
{
  "nama": "Budi Santoso Updated",
  "phone": "08987654321",
  "alamat": "Jl. Gatot Subroto No. 456",
  "bank_account": "987654321",
  "nama_bank": "Mandiri"
}

Response (200):
{
  "success": true,
  "message": "Donatur updated",
  "data": { ...donatur object }
}
```

**Access:**
- Admin: dapat update semua field
- Donatur (self): dapat update personal fields (nama, phone, alamat, bank_account) - tidak bisa ubah email

#### 5. Change Donatur Status (Admin Only)
```
PATCH /donatur/{donor_id}/status
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin only)

Request:
{
  "status": "active|inactive",
  "reason": "Donor request inactive" (optional)
}

Response (200):
{
  "success": true,
  "message": "Status updated",
  "data": {
    "donor_id": "DID-ABC123",
    "status": "inactive",
    "updated_at": "2026-03-17T10:30:00Z"
  }
}
```

#### 6. Get Donatur Donation History
```
GET /donatur/{donor_id}/donations?limit=20&offset=0
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "donations": [
      {
        "donasi_id": "DON-XYZ789",
        "nominal": 500000,
        "payment_status": "completed",
        "payment_method": "transfer_bank",
        "created_at": "2026-03-15T14:00:00Z"
      }
    ],
    "total": 25,
    "total_amount": 12500000
  }
}
```

---

## Data Beasiswa

**Description:** Scholarship program master data
**CRUD:** Create (Admin/Staff), Read (Public/Admin), Update (Admin/Staff), Delete (Soft-delete)
**Workflow:** Draft → Approved → Active → Closed
**Auto-generate ID:** Yes (format: BEA-XXXXX)

### Endpoints

#### 1. Create Beasiswa (Admin/Staff)
```
POST /beasiswa
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin/Staff)

Request:
{
  "nama": "Beasiswa Unggulan VIP",
  "deskripsi": "Program beasiswa untuk siswa berprestasi...",
  "kategori": "akademik|non_akademik|kesehatan|lingkungan|lainnya",
  "jenjang": "SMP|SMA|SMK|D3|S1",
  "benefit": "Rp 1.000.000/bulan, buku gratis, mentoring",
  "kuota": 50,
  "syarat_umum": "Aktif di sekolah, tidak sedang menerima beasiswa lain",
  "syarat_khusus": "Prestasi akademik minimal 3.5 IPK",
  "tanggal_pembukaan": "2026-04-01",
  "tanggal_penutupan": "2026-06-30"
}

Response (201):
{
  "success": true,
  "message": "Beasiswa created in draft status",
  "data": {
    "beasiswa_id": "BEA-ABC123",
    "nama": "Beasiswa Unggulan VIP",
    "status": "draft",
    "kuota": 50,
    "kuota_terpakai": 0,
    "created_by": "STF-001",
    "created_at": "2026-03-17T10:30:00Z"
  }
}
```

#### 2. List Beasiswa (Public - Active Only)
```
GET /beasiswa?limit=20&offset=0&kategori=&jenjang=&sort_by=&sort_order=asc
Content-Type: application/json

Response (200):
{
  "success": true,
  "data": {
    "beasiswa": [
      {
        "beasiswa_id": "BEA-ABC123",
        "nama": "Beasiswa Unggulan VIP",
        "deskripsi": "...",
        "kategori": "akademik",
        "jenjang": "SMA",
        "benefit": "Rp 1.000.000/bulan",
        "kuota": 50,
        "kuota_terpakai": 30,
        "tanggal_penutupan": "2026-06-30",
        "status": "active"
      }
    ],
    "total": 6
  }
}
```

**Note:** Public endpoint returns only `status = "active"`

#### 3. List Beasiswa (Admin - All)
```
GET /beasiswa/admin?limit=20&offset=0&status=&search=&sort_by=&sort_order=
Authorization: Bearer {access_token}
(Admin/Staff)

Response (200): Same struktur, tapi semua status
```

#### 4. Get Beasiswa Detail
```
GET /beasiswa/{beasiswa_id}
Authorization: Bearer {access_token} (optional)

Response (200):
{
  "success": true,
  "data": {
    "beasiswa_id": "BEA-ABC123",
    "nama": "Beasiswa Unggulan VIP",
    "deskripsi": "...",
    "kategori": "akademik",
    "jenjang": "SMA",
    "benefit": "Rp 1.000.000/bulan, buku gratis, mentoring",
    "kuota": 50,
    "kuota_terpakai": 30,
    "syarat_umum": "...",
    "syarat_khusus": "...",
    "tanggal_pembukaan": "2026-04-01T00:00:00Z",
    "tanggal_penutupan": "2026-06-30T23:59:59Z",
    "status": "active",
    "created_by": "STF-001",
    "created_at": "2026-03-17T10:30:00Z",
    "updated_by": "STF-001",
    "updated_at": "2026-03-17T10:30:00Z"
  }
}
```

#### 5. Update Beasiswa (Admin/Staff)
```
PUT /beasiswa/{beasiswa_id}
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin/Staff, only if status = draft|approved)

Request:
{
  "nama": "Beasiswa Unggulan VIP Updated",
  "kuota": 60,
  ...other fields
}

Response (200): Updated beasiswa object
```

**Validation:**
- Cannot update if status = active or closed (must change status first)
- Kuota tidak boleh kurang dari kuota_terpakai

#### 6. Change Beasiswa Status (Admin Only)
```
PATCH /beasiswa/{beasiswa_id}/status
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin only)

Request:
{
  "status": "approved|active|closed",
  "reason": "Sudah approved oleh founder" (optional)
}

Response (200):
{
  "success": true,
  "message": "Status changed to active",
  "data": {
    "beasiswa_id": "BEA-ABC123",
    "status": "active",
    "updated_at": "2026-03-17T10:30:00Z"
  }
}
```

**Workflow Rules:**
- draft → approved (by admin)
- approved → active (by admin)
- active → closed (by admin)
- Any status → draft (revert)

#### 7. Get Beasiswa Audit Log
```
GET /beasiswa/{beasiswa_id}/audit-log
Authorization: Bearer {access_token}
(Admin only)

Response (200):
{
  "success": true,
  "data": {
    "logs": [
      {
        "audit_id": "AUD-2001",
        "action": "create|update|status_change",
        "changed_fields": ["nama", "kuota"],
        "old_values": {"kuota": 50},
        "new_values": {"kuota": 60},
        "changed_by": "STF-001",
        "timestamp": "2026-03-17T10:30:00Z"
      }
    ]
  }
}
```

#### 8. Get Registrants for Beasiswa
```
GET /beasiswa/{beasiswa_id}/registrants?limit=20&offset=0&status=
Authorization: Bearer {access_token}
(Admin/Staff)

Response (200):
{
  "success": true,
  "data": {
    "registrants": [
      {
        "beasiswa_pendaftaran_id": "BEP-001",
        "siswa_id": "SID-123",
        "nama_siswa": "Andi Wijaya",
        "status": "submitted|review|approved|rejected",
        "submitted_at": "2026-03-15T14:00:00Z"
      }
    ],
    "total": 30
  }
}
```

---

## Pendaftaran Beasiswa

**Description:** Scholarship application tracking
**CRUD:** Create (Siswa), Read (Siswa/Admin), Update (Siswa on draft), Delete (Soft-delete)
**Workflow:** Draft → Submitted → Review → Approved/Rejected → Accepted
**Auto-generate ID:** Yes (format: BEP-XXXXX)

### Endpoints

#### 1. Create Application (Draft)
```
POST /beasiswa-pendaftaran
Authorization: Bearer {access_token}
Content-Type: application/json
(Siswa)

Request:
{
  "siswa_id": "SID-12345",
  "beasiswa_id": "BEA-ABC123"
}

Response (201):
{
  "success": true,
  "message": "Application created in draft status",
  "data": {
    "beasiswa_pendaftaran_id": "BEP-001",
    "siswa_id": "SID-12345",
    "beasiswa_id": "BEA-ABC123",
    "status": "draft",
    "created_at": "2026-03-17T10:30:00Z"
  }
}
```

#### 2. List Applications
```
GET /beasiswa-pendaftaran?limit=20&offset=0&status=&beasiswa_id=&siswa_id=
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "applications": [
      {
        "beasiswa_pendaftaran_id": "BEP-001",
        "siswa_id": "SID-12345",
        "nama_siswa": "Andi Wijaya",
        "beasiswa_id": "BEA-ABC123",
        "nama_beasiswa": "Beasiswa Unggulan VIP",
        "status": "submitted",
        "submitted_at": "2026-03-16T14:00:00Z",
        "created_at": "2026-03-17T10:30:00Z"
      }
    ],
    "total": 50
  }
}
```

**Access:**
- Siswa: see own applications only
- Admin/Staff: see all applications

#### 3. Get Application Detail
```
GET /beasiswa-pendaftaran/{beasiswa_pendaftaran_id}
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "beasiswa_pendaftaran_id": "BEP-001",
    "siswa_id": "SID-12345",
    "nama_siswa": "Andi Wijaya",
    "sekolah": "SMA Negeri 1 Jakarta",
    "beasiswa_id": "BEA-ABC123",
    "nama_beasiswa": "Beasiswa Unggulan VIP",
    "status": "submitted",
    "dokumen": [
      {
        "dokumen_id": "DOK-001",
        "nama_file": "rapor_semester_1.pdf",
        "tipe": "rapor",
        "url": "https://cdn.yayvip.com/documents/...",
        "uploaded_at": "2026-03-16T14:00:00Z"
      }
    ],
    "reviewed_by": null,
    "reviewed_at": null,
    "alasan_reject": null,
    "submitted_at": "2026-03-16T14:00:00Z",
    "created_at": "2026-03-17T10:30:00Z"
  }
}
```

#### 4. Update Application (Draft Only)
```
PUT /beasiswa-pendaftaran/{beasiswa_pendaftaran_id}
Authorization: Bearer {access_token}
Content-Type: application/json
(Siswa, only status = draft)

Request:
{
  "data": {
    // data tambahan jika ada form fields
  }
}

Response (200): Updated application object
```

#### 5. Submit Application
```
PATCH /beasiswa-pendaftaran/{beasiswa_pendaftaran_id}/submit
Authorization: Bearer {access_token}
Content-Type: application/json
(Siswa, only status = draft)

Request:
{
  // empty body
}

Response (200):
{
  "success": true,
  "message": "Application submitted",
  "data": {
    "beasiswa_pendaftaran_id": "BEP-001",
    "status": "submitted",
    "submitted_at": "2026-03-17T10:30:00Z"
  }
}
```

**Logic:**
- Check kuota beasiswa tidak exceed
- If exceed → status = pending/waitlist? (TBD based on requirements)
- Set submitted_at timestamp

#### 6. Change Application Status (Admin Only)
```
PATCH /beasiswa-pendaftaran/{beasiswa_pendaftaran_id}/status
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin/Staff)

Request:
{
  "status": "review|approved|rejected|accepted",
  "alasan_reject": "GPA tidak memenuhi syarat" (optional, required if rejected)
}

Response (200):
{
  "success": true,
  "message": "Status updated",
  "data": {
    "beasiswa_pendaftaran_id": "BEP-001",
    "status": "approved",
    "reviewed_by": "STF-001",
    "reviewed_at": "2026-03-17T10:30:00Z"
  }
}
```

#### 7. Upload Document
```
POST /beasiswa-pendaftaran/{beasiswa_pendaftaran_id}/documents
Authorization: Bearer {access_token}
Content-Type: multipart/form-data
(Siswa, only status = draft|submitted)

Request:
{
  "file": <binary>,
  "tipe": "rapor|sertifikat|foto|lainnya"
}

Response (201):
{
  "success": true,
  "message": "Document uploaded",
  "data": {
    "dokumen_id": "DOK-001",
    "nama_file": "rapor_semester_1.pdf",
    "tipe": "rapor",
    "url": "https://cdn.yayvip.com/documents/...",
    "uploaded_at": "2026-03-17T10:30:00Z"
  }
}
```

**Validations:**
- File size max 10MB
- Allowed types: PDF, JPG, PNG
- Max 10 documents per application

#### 8. List Documents
```
GET /beasiswa-pendaftaran/{beasiswa_pendaftaran_id}/documents
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "dokumen": [
      {
        "dokumen_id": "DOK-001",
        "nama_file": "rapor.pdf",
        "tipe": "rapor",
        "url": "https://...",
        "uploaded_at": "2026-03-16T14:00:00Z"
      }
    ]
  }
}
```

#### 9. Delete Document
```
DELETE /beasiswa-pendaftaran/{beasiswa_pendaftaran_id}/documents/{dokumen_id}
Authorization: Bearer {access_token}
(Siswa, only status = draft)

Response (200):
{
  "success": true,
  "message": "Document deleted"
}
```

---

## Data Siswa

**Description:** Student master data (admin-managed, no student login)
**CRUD:** Create (Admin), Read (Admin), Update (Admin), Delete (Soft-delete)
**Auto-generate ID:** Yes (format: SID-XXXXX)
**Status:** aktif, lulus, dropout, alumni

### Endpoints

#### 1. Create Siswa (Admin Only)
```
POST /siswa
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin only)

Request:
{
  "nama": "Andi Wijaya",
  "email": "andi@example.com",
  "phone": "08123456789",
  "tanggal_lahir": "2008-05-15",
  "jenis_kelamin": "laki-laki|perempuan",
  "sekolah": "SMA Negeri 1 Jakarta",
  "kelas": "12A",
  "jenjang": "SMA",
  "alamat": "Jl. Merdeka No. 123",
  "kota": "Jakarta",
  "provinsi": "DKI Jakarta",
  "nama_wali": "Bapak Wijaya",
  "phone_wali": "08987654321"
}

Response (201):
{
  "success": true,
  "message": "Siswa created",
  "data": {
    "siswa_id": "SID-ABC123",
    "nama": "Andi Wijaya",
    "email": "andi@example.com",
    "status": "aktif",
    "created_at": "2026-03-17T10:30:00Z"
  }
}
```

#### 2. List Siswa (Admin Only)
```
GET /siswa?limit=20&offset=0&status=&search=&jenjang=&sekolah=
Authorization: Bearer {access_token}
(Admin only)

Response (200):
{
  "success": true,
  "data": {
    "siswa": [
      {
        "siswa_id": "SID-ABC123",
        "nama": "Andi Wijaya",
        "email": "andi@example.com",
        "sekolah": "SMA Negeri 1 Jakarta",
        "jenjang": "SMA",
        "status": "aktif",
        "created_at": "2026-03-17T10:30:00Z"
      }
    ],
    "total": 200
  }
}
```

#### 3. Get Siswa Detail
```
GET /siswa/{siswa_id}
Authorization: Bearer {access_token}
(Admin only)

Response (200):
{
  "success": true,
  "data": {
    "siswa_id": "SID-ABC123",
    "nama": "Andi Wijaya",
    "email": "andi@example.com",
    "phone": "08123456789",
    "tanggal_lahir": "2008-05-15",
    "jenis_kelamin": "laki-laki",
    "sekolah": "SMA Negeri 1 Jakarta",
    "kelas": "12A",
    "jenjang": "SMA",
    "alamat": "Jl. Merdeka No. 123",
    "kota": "Jakarta",
    "provinsi": "DKI Jakarta",
    "nama_wali": "Bapak Wijaya",
    "phone_wali": "08987654321",
    "status": "aktif",
    "created_at": "2026-03-17T10:30:00Z"
  }
}
```

#### 4. Update Siswa (Admin Only)
```
PUT /siswa/{siswa_id}
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin only)

Request:
{
  "nama": "Andi Wijaya Updated",
  "sekolah": "SMA Negeri 2 Jakarta",
  "kelas": "12B"
}

Response (200): Updated siswa object
```

#### 5. Change Siswa Status (Admin Only)
```
PATCH /siswa/{siswa_id}/status
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin only)

Request:
{
  "status": "aktif|lulus|dropout|alumni"
}

Response (200):
{
  "success": true,
  "message": "Status updated",
  "data": {
    "siswa_id": "SID-ABC123",
    "status": "lulus"
  }
}
```

#### 6. Get Siswa Scholarship Applications
```
GET /siswa/{siswa_id}/beasiswa-pendaftaran
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "applications": [
      {
        "beasiswa_pendaftaran_id": "BEP-001",
        "beasiswa_id": "BEA-ABC123",
        "nama_beasiswa": "Beasiswa Unggulan VIP",
        "status": "approved",
        "submitted_at": "2026-03-16T14:00:00Z"
      }
    ]
  }
}
```

#### 7. Get Siswa Donations Received
```
GET /siswa/{siswa_id}/donasi-terima
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "donations": [
      {
        "donasi_id": "DON-XYZ789",
        "donor_id": "DID-ABC123",
        "nama_donor": "Budi Santoso",
        "nominal": 500000,
        "tujuan_donasi": "Bantuan biaya sekolah",
        "created_at": "2026-03-15T14:00:00Z"
      }
    ],
    "total_received": 2000000
  }
}
```

---

## Data Donasi

**Description:** Donation transaction tracking with payment gateway integration
**CRUD:** Create (Donatur/Admin), Read (Donatur/Admin), Update (Admin), Delete (Soft-delete ONLY)
**Payment Status:** pending, verified, completed, failed, refunded
**Auto-generate ID:** Yes (format: DON-XXXXX)

### Endpoints

#### 1. Create Donation Request
```
POST /donasi
Authorization: Bearer {access_token} (optional for anonymous)
Content-Type: application/json

Request:
{
  "donor_id": "DID-ABC123" (optional, null for anonymous),
  "nama_donor": "Budi Santoso",
  "email_donor": "budi@example.com",
  "phone_donor": "08123456789",
  "nominal_donasi": 500000,
  "payment_method": "bank_transfer|e_wallet|kartu_kredit",
  "tujuan_donasi": "Bantuan siswa berprestasi" (optional),
  "catatan": "Semoga bermanfaat" (optional)
}

Response (201):
{
  "success": true,
  "message": "Donation request created",
  "data": {
    "donasi_id": "DON-XYZ789",
    "nominal_donasi": 500000,
    "nominal_setelah_biaya": 485000,
    "payment_status": "pending",
    "payment_link": "https://payment-gateway.com/pay/xyz789",
    "payment_method": "bank_transfer",
    "created_at": "2026-03-17T10:30:00Z",
    "expired_at": "2026-03-17T12:30:00Z"
  }
}
```

**Payment Gateway Logic:**
- Generate payment link via Midtrans/Xendit/Doku
- Payment link valid for 2 hours
- Include payment method selection in response

#### 2. List Donations
```
GET /donasi?limit=20&offset=0&status=&payment_method=&date_from=&date_to=
Authorization: Bearer {access_token}
(Admin only)

Response (200):
{
  "success": true,
  "data": {
    "donations": [
      {
        "donasi_id": "DON-XYZ789",
        "donor_id": "DID-ABC123",
        "nama_donor": "Budi Santoso",
        "nominal_donasi": 500000,
        "nominal_setelah_biaya": 485000,
        "payment_method": "bank_transfer",
        "payment_status": "completed",
        "tujuan_donasi": "Bantuan siswa",
        "created_at": "2026-03-15T14:00:00Z",
        "completed_at": "2026-03-15T14:15:00Z"
      }
    ],
    "total": 150,
    "total_amount": 75000000
  }
}
```

#### 3. Get Donation Detail
```
GET /donasi/{donasi_id}
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "donasi_id": "DON-XYZ789",
    "donor_id": "DID-ABC123",
    "nama_donor": "Budi Santoso",
    "email_donor": "budi@example.com",
    "phone_donor": "08123456789",
    "nominal_donasi": 500000,
    "nominal_biaya_admin": 15000,
    "nominal_setelah_biaya": 485000,
    "payment_method": "bank_transfer",
    "payment_status": "completed",
    "payment_gateway_ref_id": "MID-12345678",
    "payment_proof_url": "https://cdn.yayvip.com/proofs/...",
    "tujuan_donasi": "Bantuan siswa",
    "catatan": "Semoga bermanfaat",
    "invoice_url": "https://cdn.yayvip.com/invoices/DON-XYZ789.pdf",
    "receipt_url": "https://cdn.yayvip.com/receipts/DON-XYZ789.pdf",
    "created_at": "2026-03-15T14:00:00Z",
    "verified_at": "2026-03-15T14:15:00Z",
    "completed_at": "2026-03-15T14:15:00Z"
  }
}
```

#### 4. Payment Verification Webhook
```
POST /donasi/webhook/payment-verify
Content-Type: application/json

Request (from payment gateway):
{
  "payment_id": "DON-XYZ789",
  "status": "settlement|failed|pending",
  "transaction_id": "MID-12345678",
  "amount": 500000,
  "timestamp": "2026-03-15T14:15:00Z"
}

Response (200):
{
  "success": true,
  "message": "Payment verified"
}
```

**Logic:**
- Verify webhook signature from payment gateway
- Update donation status based on payment gateway response
- Log webhook event for audit trail
- Handle idempotency (same webhook may come multiple times)

#### 5. Get Invoice
```
GET /donasi/{donasi_id}/invoice
Authorization: Bearer {access_token}

Response (200, PDF):
[PDF file download]
```

**Invoice Should Include:**
- Donasi ID, tanggal
- Nama donatur & data lengkap
- Nominal & biaya admin
- Tujuan donasi
- QR code pembayaran (if applicable)

#### 6. Get Receipt
```
GET /donasi/{donasi_id}/receipt
Authorization: Bearer {access_token}

Response (200, PDF):
[PDF file download]
```

**Receipt Should Include:**
- Bukti transaksi pembayaran
- Status pembayaran
- Nominal yang diterima
- Tanggal & waktu
- Referensi transaksi dari payment gateway

#### 7. List Donations Per Donatur
```
GET /donatur/{donor_id}/donasi
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "donations": [ ... ],
    "total": 25,
    "total_amount": 12500000
  }
}
```

#### 8. Manual Status Update (Admin Only)
```
PATCH /donasi/{donasi_id}/status
Authorization: Bearer {access_token}
Content-Type: application/json
(Admin only, rare case)

Request:
{
  "status": "verified|failed|refunded",
  "reason": "Manual verification by admin" (required)
}

Response (200):
{
  "success": true,
  "message": "Status updated manually",
  "data": { ...donation object }
}
```

---

## User Management

**Description:** Admin/staff user accounts with role-based permissions
**CRUD:** Create (Super-Admin), Read (Super-Admin/Admin), Update (Super-Admin), Delete (Soft-delete)
**Roles:** super-admin, admin, staff
**Auto-generate ID:** Yes (format: USR-XXXXX)
**Status:** active, inactive, suspended

### Endpoints

#### 1. Create User (Super-Admin Only)
```
POST /users
Authorization: Bearer {access_token}
Content-Type: application/json
(Super-Admin only)

Request:
{
  "nama": "Ahmad Hartanto",
  "email": "ahmad@yayvip.com",
  "phone": "08123456789",
  "role": "admin|staff",
  "password": "InitialPass123!"
}

Response (201):
{
  "success": true,
  "message": "User created",
  "data": {
    "user_id": "USR-XYZ123",
    "nama": "Ahmad Hartanto",
    "email": "ahmad@yayvip.com",
    "role": "admin",
    "status": "active",
    "created_at": "2026-03-17T10:30:00Z"
  }
}
```

**Validations:**
- Email: unique, valid format, must be @yayvip.com or allowed domain
- Password: min 8 chars, uppercase, number, special char
- Role must be admin or staff

#### 2. List Users (Super-Admin Only)
```
GET /users?limit=20&offset=0&role=&status=&search=
Authorization: Bearer {access_token}
(Super-Admin only)

Response (200):
{
  "success": true,
  "data": {
    "users": [
      {
        "user_id": "USR-XYZ123",
        "nama": "Ahmad Hartanto",
        "email": "ahmad@yayvip.com",
        "phone": "08123456789",
        "role": "admin",
        "status": "active",
        "last_login": "2026-03-17T08:00:00Z",
        "created_at": "2026-03-17T10:30:00Z"
      }
    ],
    "total": 15
  }
}
```

#### 3. Get User Detail
```
GET /users/{user_id}
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "user_id": "USR-XYZ123",
    "nama": "Ahmad Hartanto",
    "email": "ahmad@yayvip.com",
    "phone": "08123456789",
    "role": "admin",
    "status": "active",
    "permissions": [
      "manage_siswa",
      "manage_donatur",
      "manage_beasiswa",
      "review_applications",
      "manage_donasi"
    ],
    "last_login": "2026-03-17T08:00:00Z",
    "password_changed_at": "2026-03-01T10:00:00Z",
    "created_at": "2026-03-17T10:30:00Z"
  }
}
```

#### 4. Update User (Super-Admin Only)
```
PUT /users/{user_id}
Authorization: Bearer {access_token}
Content-Type: application/json
(Super-Admin only)

Request:
{
  "nama": "Ahmad Hartanto Updated",
  "phone": "08987654321"
}

Response (200): Updated user object

Note: Cannot update email via PUT (separate endpoint)
```

#### 5. Change User Password
```
PATCH /users/{user_id}/password
Authorization: Bearer {access_token}
Content-Type: application/json

Request:
{
  "current_password": "InitialPass123!",
  "new_password": "NewSecurePass456!"
}

Response (200):
{
  "success": true,
  "message": "Password changed",
  "data": {
    "password_changed_at": "2026-03-17T10:30:00Z"
  }
}
```

**Validations:**
- Current password harus match
- New password: min 8 chars, uppercase, number, special char
- Cannot reuse last 5 passwords

#### 6. Change User Status (Super-Admin Only)
```
PATCH /users/{user_id}/status
Authorization: Bearer {access_token}
Content-Type: application/json
(Super-Admin only)

Request:
{
  "status": "active|inactive|suspended",
  "reason": "User left company" (optional)
}

Response (200):
{
  "success": true,
  "message": "User status updated",
  "data": {
    "user_id": "USR-XYZ123",
    "status": "inactive"
  }
}
```

#### 7. Change User Role (Super-Admin Only)
```
PATCH /users/{user_id}/role
Authorization: Bearer {access_token}
Content-Type: application/json
(Super-Admin only)

Request:
{
  "role": "admin|staff"
}

Response (200):
{
  "success": true,
  "message": "User role updated",
  "data": {
    "user_id": "USR-XYZ123",
    "role": "staff",
    "permissions": [ ... new permissions ]
  }
}
```

#### 8. Get User Permissions
```
GET /users/{user_id}/permissions
Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "data": {
    "role": "admin",
    "permissions": [
      {
        "permission_id": "PERM-001",
        "name": "manage_siswa",
        "description": "Create, read, update, delete siswa"
      },
      ...
    ]
  }
}
```

#### 9. Get Audit Logs (Super-Admin Only)
```
GET /audit-logs?limit=20&offset=0&user_id=&action=&date_from=&date_to=
Authorization: Bearer {access_token}
(Super-Admin only)

Response (200):
{
  "success": true,
  "data": {
    "logs": [
      {
        "audit_log_id": "AUD-3001",
        "user_id": "USR-XYZ123",
        "action": "create_siswa|update_beasiswa|change_status|login|logout",
        "resource_type": "siswa|beasiswa|donasi|user",
        "resource_id": "SID-ABC123",
        "changes": {
          "old_values": {},
          "new_values": {}
        },
        "ip_address": "192.168.1.1",
        "user_agent": "Mozilla/5.0...",
        "timestamp": "2026-03-17T10:30:00Z"
      }
    ],
    "total": 5000
  }
}
```

#### 10. Get Audit Log Per User (Super-Admin Only)
```
GET /audit-logs?user_id={user_id}&limit=20&offset=0
Authorization: Bearer {access_token}
(Super-Admin only)

Response (200): Same as above, filtered by user
```

### Permission Model

**Admin Permissions:**
- `manage_siswa` - CRUD siswa
- `manage_donatur` - CRUD donatur
- `manage_beasiswa` - CRUD beasiswa
- `review_applications` - Review beasiswa applications
- `manage_donasi` - View & verify donasi
- `view_reports` - View donation & scholarship reports
- `manage_staff` - Manage staff users only

**Staff Permissions:**
- `manage_siswa` - CRUD siswa
- `manage_donatur` - Read donatur, create baru
- `manage_beasiswa` - Read beasiswa
- `manage_donasi` - View & input donasi manually
- `upload_documents` - Upload dokumen for applications

**Super-Admin Permissions:**
- All permissions
- `manage_users` - CRUD users, manage roles
- `view_audit_logs` - View all audit logs

---

## General Requirements

### API Conventions

1. **Pagination:**
   ```
   limit (default: 20, max: 100)
   offset (default: 0)

   Response:
   {
     "data": [...],
     "total": 150,
     "limit": 20,
     "offset": 0
   }
   ```

2. **Filtering & Sorting:**
   ```
   search=query
   status=value
   date_from=2026-01-01
   date_to=2026-03-31
   sort_by=field_name
   sort_order=asc|desc
   ```

3. **Timestamps:**
   - All timestamps in ISO 8601 format (UTC)
   - Example: `2026-03-17T10:30:00Z`

4. **ID Generation:**
   - Format: `PREFIX-XXXXX` (prefix-randomstring)
   - Prefixes: USR-, DID-, BEA-, BEP-, SID-, DON-, STF-

5. **Rate Limiting:**
   - 100 requests/minute per IP
   - 1000 requests/hour per authenticated user
   - Return `429` when limit exceeded
   - Include `X-RateLimit-*` headers in response

6. **Soft Delete:**
   - For critical data (donasi, donatur, siswa, user):
     - Add `deleted_at` timestamp field
     - Exclude from queries by default (WHERE deleted_at IS NULL)
     - Support GET endpoint with `include_deleted=true` for admin recovery

### Security

1. **Authentication:**
   - JWT tokens required for all protected endpoints
   - Include token in `Authorization: Bearer {token}` header
   - Invalidate refresh token on logout
   - Token stored in HTTP-only, Secure, SameSite cookies (preferred) or secure storage
   - Implement token blacklist for logout & password change
   - Session timeout: access token 15 min, refresh token 7 days

2. **CORS & Origin Validation:**
   - Strict whitelist for allowed origins:
     - Frontend: `https://yayvip.web` (production), `https://yayvip-staging.web` (staging)
     - Admin panel: `https://admin.yayvip.web`
     - Local dev: `http://localhost:3000` (dev only)
   - Reject preflight requests from unknown origins
   - Implement CSRF token validation for state-changing operations
   - Set `Access-Control-Allow-Credentials: true`

3. **Input Validation & Sanitization:**
   - Validate ALL input (query params, request body, headers)
   - Type validation: check expected data types
   - Length validation: enforce min/max lengths
   - Format validation: email, phone, URL patterns
   - Reject unknown fields (fail on extra properties)
   - Sanitize string inputs: remove/escape special characters
   - Prevent SQL injection: use parameterized queries/ORM, never string concatenation
   - Prevent NoSQL injection: validate object structure
   - Prevent XXE attacks: disable XML external entities
   - Prevent path traversal: validate file paths

4. **Output Encoding & Content-Type:**
   - Always set `Content-Type: application/json; charset=utf-8`
   - HTML-encode any user data in error messages
   - Never expose stack traces or internal errors to client
   - Return generic error messages in production

5. **Encryption:**
   - **Passwords:** Hash with bcrypt (min cost 12), never store plaintext
   - **Sensitive data at rest:** Encrypt bank accounts, phone, national IDs
     - Use AES-256-GCM for encryption
     - Store encryption keys in environment variables/secrets manager
   - **In transit:** HTTPS/TLS 1.2+ mandatory for all endpoints
   - **Database:** Use connection pooling over SSL/TLS
   - **Secrets:** Use environment variables or secrets manager (AWS Secrets Manager, HashiCorp Vault)

6. **Rate Limiting & DDoS Protection:**
   - Global: 100 req/min per IP, 1000 req/hour per user
   - Auth endpoints: 5 login attempts per 15 min per IP (slower backoff after failures)
   - File upload: 10 req/min per IP
   - Implement exponential backoff on failed auth
   - Return `429 Too Many Requests` with `Retry-After` header
   - Use IP-based + user-based rate limiting
   - Implement circuit breaker for external services (payment gateway, OAuth)

7. **Audit Logging:**
   - Log ALL security events: login, logout, password change, 2FA, permission changes, admin actions
   - Log ALL data access to sensitive info (donations, financial data)
   - Log failed authentication attempts
   - Include: timestamp (UTC), user_id, action, resource, ip_address, user_agent, status (success/fail)
   - **IMPORTANT:** Never log sensitive data (passwords, tokens, credit card numbers, bank accounts)
   - Store logs immutably (append-only)
   - Retention: min 90 days (regulatory compliance)
   - Regular audit log reviews (weekly/monthly)

8. **API Versioning:**
   - Use URL versioning: `/api/v1/`, `/api/v2/`
   - Support version deprecation with 12-month notice
   - Include API version in response headers: `X-API-Version: 1.0`

9. **HTTPS & TLS:**
   - Enforce HTTPS on all endpoints (HTTP 301 redirect)
   - Use TLS 1.2 or higher
   - Implement HSTS header: `Strict-Transport-Security: max-age=31536000; includeSubDomains`
   - Certificate pinning for mobile/sensitive clients (optional)

10. **Request/Response Security Headers:**
    - `X-Content-Type-Options: nosniff` (prevent MIME sniffing)
    - `X-Frame-Options: DENY` (prevent clickjacking)
    - `X-XSS-Protection: 1; mode=block` (XSS protection)
    - `Content-Security-Policy: default-src 'self'` (CSP)
    - `Referrer-Policy: strict-origin-when-cross-origin`
    - `Permissions-Policy: geolocation=(), camera=(), microphone=()`
    - Remove server identification headers: hide `X-Powered-By`, `Server`

### Error Handling

**Common Error Responses:**

```json
// Validation Error (400)
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": ["Email is required", "Email must be valid"],
    "password": ["Password too short"]
  }
}

// Unauthorized (401)
{
  "success": false,
  "message": "Unauthorized",
  "errors": {
    "auth": ["Invalid or expired token"]
  }
}

// Forbidden (403)
{
  "success": false,
  "message": "Forbidden",
  "errors": {
    "permission": ["You don't have permission to access this resource"]
  }
}

// Not Found (404)
{
  "success": false,
  "message": "Resource not found",
  "errors": {
    "resource": ["Donatur with ID DID-XYZ not found"]
  }
}

// Conflict (409)
{
  "success": false,
  "message": "Conflict",
  "errors": {
    "email": ["Email already registered"]
  }
}

// Rate Limited (429)
{
  "success": false,
  "message": "Rate limit exceeded",
  "errors": {
    "ratelimit": ["Too many requests. Try again in 60 seconds."]
  },
  "headers": {
    "Retry-After": "60"
  }
}

// Server Error (500) - NEVER expose stack trace
{
  "success": false,
  "message": "Internal server error",
  "errors": {
    "server": ["An unexpected error occurred. Please try again later."]
  }
}
```

**Error Handling Best Practices:**
- Never expose stack traces, SQL queries, or internal implementation details
- Log full errors server-side for debugging (with request ID)
- Return generic error messages to clients
- Include error ID/request ID for support reference
- Always use appropriate HTTP status codes
- Avoid error message enumeration (don't reveal if user exists, password hints, etc)

### File Upload

- **Endpoint:** `POST /beasiswa-pendaftaran/{id}/documents`
- **Max File Size:** 10MB
- **Allowed Types:** PDF, JPG, PNG
- **Max Files per Application:** 10
- **Storage:** Cloud storage (AWS S3, Google Cloud Storage, or Cloudinary)
- **URL Format:** `https://cdn.yayvip.com/documents/{year}/{month}/{unique_filename}`
- **Virus Scan:** Required for uploaded files

---

## Security Requirements

### Comprehensive Security Checklist

**Before Production Deployment:**

1. **Code Security:**
   - [ ] Dependency vulnerability scan (npm audit, cargo audit, pip audit)
   - [ ] SAST scan (SonarQube, CodeClimate, Snyk)
   - [ ] Remove all debug logs & console.log
   - [ ] Remove hardcoded credentials & API keys
   - [ ] Enable strict mode (TypeScript strict: true)
   - [ ] Code review by security-focused reviewer

2. **Authentication & Authorization:**
   - [ ] Implement JWT with proper expiry
   - [ ] Implement refresh token rotation
   - [ ] Implement token blacklist for logout
   - [ ] Enforce strong password policy
   - [ ] Implement 2FA (SMS/email/TOTP)
   - [ ] Rate limit login attempts (5x per 15 min)
   - [ ] Implement OAuth 2.0 correctly (code flow, not implicit)
   - [ ] Validate & verify OAuth tokens
   - [ ] Session timeout enforcement
   - [ ] Implement logout across all sessions

3. **Data Protection:**
   - [ ] Encrypt sensitive data at rest (AES-256-GCM)
   - [ ] Encrypt data in transit (TLS 1.2+)
   - [ ] Hash passwords with bcrypt (cost 12+)
   - [ ] Mask sensitive data in logs
   - [ ] Implement data retention policies
   - [ ] Secure database connection (SSL/TLS)
   - [ ] Use parameterized queries (no string concatenation)

4. **API Security:**
   - [ ] Implement rate limiting (100 req/min per IP)
   - [ ] Implement CORS whitelist (not wildcard)
   - [ ] Validate & sanitize all inputs
   - [ ] Implement CSRF protection (tokens for state-changing ops)
   - [ ] API versioning implemented
   - [ ] Security headers configured
   - [ ] Content-Type validation
   - [ ] File upload validation (size, type, virus scan)

5. **Infrastructure Security:**
   - [ ] HTTPS enforced (HTTP → HTTPS redirect)
   - [ ] TLS 1.2+ only (disable older versions)
   - [ ] HSTS header enabled
   - [ ] Secrets managed via environment variables or vault
   - [ ] Database credentials not in source code
   - [ ] Regular security patches applied
   - [ ] Firewall rules configured
   - [ ] WAF (Web Application Firewall) enabled

6. **Monitoring & Logging:**
   - [ ] Audit logging for security events
   - [ ] Failed auth attempt logging
   - [ ] Log retention (min 90 days)
   - [ ] Real-time alerting for suspicious activities
   - [ ] Error tracking (Sentry or similar)
   - [ ] Regular log reviews
   - [ ] Incident response plan

7. **Compliance:**
   - [ ] GDPR compliance (data privacy)
   - [ ] PCI-DSS compliance (payment data)
   - [ ] Data backup & disaster recovery
   - [ ] Terms of Service & Privacy Policy
   - [ ] User consent for data collection

---

## OWASP Top 10 Mitigation

### A01:2021 – Broken Access Control
**Mitigation:**
- Implement role-based access control (RBAC)
- Validate user permissions on every request
- Use middleware for authorization checks
- Principle of least privilege: grant minimal required permissions
- Log all permission changes & denied access attempts
- Regular access review (quarterly)
- Soft-delete users (don't allow permission re-escalation)

**Testing:**
- Test accessing resources as different roles
- Try accessing admin endpoints as non-admin
- Try accessing other user's data

---

### A02:2021 – Cryptographic Failures
**Mitigation:**
- Use TLS 1.2+ for all data in transit
- Encrypt sensitive data at rest (AES-256-GCM)
- Use bcrypt (cost 12+) for password hashing
- Never store plaintext passwords, tokens, or credit cards
- Rotate encryption keys annually
- Use HTTPS everywhere (enforce via HSTS)
- Disable SSL 3.0, TLS 1.0, TLS 1.1

**Testing:**
- Test over HTTP (should fail/redirect)
- Verify HTTPS headers present
- Check password hashing algorithm

---

### A03:2021 – Injection
**Mitigation:**
- Use parameterized queries / prepared statements (ORM recommended)
- Use ORMs (Prisma, TypeORM, SQLAlchemy) instead of raw SQL
- Validate & sanitize all user inputs
- Whitelist allowed input patterns
- Escape special characters
- Implement SQL injection prevention at framework level
- Regular dependency updates (for ORM patches)

**Testing:**
- Test with SQL injection payloads: `' OR '1'='1`, `; DROP TABLE users`
- Test NoSQL injection: `{$ne: null}`
- Test command injection: `; ls -la`

---

### A04:2021 – Insecure Design
**Mitigation:**
- Threat modeling during design phase
- Implement security by default
- Secure coding guidelines
- Security review before implementation
- Least privilege principle
- Fail securely (errors don't expose info)
- Input validation from start

---

### A05:2021 – Security Misconfiguration
**Mitigation:**
- Use security headers (X-Frame-Options, CSP, etc)
- Disable debug mode in production
- Remove unnecessary services & endpoints
- Keep dependencies updated
- Use strong default configurations
- Secrets in environment variables (not code)
- Regular security configuration audit

**Testing:**
- Check security headers (curl -I)
- Check for debug endpoints
- Check for default credentials
- Review CORS configuration

---

### A06:2021 – Vulnerable & Outdated Components
**Mitigation:**
- Regular dependency audits (npm audit, cargo audit, pip check)
- Automated dependency updates (Dependabot, Renovate)
- Keep frameworks & libraries updated
- Monitor CVE database
- Test updates before production
- Remove unused dependencies
- Document dependency versions

**Tools:**
- Snyk, OWASP Dependency-Check, npm audit
- GitHub Dependabot, Renovate

---

### A07:2021 – Authentication & Session Management
**Mitigation:**
- Use strong password requirements (min 8 char, complexity)
- Implement 2FA for all users
- Use secure session management (HTTP-only cookies)
- Implement token expiry (access: 15 min, refresh: 7 days)
- Invalidate tokens on logout
- Implement rate limiting on login (5x per 15 min)
- Log all authentication events
- Implement account lockout after failed attempts
- Secure password reset flow (time-limited tokens)

**Testing:**
- Test weak password acceptance
- Test session token reuse
- Test token expiry
- Test brute force attacks (rate limiting)

---

### A08:2021 – Software & Data Integrity Failures
**Mitigation:**
- Use verified packages from trusted sources
- Verify package integrity (checksums, signatures)
- Secure update mechanism
- Code review for all changes
- CI/CD pipeline security
- Secure artifact repository
- Regular vulnerability scanning

---

### A09:2021 – Logging & Monitoring Failures
**Mitigation:**
- Log all security events (auth, access, changes)
- Include: timestamp, user, action, resource, ip_address
- Audit log immutability (append-only)
- Log retention: min 90 days
- Real-time alerting for suspicious activities
- Failed auth attempt tracking
- Regular log analysis
- Incident response procedures
- **Never log:** passwords, tokens, credit cards, sensitive data

---

### A10:2021 – Server-Side Request Forgery (SSRF)
**Mitigation:**
- Validate all URLs before making requests
- Whitelist allowed hosts/domains
- Disable unnecessary protocols (file://, gopher://)
- Use network segmentation
- Implement request timeouts
- Validate redirects
- Rate limit outbound requests

**Testing:**
- Test with internal IP addresses (127.0.0.1, 169.254.169.254)
- Test with localhost
- Test with internal service URLs

---

## Payment Data Security (PCI-DSS)

**For Donasi/Payment Features:**
- Never store full credit card numbers
- Never store CVV/CVC
- Use payment gateway for card processing (Midtrans/Xendit)
- Implement 3D Secure for online payments
- Regular PCI-DSS compliance audit
- Encrypt cardholder data
- Use tokenization instead of storing cards
- Implement fraud detection
- Log all payment attempts

---

---

## Recommended Tech Stack

**Framework:**
- Node.js: Express.js + TypeScript (or NestJS)
- Go: Chi + Fiber
- Python: FastAPI + Pydantic

**Database:**
- PostgreSQL (primary)
- Optional: Redis (for caching, sessions)

**Payment Gateway:**
- Midtrans (recommended for Indonesia)
- OR Xendit
- OR Doku

**File Storage:**
- AWS S3
- Google Cloud Storage
- Cloudinary

**Authentication:**
- OAuth 2.0: Google & Facebook SDKs
- JWT: jsonwebtoken (Node) or similar
- 2FA: Twilio (SMS) or Firebase Auth

**Email Service:**
- SendGrid
- AWS SES
- Firebase Cloud Messaging

**Monitoring & Logging:**
- Sentry (error tracking)
- ELK Stack or Datadog (logging)
- Prometheus (metrics)

---

## Implementation Checklist

- [ ] Database schema & migrations
- [ ] Authentication endpoints
- [ ] Donatur CRUD
- [ ] Beasiswa CRUD + workflow
- [ ] Pendaftaran Beasiswa CRUD + workflow
- [ ] Siswa CRUD
- [ ] Donasi CRUD + payment gateway integration
- [ ] User Management CRUD + permissions
- [ ] Audit logging system
- [ ] API documentation (Swagger/OpenAPI)
- [ ] Unit tests (min 80% coverage)
- [ ] Integration tests
- [ ] Load testing
- [ ] Security audit (OWASP Top 10)
- [ ] Deployment pipeline

---

**Questions / Clarifications Needed:**
1. What's the preferred tech stack?
2. Payment gateway preference?
3. Timeline for backend completion?
4. Staging/production environment setup?
5. CI/CD pipeline requirements?

**Contact:** [Your Name/Team]
