# Sistem Pengurusan Kokurikulum PPKI SKDS 2026

Sistem Next.js 15 + TypeScript + Tailwind CSS + shadcn-style UI + Supabase untuk pengurusan kokurikulum PPKI SKDS 2026.

## Mula guna

```bash
npm install
cp .env.example .env.local
npm run dev
```

Isi `.env.local` dengan kredensial Supabase. Aplikasi tetap memaparkan data demo jika Supabase belum disambungkan.

## Modul

- Dashboard analitik
- Carta organisasi
- One Page Report
- Kehadiran kokurikulum dan QR kehadiran
- Senarai murid, import/export Excel, PDF
- Jadual bertugas
- Rekod pertandingan
- Inventori dan rekod pinjaman/peralatan
- Takwim kokurikulum
- Tetapan logo, backup database, laporan akhir tahun, sijil PDF, audit trail

## Supabase SQL

Jalankan skrip `supabase-schema.sql` dalam SQL Editor Supabase.
