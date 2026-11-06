SET NAMES utf8mb4;
SET time_zone = '+07:00';
DROP DATABASE IF EXISTS `porto_memphis`;
CREATE DATABASE `porto_memphis` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `porto_memphis`;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE login_gagal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ip VARCHAR(45) NOT NULL,
  waktu DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (ip, waktu)
) ENGINE=InnoDB;

CREATE TABLE pengaturan (
  kunci VARCHAR(50) PRIMARY KEY,
  nilai TEXT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE teknologi (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(60) NOT NULL,
  logo VARCHAR(40) NOT NULL DEFAULT '',
  kategori VARCHAR(40) NOT NULL DEFAULT 'Tools',
  level TINYINT UNSIGNED NOT NULL DEFAULT 70,
  unggulan TINYINT(1) NOT NULL DEFAULT 0,
  urutan INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE proyek (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(150) NOT NULL,
  slug VARCHAR(90) NOT NULL UNIQUE,
  kategori VARCHAR(50) NOT NULL,
  ringkasan VARCHAR(255) NOT NULL DEFAULT '',
  isi TEXT NOT NULL,
  cover VARCHAR(255) NOT NULL DEFAULT '',
  klien VARCHAR(100) NOT NULL DEFAULT '',
  peran VARCHAR(100) NOT NULL DEFAULT '',
  tahun SMALLINT UNSIGNED NOT NULL,
  durasi VARCHAR(40) NOT NULL DEFAULT '',
  link_demo VARCHAR(255) NOT NULL DEFAULT '',
  link_repo VARCHAR(255) NOT NULL DEFAULT '',
  unggulan TINYINT(1) NOT NULL DEFAULT 0,
  tampil TINYINT(1) NOT NULL DEFAULT 1,
  urutan INT NOT NULL DEFAULT 0,
  dilihat INT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (tampil, urutan)
) ENGINE=InnoDB;

CREATE TABLE proyek_gambar (
  id INT AUTO_INCREMENT PRIMARY KEY,
  proyek_id INT NOT NULL,
  file VARCHAR(255) NOT NULL,
  keterangan VARCHAR(150) NOT NULL DEFAULT '',
  urutan INT NOT NULL DEFAULT 0,
  FOREIGN KEY (proyek_id) REFERENCES proyek(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE proyek_teknologi (
  proyek_id INT NOT NULL,
  teknologi_id INT NOT NULL,
  PRIMARY KEY (proyek_id, teknologi_id),
  FOREIGN KEY (proyek_id) REFERENCES proyek(id) ON DELETE CASCADE,
  FOREIGN KEY (teknologi_id) REFERENCES teknologi(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pengalaman (
  id INT AUTO_INCREMENT PRIMARY KEY,
  jenis ENUM('kerja','pendidikan') NOT NULL DEFAULT 'kerja',
  posisi VARCHAR(100) NOT NULL,
  instansi VARCHAR(120) NOT NULL,
  kota VARCHAR(60) NOT NULL DEFAULT '',
  mulai DATE NOT NULL,
  selesai DATE NULL,
  deskripsi TEXT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE layanan (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(100) NOT NULL,
  deskripsi VARCHAR(255) NOT NULL,
  ikon VARCHAR(40) NOT NULL DEFAULT 'sparkles',
  harga_mulai INT UNSIGNED NULL,
  urutan INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE testimoni (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  jabatan VARCHAR(120) NOT NULL DEFAULT '',
  isi TEXT NOT NULL,
  foto VARCHAR(255) NOT NULL DEFAULT '',
  rating TINYINT UNSIGNED NOT NULL DEFAULT 5,
  tampil TINYINT(1) NOT NULL DEFAULT 1,
  urutan INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE pesan (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  subjek VARCHAR(150) NOT NULL DEFAULT '',
  isi TEXT NOT NULL,
  anggaran VARCHAR(40) NOT NULL DEFAULT '',
  ip VARCHAR(45) NOT NULL DEFAULT '',
  dibaca TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (ip, created_at)
) ENGINE=InnoDB;

CREATE TABLE kunjungan (
  tanggal DATE PRIMARY KEY,
  jumlah INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

-- ===== Data contoh =====
INSERT INTO users (nama, username, password) VALUES
('Ayu Kartika', 'admin', '$2y$10$hfPGjluwfNku5NZEkVGdjuwvX1Vc1qLQ4EygXt7IcuAsA1lMvQQ4y');

INSERT INTO pengaturan (kunci, nilai) VALUES
('nama', 'Ayu Kartika'),
('peran', 'UI/UX & Product Designer'),
('judul_hero', 'Bikin aplikasi yang bikin orang senyum.'),
('tagline', 'Desainer UI/UX dari Denpasar. Aku merancang aplikasi mobile dan web yang gampang dipakai siapa saja, dari ibu-ibu pemilik warung sampai turis yang baru mendarat.'),
('bio', 'Halo, aku **Ayu**! Aku jatuh cinta pada desain antarmuka sejak sadar bahwa satu tombol yang salah tempat bisa membuat orang batal pesan makanan.

Sekarang aku membantu startup dan UMKM di Bali dan seluruh Indonesia merancang produk digital: mulai dari riset pengguna, wireframe, prototipe interaktif, sampai design system yang rapi untuk developer.

Aku percaya desain yang baik itu terasa ringan, sedikit jenaka, dan selalu diuji langsung dengan orang sungguhan. Di luar kerja, aku mengajar kelas Figma gratis untuk mahasiswa dan mengoleksi kaset lagu-lagu 90-an.'),
('kota', 'Denpasar, Bali'),
('email', 'hai@ayukartika.design'),
('whatsapp', '081936123456'),
('status_teks', 'Bisa mulai proyek baru Desember'),
('tersedia', '1'),
('tahun_mulai', '2019'),
('aksen', 'koral'),
('foto', ''),
('cv', ''),
('meta_deskripsi', 'Portofolio Ayu Kartika, UI/UX dan product designer Denpasar: aplikasi mobile, web app, design system, riset UX.'),
('sosial_github', ''),
('sosial_linkedin', 'https://www.linkedin.com/in/ayukartika'),
('sosial_instagram', 'https://www.instagram.com/ayu.ngedesain'),
('sosial_dribbble', 'https://dribbble.com/ayukartika'),
('sosial_behance', 'https://www.behance.net/ayukartika'),
('sosial_youtube', '');

INSERT INTO teknologi (nama, logo, kategori, level, unggulan, urutan) VALUES
('Figma', 'figma', 'Desain', 98, 1, 1),
('Framer', 'framer', 'Desain', 85, 1, 2),
('Sketch', 'sketch', 'Desain', 70, 0, 3),
('Blender', 'blender', 'Desain', 55, 1, 4),
('Miro', 'miro', 'Riset', 90, 1, 5),
('Notion', 'notion', 'Riset', 85, 0, 6),
('Webflow', 'webflow', 'No-code', 80, 1, 7),
('Framer Sites', 'framer', 'No-code', 75, 0, 8),
('Flutter', 'flutter', 'Kode', 50, 0, 9),
('React', 'react', 'Kode', 55, 1, 10),
('Tailwind CSS', 'tailwindcss', 'Kode', 70, 0, 11),
('Expo', 'expo', 'Kode', 45, 0, 12),
('Dribbble', 'dribbble', 'Komunitas', 80, 0, 13),
('Behance', 'behance', 'Komunitas', 75, 0, 14);

INSERT INTO proyek (judul, slug, kategori, ringkasan, isi, cover, klien, peran, tahun, durasi, link_demo, link_repo, unggulan, urutan, dilihat, created_at) VALUES
('Gaskeun: Ojek Lokal Bali', 'gaskeun-ojek', 'Mobile App', 'Redesain aplikasi ojek lokal: pesan jadi 3 ketukan, pembatalan turun 41%.', '## Masalah
Banyak pengguna membatalkan pesanan karena titik jemput sering salah dan tarif baru muncul di layar terakhir.

## Proses
- Wawancara 18 pengguna: pelajar, pekerja hotel, dan turis domestik
- Peta perjalanan pengguna untuk menemukan titik frustrasi
- 3 putaran prototipe dan uji langsung di jalan

## Solusi
- Tarif tampil **sejak awal** sebelum memilih tujuan
- Titik jemput bisa digeser dengan foto patokan dari pengemudi
- Tombol darurat dan bagikan perjalanan yang mudah dijangkau jempol

Pembatalan turun 41% dan rating aplikasi naik dari 3,6 ke 4,5 bintang.', 'assets/img/contoh/gaskeun-ojek.svg', 'Gaskeun Mobilitas', 'Lead product designer', 2026, '4 bulan', 'https://example.com', '', 1, 1, 593, NOW() - INTERVAL 184 DAY),
('Tenang: Reservasi Spa', 'tenang-spa', 'Mobile App', 'Aplikasi reservasi spa untuk 9 cabang dengan pilihan terapis dan paket.', '## Brief
Tamu hotel ingin memesan spa tanpa harus menelepon resepsionis.

## Yang dirancang
- Katalog paket dengan foto, durasi, dan harga jelas
- Pilih terapis favorit dan slot waktu yang tersedia
- Mode bahasa Indonesia dan Inggris

Reservasi lewat aplikasi mencapai 62% dari total pemesanan dalam dua bulan.', 'assets/img/contoh/tenang-spa.svg', 'Tenang Wellness Group', 'UI/UX designer', 2025, '3 bulan', '', '', 0, 2, 412, NOW() - INTERVAL 161 DAY),
('Kopi Pantai POS', 'kopi-pantai-pos', 'Web App', 'Layar kasir tablet yang bisa dipakai barista baru tanpa pelatihan.', '## Tantangan
Barista sering salah memasukkan pesanan saat antrean panjang karena menu terlalu padat.

## Solusi
- Tombol menu besar dengan warna kategori
- Modifier (gula, es, susu) dalam satu layar tanpa pindah halaman
- Ringkasan pesanan selalu terlihat di sisi kanan

Kesalahan pesanan turun dari 1 dari 20 menjadi 1 dari 140 transaksi.', 'assets/img/contoh/kopi-pantai-pos.svg', 'Kopi Pantai Sanur', 'Product designer', 2025, '2 bulan', '', '', 0, 3, 327, NOW() - INTERVAL 138 DAY),
('Lontar Design System', 'lontar-design-system', 'Design System', '120+ komponen Figma & token warna yang dipakai 4 produk sekaligus.', '## Situasi
Empat produk dalam satu perusahaan punya 37 variasi tombol berbeda.

## Pekerjaan
- Audit antarmuka dan inventaris komponen
- Token warna, tipografi, jarak, dan radius yang tersinkron ke kode
- Dokumentasi pemakaian di Notion dengan contoh benar & salah
- Kelas rutin untuk desainer dan developer

Waktu membuat halaman baru turun sekitar 45%, dan tampilan keempat produk kini terasa satu keluarga.', 'assets/img/contoh/lontar-design-system.svg', 'Lontar Teknologi', 'Design system lead', 2024, '6 bulan', 'https://example.com', '', 1, 4, 488, NOW() - INTERVAL 115 DAY),
('Basa: Belajar Bahasa Bali', 'basa-bahasa-bali', 'Mobile App', 'Aplikasi belajar bahasa Bali 5 menit sehari dengan ilustrasi lucu.', '## Kenapa
Keponakanku lebih lancar bahasa Inggris daripada bahasa Bali. Aku ingin belajar bahasa daerah terasa seperti bermain.

## Fitur
- Pelajaran 5 menit dengan kuis bergambar
- Maskot 3D yang dibuat di Blender
- Rekam suara untuk latihan pengucapan

Prototipe ini menang juara 2 kompetisi desain aplikasi pelestarian budaya.', 'assets/img/contoh/basa-bahasa-bali.svg', '', 'Desainer & penggagas', 2024, 'Proyek pribadi', '', '', 0, 5, 361, NOW() - INTERVAL 92 DAY),
('Desa Wisata Bukit Asri', 'desa-bukit-asri', 'Website', 'Website desa wisata dengan paket tur, kalender upacara, dan pesan via WhatsApp.', '## Tujuan
Wisatawan sulit menemukan informasi paket dan jadwal upacara desa.

## Yang dibuat
- Halaman paket tur lengkap dengan harga dan durasi
- Kalender upacara yang bisa diperbarui pengurus sendiri
- Tombol pesan langsung ke WhatsApp pemandu

Pemesanan paket naik tiga kali lipat di musim liburan pertama.', 'assets/img/contoh/desa-bukit-asri.svg', 'Pokdarwis Bukit Asri', 'UI designer & Webflow developer', 2023, '6 minggu', 'https://example.com', '', 0, 6, 244, NOW() - INTERVAL 69 DAY),
('Tabungku Onboarding', 'tabungku-onboarding', 'Mobile App', 'Alur daftar & verifikasi KTP yang selesai rata-rata dalam 2 menit.', '## Masalah
58% calon pengguna berhenti di tengah proses pendaftaran.

## Perbaikan
- Langkah dipecah jadi kecil dengan indikator progres
- Panduan foto KTP dengan bingkai dan contoh
- Pesan kesalahan yang menjelaskan cara memperbaiki, bukan sekadar "gagal"

Penyelesaian pendaftaran naik dari 42% menjadi 71%.', 'assets/img/contoh/tabungku-onboarding.svg', 'Tabungku Finansial', 'UX designer', 2023, '2 bulan', '', '', 0, 7, 298, NOW() - INTERVAL 46 DAY),
('Riset UX Pasar Kriya', 'riset-pasar-kriya', 'Riset UX', 'Wawancara 24 perajin & pembeli untuk menyusun ulang prioritas fitur marketplace.', '## Pertanyaan riset
Kenapa perajin jarang memperbarui stok di marketplace?

## Metode
- Wawancara mendalam 24 orang di Gianyar dan Klungkung
- Diary study 2 minggu lewat WhatsApp
- Lokakarya prioritas fitur bersama tim produk

Temuan utama: perajin lebih nyaman mengirim foto lewat chat. Fitur unggah produk via WhatsApp kemudian menjadi prioritas nomor satu.', 'assets/img/contoh/riset-pasar-kriya.svg', 'Pasar Kriya Nusantara', 'UX researcher', 2022, '5 minggu', '', '', 0, 8, 187, NOW() - INTERVAL 23 DAY);

INSERT INTO proyek_gambar (proyek_id, file, keterangan, urutan) VALUES
(1, 'assets/img/contoh/gaskeun-ojek-1.svg', 'Alur pesan ojek 3 ketukan', 1),
(1, 'assets/img/contoh/gaskeun-ojek-2.svg', 'Peta penjemputan yang lebih jelas', 2),
(2, 'assets/img/contoh/tenang-spa-1.svg', 'Pilih paket & terapis', 1),
(2, 'assets/img/contoh/tenang-spa-2.svg', 'Jadwal dan pengingat', 2),
(3, 'assets/img/contoh/kopi-pantai-pos-1.svg', 'Layar pesanan dengan modifier', 1),
(3, 'assets/img/contoh/kopi-pantai-pos-2.svg', 'Laporan harian pemilik', 2),
(4, 'assets/img/contoh/lontar-design-system-1.svg', 'Token warna & tipografi', 1),
(4, 'assets/img/contoh/lontar-design-system-2.svg', 'Komponen tombol dan form', 2),
(5, 'assets/img/contoh/basa-bahasa-bali-1.svg', 'Pelajaran harian bergamifikasi', 1),
(5, 'assets/img/contoh/basa-bahasa-bali-2.svg', 'Karakter maskot 3D', 2),
(6, 'assets/img/contoh/desa-bukit-asri-1.svg', 'Halaman paket tur', 1),
(6, 'assets/img/contoh/desa-bukit-asri-2.svg', 'Kalender upacara adat', 2),
(7, 'assets/img/contoh/tabungku-onboarding-1.svg', 'Langkah verifikasi KTP', 1),
(7, 'assets/img/contoh/tabungku-onboarding-2.svg', 'Pesan kesalahan yang ramah', 2),
(8, 'assets/img/contoh/riset-pasar-kriya-1.svg', 'Peta afinitas hasil wawancara', 1),
(8, 'assets/img/contoh/riset-pasar-kriya-2.svg', 'Persona perajin dan pembeli', 2);

INSERT INTO proyek_teknologi (proyek_id, teknologi_id) VALUES
(1, 1),
(1, 5),
(1, 2),
(2, 1),
(2, 2),
(2, 6),
(3, 1),
(3, 10),
(3, 11),
(4, 1),
(4, 6),
(4, 10),
(4, 11),
(5, 1),
(5, 4),
(5, 9),
(6, 1),
(6, 7),
(7, 1),
(7, 5),
(8, 5),
(8, 6),
(8, 1);

INSERT INTO pengalaman (jenis, posisi, instansi, kota, mulai, selesai, deskripsi) VALUES
('kerja', 'Senior Product Designer', 'Lontar Teknologi', 'Denpasar (hybrid)', '2023-02-01', NULL, 'Memimpin desain 2 produk dan design system perusahaan. Mendampingi 3 desainer junior.'),
('kerja', 'UI/UX Designer', 'Studio Pixel Pantai', 'Badung', '2021-01-01', '2023-01-01', 'Merancang aplikasi untuk klien pariwisata, F&B, dan fintech.'),
('kerja', 'Desainer Grafis & UI', 'Agensi Kreatif Sangkar', 'Denpasar', '2019-06-01', '2020-12-01', 'Membuat materi promosi digital dan desain website klien hotel.'),
('pendidikan', 'S1 Desain Komunikasi Visual', 'Institut Desain Bali', 'Denpasar', '2015-08-01', '2019-08-01', 'Tugas akhir: aplikasi panduan upacara adat untuk generasi muda.'),
('pendidikan', 'Bootcamp UX Research', 'Kelas Desain Nusantara', 'Daring', '2020-09-01', '2020-12-01', 'Lulusan terbaik angkatan, studi kasus aplikasi antrean puskesmas.');

INSERT INTO layanan (judul, deskripsi, ikon, harga_mulai, urutan) VALUES
('Desain Aplikasi Mobile', 'Dari alur pengguna sampai prototipe interaktif Android & iOS yang siap dikodekan.', 'smartphone', 9000000, 1),
('Desain Web App & Dashboard', 'Antarmuka admin, kasir, dan dashboard yang mudah dipahami pemakai baru.', 'layout-template', 7000000, 2),
('Riset & Uji Pengguna', 'Wawancara, uji prototipe, dan laporan temuan yang bisa langsung ditindaklanjuti.', 'search', 4500000, 3),
('Design System', 'Komponen Figma, token warna, dan dokumentasi untuk tim produk.', 'boxes', 12000000, 4),
('Website Webflow', 'Landing page dan company profile yang bisa diubah sendiri tanpa developer.', 'monitor', 5000000, 5);

INSERT INTO testimoni (nama, jabatan, isi, foto, rating, urutan) VALUES
('Made Wirawan', 'Pendiri Gaskeun Mobilitas', 'Kak Ayu bikin tim kami sadar bahwa masalahnya ada di tarif yang muncul terlambat. Setelah redesain, ulasan di Play Store langsung berubah.', 'assets/img/contoh/av-1.svg', 5, 1),
('Kadek Sari', 'Manajer Operasional Tenang Wellness', 'Tamu kami yang dari luar negeri juga bisa pesan sendiri. Desainnya cantik tapi tetap sederhana.', 'assets/img/contoh/av-2.svg', 5, 2),
('Rahmat Hidayat', 'Lead Engineer Lontar Teknologi', 'Design system dari Ayu menghemat banyak waktu developer. Token-nya rapi dan dokumentasinya jelas sekali.', 'assets/img/contoh/av-3.svg', 5, 3),
('Putu Agus', 'Pemilik Kopi Pantai Sanur', 'Barista baru cukup lihat sebentar langsung bisa pakai kasirnya. Antrean pagi jadi jauh lebih lancar.', 'assets/img/contoh/av-4.svg', 5, 4),
('Dewi Lestari', 'Product Manager Tabungku', 'Ayu sangat teliti saat uji pengguna dan berani menyampaikan temuan yang tidak enak didengar. Hasilnya angka pendaftaran kami naik jauh.', 'assets/img/contoh/av-5.svg', 4, 5),
('Gede Pratama', 'Ketua Pokdarwis Bukit Asri', 'Pengurus desa yang tidak paham komputer pun bisa memperbarui kalender upacara sendiri. Matur suksma, Gek Ayu!', 'assets/img/contoh/av-6.svg', 5, 6);

INSERT INTO pesan (nama, email, subjek, isi, anggaran, ip, dibaca, created_at) VALUES
('Nyoman Ardika', 'nyoman@villasawah.id', 'Aplikasi booking villa', 'Halo Kak Ayu, kami punya 6 villa di Ubud dan ingin aplikasi booking sendiri. Bisa bantu desain UI/UX-nya dulu?', 'Rp15 - 50 juta', '10.0.0.14', 0, NOW() - INTERVAL 1680 MINUTE),
('Sinta Maharani', 'sinta@kampusdesain.ac.id', 'Mengisi kelas Figma', 'Kami ingin mengundang Kak Ayu mengisi kelas Figma untuk mahasiswa semester 3. Apakah bisa di bulan depan?', 'Belum tahu', '10.0.0.25', 0, NOW() - INTERVAL 6300 MINUTE),
('Bagus Saputra', 'bagus.s@tokokain.com', 'Redesain toko online', 'Toko online kain endek kami terasa kuno. Butuh redesain halaman produk dan checkout.', 'Rp5 - 15 juta', '10.0.0.54', 1, NOW() - INTERVAL 18480 MINUTE);

INSERT INTO kunjungan (tanggal, jumlah) VALUES
(CURDATE() - INTERVAL 1 DAY, 70),
(CURDATE() - INTERVAL 2 DAY, 98),
(CURDATE() - INTERVAL 3 DAY, 89),
(CURDATE() - INTERVAL 4 DAY, 96),
(CURDATE() - INTERVAL 5 DAY, 112),
(CURDATE() - INTERVAL 6 DAY, 116),
(CURDATE() - INTERVAL 7 DAY, 80),
(CURDATE() - INTERVAL 8 DAY, 73),
(CURDATE() - INTERVAL 9 DAY, 73),
(CURDATE() - INTERVAL 10 DAY, 126),
(CURDATE() - INTERVAL 11 DAY, 51),
(CURDATE() - INTERVAL 12 DAY, 79),
(CURDATE() - INTERVAL 13 DAY, 75),
(CURDATE() - INTERVAL 14 DAY, 47),
(CURDATE() - INTERVAL 15 DAY, 51),
(CURDATE() - INTERVAL 16 DAY, 81),
(CURDATE() - INTERVAL 17 DAY, 41),
(CURDATE() - INTERVAL 18 DAY, 42),
(CURDATE() - INTERVAL 19 DAY, 51),
(CURDATE() - INTERVAL 20 DAY, 54),
(CURDATE() - INTERVAL 21 DAY, 58),
(CURDATE() - INTERVAL 22 DAY, 44),
(CURDATE() - INTERVAL 23 DAY, 94),
(CURDATE() - INTERVAL 24 DAY, 95),
(CURDATE() - INTERVAL 25 DAY, 78),
(CURDATE() - INTERVAL 26 DAY, 81),
(CURDATE() - INTERVAL 27 DAY, 59),
(CURDATE() - INTERVAL 28 DAY, 107),
(CURDATE() - INTERVAL 29 DAY, 57),
(CURDATE() - INTERVAL 30 DAY, 47);

