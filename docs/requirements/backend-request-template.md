# Backend Development Request - YayVIP Web API

**Subject:** Backend API Development - YayVIP Web Project

---

## Ringkas

Kami butuh backend API untuk **YayVIP Web** — platform beasiswa & donasi. Scope: 7 fitur utama dengan CRUD endpoints, authentication (OAuth + JWT + 2FA), payment gateway integration, dan audit logging.

**Timeline:** [DISKUSI DIPERLUKAN]
**Tech Stack Preference:** [DISKUSI DIPERLUKAN]

---

## Fitur & Scope

| # | Fitur | CRUD | Logic |
|---|---|---|---|
| 1 | Authentication | - | OAuth (Google, Facebook), JWT, 2FA, password reset |
| 2 | Data Donatur | CRU | Self-service + admin manage, auto-generate ID |
| 3 | Data Beasiswa | CRU | Workflow: Draft → Approved → Active → Closed, kuota, audit log |
| 4 | Pendaftaran Beasiswa | CRU | Workflow: Draft → Submit → Review → Approved/Rejected, document upload |
| 5 | Data Siswa | CRU | Admin manage (no student login), track aplikasi & donasi |
| 6 | Data Donasi | CR(U) | Payment gateway integration, auto-verify, invoice/receipt, webhook |
| 7 | User Management | CRU | Roles (super-admin, admin, staff), permissions, audit log |

**No Delete For:** Donasi, Donatur, Siswa, User (soft-delete only)

---

## Detailed Requirements

Lihat dokumen: **`docs/requirements/backend-api-specification.md`**

File ini berisi:
- Endpoint detail per fitur (request/response format)
- Data model & fields
- Business logic & validations
- Workflow rules
- Security requirements
- Rate limiting, pagination, filtering
- Error handling
- File upload specifications
- Recommended tech stack

---

## Quick Overview - Key Points

### 1. Authentication
- OAuth 2.0: Google & Facebook
- JWT: access token (15 min) + refresh token (7 days)
- 2FA via SMS/email
- Roles: super-admin, admin, staff, donatur, siswa
- Password reset via email
- Audit log login/logout/password changes

### 2. Data Donatur
- Admin + Donatur bisa manage profil
- Auto-generate donor ID (DID-XXXXX)
- Validasi unique email & phone
- Status: active/inactive
- Track donation history

### 3. Data Beasiswa
- Workflow: Draft → Approved → Active → Closed
- Admin manage, soft-delete
- Audit trail siapa ubah kapan
- Kuota per beasiswa
- Filter by kategori, jenjang, benefit

### 4. Pendaftaran Beasiswa
- Workflow: Draft → Submit → Review → Approved/Rejected/Accepted
- Document upload (rapor, sertifikat, foto, dll)
- Admin review & approval
- No auto-notification (frontend handle)
- Tidak exceed kuota beasiswa

### 5. Data Siswa
- Admin manage, no student login
- Auto-generate student ID (SID-XXXXX)
- Status: aktif, lulus, dropout, alumni
- Track aplikasi beasiswa & donasi received

### 6. Data Donasi
- **Payment gateway integration required** (Midtrans/Xendit/Doku)
- Payment method: bank transfer, e-wallet, kartu kredit
- Auto-verify via webhook
- Generate invoice & receipt
- Status: pending, verified, completed, failed, refunded
- **TIDAK BOLEH DELETE** (soft-delete audit trail)

### 7. User Management
- Roles: super-admin, admin, staff
- Fine-grained permissions
- Password policy: min 8 char, uppercase, number, special char, expiry 90 hari
- User status: active, inactive, suspended
- Audit log semua action (who, what, when, ip_address)

---

## Technical Requirements

### Response Format (Standard)
```json
{
  "success": true/false,
  "message": "string",
  "data": {},
  "errors": null
}
```

### Database
- PostgreSQL recommended (with SSL connection)
- Soft-delete untuk: donasi, donatur, siswa, user
- Audit trail table (semua CRUD operations)
- Regular backup (daily automated backups)
- Encrypted connections to database

### Security (Priority!)
**Must Implement Before Production:**
- ✅ HTTPS/TLS 1.2+ only (HTTP → HTTPS redirect)
- ✅ JWT authentication with refresh token rotation
- ✅ CORS whitelist (not wildcard)
- ✅ Rate limiting: 100 req/min per IP, 5 login attempts per 15 min
- ✅ Password hashing: bcrypt (cost 12+)
- ✅ Input validation & sanitization (prevent SQL/NoSQL/command injection)
- ✅ Encrypt sensitive data at rest (AES-256-GCM)
- ✅ Security headers (X-Frame-Options, CSP, X-Content-Type-Options, etc)
- ✅ Audit logging (auth, CRUD, permission changes)
- ✅ 2FA for users (SMS/email/TOTP)
- ✅ HSTS header enabled
- ✅ CSRF protection for state-changing operations
- ✅ Token blacklist for logout
- ✅ Never log sensitive data (passwords, tokens, credit cards)
- ✅ Regular dependency vulnerability scans
- ✅ Code security review (SAST scan)

**OWASP Top 10 Coverage Required:**
- A01: Broken Access Control → RBAC + permission validation
- A02: Cryptographic Failures → TLS + encryption + bcrypt
- A03: Injection → Parameterized queries + input validation
- A04: Insecure Design → Threat modeling + secure by default
- A05: Security Misconfiguration → Security headers + no debug mode
- A06: Vulnerable Components → Dependency scanning + updates
- A07: Auth & Session → Strong passwords + 2FA + token management
- A08: Data Integrity → Code review + CI/CD security
- A09: Logging Failures → Audit logging + real-time alerting
- A10: SSRF → URL validation + whitelist

### Payment Gateway
- Setup webhook untuk auto-verify donasi (validate webhook signature)
- Handle idempotency (same webhook may come multiple times)
- Generate payment link via Midtrans/Xendit/Doku
- Log transaction (without storing full card data)
- PCI-DSS compliance: never store full credit card numbers
- Use 3D Secure for online payments
- Tokenization for recurring payments

### File Upload
- Endpoint: POST /beasiswa-pendaftaran/{id}/documents
- Max size: 10MB, types: PDF/JPG/PNG
- Max 10 files per application
- Virus scan required (ClamAV or antivirus API)
- Cloud storage (S3, GCS, Cloudinary) with encryption
- Validate file content (not just extension)
- Implement signed URLs for downloads (time-limited, 1 hour)

### Logging & Monitoring
- Log all security events (auth, access denied, role changes)
- Log auth events (login, logout, password change, 2FA attempts)
- Log CRUD operations (with before/after values)
- Log permission/role changes
- Include: user_id, action, resource, timestamp, ip_address, user_agent, status
- **NEVER log:** passwords, tokens, credit cards, sensitive PII
- Audit log retention: min 90 days
- Error tracking (Sentry or similar)
- Real-time alerting for suspicious activities (multiple failed logins, etc)
- Regular audit log reviews (weekly/monthly)

---

## Response Standards

### Success (200/201)
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... },
  "errors": null
}
```

### Validation Error (400)
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": ["Email is required", "Email must be valid"],
    "password": ["Password too short"]
  }
}
```

### Unauthorized (401)
```json
{
  "success": false,
  "message": "Unauthorized",
  "errors": { "auth": ["Invalid or expired token"] }
}
```

### Forbidden (403)
```json
{
  "success": false,
  "message": "Forbidden",
  "errors": { "permission": ["Insufficient permissions"] }
}
```

### Rate Limited (429)
```json
{
  "success": false,
  "message": "Rate limit exceeded",
  "errors": { "ratelimit": ["Try again in 60 seconds"] }
}
```

---

## Pagination & Filtering

All list endpoints support:
```
GET /resource?limit=20&offset=0&search=&status=&sort_by=field&sort_order=asc

Response:
{
  "data": [...],
  "total": 150,
  "limit": 20,
  "offset": 0
}
```

---

## Implementation Checklist

### Core Features
- [ ] Database schema & migrations (with soft-delete)
- [ ] Authentication system (JWT + OAuth Google/Facebook)
- [ ] 2FA system (SMS/email/TOTP)
- [ ] Donatur CRUD + relationships
- [ ] Beasiswa CRUD + workflow (draft → approved → active → closed)
- [ ] Pendaftaran Beasiswa CRUD + document upload + workflow
- [ ] Siswa CRUD
- [ ] Donasi CRUD + payment gateway integration
- [ ] Webhook handler for payment verification (with signature validation)
- [ ] User Management CRUD + role-based permissions
- [ ] Audit logging system

### Security Implementation (REQUIRED)
- [ ] HTTPS/TLS enforcement (HTTP → HTTPS redirect)
- [ ] Security headers implemented (X-Frame-Options, CSP, HSTS, etc)
- [ ] Input validation & sanitization (prevent SQL/NoSQL/command injection)
- [ ] Password hashing (bcrypt cost 12+)
- [ ] Sensitive data encryption (AES-256-GCM)
- [ ] Token refresh rotation
- [ ] Token blacklist on logout
- [ ] Rate limiting (100 req/min per IP, 5 login per 15 min)
- [ ] CORS whitelist (not wildcard)
- [ ] CSRF protection
- [ ] Audit logging (security events, changes, access denied)
- [ ] Never log sensitive data (passwords, tokens, credit cards)
- [ ] Error handling (no stack traces to clients)
- [ ] Dependency vulnerability scanning
- [ ] Code security review (SAST)

### Infrastructure & DevOps
- [ ] Rate limiting middleware
- [ ] Error handling middleware
- [ ] Logging middleware (without sensitive data)
- [ ] Database encryption & SSL connection
- [ ] Secrets management (environment variables/vault)
- [ ] Database backup strategy (daily automated)
- [ ] API documentation (Swagger/OpenAPI)

### Testing
- [ ] Unit tests (min 80% coverage)
- [ ] Integration tests (with real database)
- [ ] Security testing (OWASP Top 10 scenarios)
- [ ] Load testing (1000+ concurrent users)
- [ ] Penetration testing (vulnerability assessment)
- [ ] Payment gateway testing (sandbox environment)

### Pre-Production
- [ ] Staging environment setup (mirrors production)
- [ ] Database backup & restore testing
- [ ] Security audit checklist (see backend-api-specification.md)
- [ ] PCI-DSS compliance check (for payment features)
- [ ] GDPR compliance check (data privacy)
- [ ] Incident response plan
- [ ] Production deployment procedure
- [ ] Monitoring & alerting setup
- [ ] Log retention policy (min 90 days)

---

## Questions Before Starting

1. **Tech Stack Preference?**
   - Node.js (Express/NestJS)?
   - Go (Chi/Gin)?
   - Python (FastAPI)?
   - PHP/Laravel?

2. **Payment Gateway?**
   - Midtrans (recommended for Indonesia)?
   - Xendit?
   - Doku?
   - Or handle payment separately?

3. **Database Server?**
   - PostgreSQL (recommended)?
   - MySQL?
   - MongoDB?
   - Managed service (AWS RDS, Google Cloud SQL)?

4. **Infrastructure?**
   - Where will API be hosted?
   - AWS, Google Cloud, Heroku, VPS?
   - Containerization needed (Docker)?

5. **Authentication Provider?**
   - Use OAuth provider's SDK?
   - Custom implementation?

6. **Timeline & Resources?**
   - When needed by?
   - How many backend developers?
   - Full-time or part-time?

7. **Testing Requirements?**
   - Unit test coverage %?
   - Integration tests?
   - Load testing needed?

8. **CI/CD Pipeline?**
   - GitHub Actions, GitLab CI, Jenkins?
   - Auto-deploy to staging/production?

---

## Documentation Reference

- **Full API Spec:** `docs/requirements/backend-api-specification.md`
- **Frontend Requirements:** `docs/requirements/prd-yayvip-web.md`
- **Project Structure:** Check `CLAUDE.md` in repo root

---

## Next Steps

1. **Review** this request & full API specification
2. **Clarify** tech stack, payment gateway, timeline
3. **Setup** development environment & database
4. **Start** with authentication endpoints
5. **Implement** features in order: 1 → 2 → 3 → 4 → 5 → 6 → 7
6. **Test** each endpoint thoroughly
7. **Deploy** to staging for frontend integration testing

---

## Contact

**For questions or clarifications:**
- Review the full spec: `docs/requirements/backend-api-specification.md`
- Ask about specific endpoints or logic
- Discuss timeline & tech stack preferences

Thanks!

---

**Generated:** 2026-03-17
**By:** [Your Name/Team]
**Project:** YayVIP Web Backend API
**Status:** Ready for Development
