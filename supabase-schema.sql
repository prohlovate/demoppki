create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  nama text not null,
  email text unique not null,
  role text not null check (role in ('Admin','Guru','Viewer')),
  created_at timestamptz default now()
);

create table if not exists murid (
  id uuid primary key default gen_random_uuid(),
  nama text not null,
  no_mykid text,
  tahun text,
  kelas text,
  unit_beruniform text,
  kelab_persatuan text,
  sukan_permainan text,
  created_at timestamptz default now()
);

create table if not exists organisasi (
  id uuid primary key default gen_random_uuid(),
  jawatan text not null,
  nama_guru text not null,
  created_at timestamptz default now()
);

create table if not exists kehadiran (
  id uuid primary key default gen_random_uuid(),
  murid_id uuid references murid(id) on delete cascade,
  kategori text not null,
  tarikh date not null,
  status text not null check (status in ('Hadir','Tidak Hadir','Cuti','Aktiviti Luar')),
  created_at timestamptz default now()
);

create table if not exists aktiviti (
  id uuid primary key default gen_random_uuid(),
  nama_program text not null,
  tarikh date not null,
  lokasi text,
  objektif text,
  impak text,
  catatan text,
  gambar text,
  created_at timestamptz default now()
);

create table if not exists jadual_bertugas (
  id uuid primary key default gen_random_uuid(),
  tarikh date not null,
  nama_guru text not null,
  tugasan text not null,
  created_at timestamptz default now()
);

create table if not exists pertandingan (
  id uuid primary key default gen_random_uuid(),
  murid_id uuid references murid(id) on delete set null,
  nama_pertandingan text not null,
  peringkat text,
  pencapaian text,
  created_at timestamptz default now()
);

create table if not exists inventori (
  id uuid primary key default gen_random_uuid(),
  nama_item text not null,
  kuantiti integer not null default 0,
  status text,
  lokasi text,
  created_at timestamptz default now()
);

create table if not exists audit_trail (
  id uuid primary key default gen_random_uuid(),
  user_email text,
  aktiviti text not null,
  modul text,
  created_at timestamptz default now()
);

create table if not exists pinjaman_inventori (
  id uuid primary key default gen_random_uuid(),
  inventori_id uuid references inventori(id) on delete cascade,
  nama_peminjam text not null,
  tarikh_pinjam date not null,
  tarikh_pulang date,
  status text default 'Dipinjam',
  created_at timestamptz default now()
);

create index if not exists idx_murid_kelas on murid(kelas);
create index if not exists idx_kehadiran_tarikh on kehadiran(tarikh);
create index if not exists idx_kehadiran_kategori on kehadiran(kategori);
create index if not exists idx_aktiviti_tarikh on aktiviti(tarikh);
create index if not exists idx_jadual_bertugas_tarikh on jadual_bertugas(tarikh);
create index if not exists idx_pertandingan_peringkat on pertandingan(peringkat);
create index if not exists idx_inventori_status on inventori(status);
create index if not exists idx_audit_trail_created_at on audit_trail(created_at);

alter table users enable row level security;
alter table murid enable row level security;
alter table organisasi enable row level security;
alter table kehadiran enable row level security;
alter table aktiviti enable row level security;
alter table jadual_bertugas enable row level security;
alter table pertandingan enable row level security;
alter table inventori enable row level security;
alter table audit_trail enable row level security;
alter table pinjaman_inventori enable row level security;

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'users',
    'murid',
    'organisasi',
    'kehadiran',
    'aktiviti',
    'jadual_bertugas',
    'pertandingan',
    'inventori',
    'audit_trail',
    'pinjaman_inventori'
  ]
  loop
    execute format('drop policy if exists "authenticated read %1$s" on %1$s', table_name);
    execute format('create policy "authenticated read %1$s" on %1$s for select to authenticated using (true)', table_name);
  end loop;
end $$;

insert into users (nama, email, role) values
  ('Pentadbir PPKI', 'admin@skds.edu.my', 'Admin'),
  ('Guru Kokurikulum', 'guru@skds.edu.my', 'Guru'),
  ('Viewer PPD', 'viewer@skds.edu.my', 'Viewer')
on conflict (email) do update set nama = excluded.nama, role = excluded.role;

insert into murid (nama, no_mykid, tahun, kelas, unit_beruniform, kelab_persatuan, sukan_permainan) values
  ('Ahmad Danish', '160101020001', 'Tahun 4', 'PPKI Bestari', 'Pengakap', 'Kelab Seni', 'Bola Jaring'),
  ('Nur Aisyah', '160202020002', 'Tahun 5', 'PPKI Cekal', 'Bulan Sabit Merah', 'Kelab Komputer', 'Olahraga'),
  ('Muhammad Iqbal', '170303020003', 'Tahun 3', 'PPKI Harmoni', 'Puteri Islam', 'Kelab Muzik', 'Bocce');

insert into organisasi (jawatan, nama_guru) values
  ('Pengerusi', 'Pn. Siti Hajar'),
  ('Setiausaha', 'En. Mohd Hafiz'),
  ('Bendahari', 'Pn. Farah Diana');

insert into aktiviti (nama_program, tarikh, lokasi, objektif, impak, catatan) values
  ('Hari Kokurikulum PPKI', '2026-06-12', 'Dewan SKDS', 'Meningkatkan keyakinan murid', 'Murid menunjukkan penyertaan aktif', 'Berjalan lancar');

insert into jadual_bertugas (tarikh, nama_guru, tugasan) values
  ('2026-06-05', 'Pn. Siti Hajar', 'Pemantauan Unit Beruniform'),
  ('2026-06-19', 'En. Mohd Hafiz', 'Penyediaan alatan sukan');

insert into inventori (nama_item, kuantiti, status, lokasi) values
  ('Bola Bocce', 8, 'Baik', 'Stor Sukan PPKI'),
  ('Khemah Aktiviti', 2, 'Perlu Semakan', 'Stor Kokurikulum');
