# Vernon Indonesia Pintar (VIP) — Website

Website resmi Yayasan Vernon Indonesia Pintar — platform beasiswa vokasional, donasi, dan kemitraan untuk memberdayakan generasi muda Indonesia.

## Preview

| Halaman | Route | Deskripsi |
|---|---|---|
| Landing Page | `/` | Hero, visi/misi, sistem beasiswa & donasi, kontak |
| Beasiswa | `/beasiswa` | Alur beasiswa, 6 program, form pendaftaran |
| Donasi | `/donasi` | Form donatur/anonim, QR Code, CTA download app |
| Cerita VIP | `/cerita` | Blog berita & kisah inspiratif |
| Partnership | `/partnership` | 6 jenis kemitraan, kontak partnership |

## Tech Stack

- **Framework:** Flutter 3.41 (Web)
- **State Management:** BLoC / Cubit
- **Navigation:** go_router
- **Content:** JSON-based dynamic content (tanpa CMS)
- **Architecture:** Clean Architecture

## Getting Started

### Prerequisites

- Flutter SDK >= 3.10.0
- Chrome browser

### Installation

```bash
git clone https://github.com/erickmo/yayvip-web.git
cd yayvip-web
make get
```

### Run

```bash
make run
```

Atau langsung:

```bash
flutter run -d chrome
```

### Build Production

```bash
make build-web
```

Output di `build/web/`.

## Project Structure

```
lib/
├── core/
│   ├── constants/       # Colors, dimensions, strings
│   ├── content/         # ContentProvider (JSON loader)
│   ├── router/          # go_router setup
│   ├── theme/           # Material theme
│   └── utils/           # Helpers, logger
├── features/
│   ├── landing/         # Landing page + shared widgets
│   ├── donation/        # Halaman donasi + cubit
│   ├── scholarship/     # Halaman beasiswa + cubit
│   ├── stories/         # Halaman cerita VIP
│   └── partnership/     # Halaman partnership
└── main.dart

assets/
├── content/             # JSON konten dinamis (editable)
│   ├── landing.json
│   ├── donation.json
│   ├── scholarship.json
│   ├── stories.json
│   └── partnership.json
└── images/              # Logo & gambar
```

## Dynamic Content

Semua teks/caption website dikelola via JSON files di `assets/content/`. Untuk mengubah konten:

1. Edit file JSON yang sesuai
2. Hot restart (`R`) atau rebuild

Tidak perlu ubah code Dart.

## Commands

| Command | Deskripsi |
|---|---|
| `make run` | Run di Chrome (dev) |
| `make build-web` | Build production |
| `make test` | Jalankan test |
| `make analyze` | Analyze code |
| `make gen` | Code generation (freezed/injectable) |
| `make clean` | Clean & reinstall dependencies |

## Branding

- **Warna utama:** Merah VIP `#E53935`
- **Logo:** VIP (V merah, IP hitam) + "VERNON INDONESIA PINTAR"
- **Domain:** yayasan.vip

## Contact

- **Website:** yayasan.vip
- **Email:** vernonindonesiapintar@gmail.com
- **Instagram:** @vernonindonesiapintar
- **TikTok:** @yayvip
- **Alamat:** Jalan Letjen Sutoyo 102
