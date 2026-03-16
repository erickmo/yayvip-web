# YayVIP Web — Vernon Indonesia Pintar

## Overview
Website resmi Yayasan Vernon Indonesia Pintar (VIP) — platform beasiswa, donasi, dan informasi yayasan pendidikan vokasional untuk generasi muda Indonesia.

**PRD Lengkap:** docs/requirements/prd-yayvip-web.md

## Stack
- **Frontend:** Flutter 3.41.4 (Web)
- **State Management:** BLoC / Cubit
- **Navigation:** go_router
- **Content:** JSON-based dynamic content (`assets/content/*.json`)
- **DI:** get_it + injectable
- **Backend API:** Belum ada (BASE_URL via --dart-define)
- **Platform:** Web

## Pages & Routes
| Route | Halaman | Deskripsi |
|---|---|---|
| `/` | Landing Page | Hero, intro, visi/misi, kriteria, sistem beasiswa, donasi, realtime, kontak |
| `/beasiswa` | Beasiswa | Hero slider, alur beasiswa & syarat, 6 program, form pendaftaran/donasi |
| `/cerita` | Cerita VIP | Blog berita & kisah inspiratif (9 artikel) |
| `/partnership` | Partnership | Hero, 6 jenis kemitraan, kontak partnership |
| `/donasi` | Donasi | Hero slider, form donatur/QR code, CTA download app |

## Dynamic Content System
Semua caption/teks website dikelola via JSON files di `assets/content/`:
- `landing.json` — konten halaman utama
- `donation.json` — konten halaman donasi
- `scholarship.json` — konten halaman beasiswa
- `stories.json` — artikel berita
- `partnership.json` — konten halaman partnership

**Cara edit:** Ubah file JSON → hot restart / rebuild. Tidak perlu ubah code Dart.
**Service:** `lib/core/content/content_provider.dart` — preload saat startup, cache di memory.

## Project Structure
```
lib/
├── core/
│   ├── constants/       ← colors, dimensions, constants
│   ├── content/         ← ContentProvider (JSON loader)
│   ├── di/              ← dependency injection
│   ├── errors/          ← failure classes
│   ├── network/         ← API client, network info
│   ├── router/          ← go_router setup
│   ├── theme/           ← app theme
│   └── utils/           ← helpers, logger, nav_helper
├── features/
│   ├── landing/         ← landing page + shared widgets
│   ├── donation/        ← halaman donasi + cubit
│   ├── scholarship/     ← halaman beasiswa + cubit
│   ├── stories/         ← halaman cerita VIP
│   └── partnership/     ← halaman partnership
└── main.dart
assets/
├── content/             ← JSON konten dinamis
├── images/              ← gambar (logo VIP)
├── icons/
└── animations/
```

## Key Commands
```bash
make run          # flutter run -d chrome
make build-web    # build release web
make gen          # build_runner (code generation)
make test         # flutter test
make analyze      # flutter analyze
```

## Coding Rules
- SEMUA code ditulis oleh AI
- Semua teks konten dari `ContentProvider`, bukan hardcode
- Gunakan `AppColors`, `AppDimensions` — tidak boleh hardcode warna/ukuran
- Tidak ada business logic di dalam build()
- Semua state (loading/success/error/empty) wajib di-handle

## Branding
- **Warna utama:** Merah VIP (#E53935), hitam, abu-abu
- **Logo:** VIP (V merah triangle, IP hitam) + "VERNON INDONESIA PINTAR"
- **Favicon:** Extracted dari proposal PDF
