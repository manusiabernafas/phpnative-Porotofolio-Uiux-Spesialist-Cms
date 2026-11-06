# Memphis — Template Portofolio UI/UX Designer + CMS (PHP Native + MySQL)

Template portofolio bergaya Memphis 90-an untuk UI/UX designer, product designer, dan mobile designer. Warna cerah flat, bentuk geometris yang melayang mengikuti kursor, tombol timbul yang bisa "ditekan", ponsel 3D yang berputar menampilkan karya terbaru, kartu proyek yang menumpuk saat di-scroll, keycap alat kerja yang bisa ditekan dari keyboard, garis perjalanan berliku yang tergambar sendiri, dan testimoni berbentuk percakapan grup chat.

## Isi folder

| Path | Fungsi |
|---|---|
| `index.php` | Router: halaman publik (`beranda`, `proyek`, `kirim`) + halaman CMS |
| `config/database.php` | Koneksi MySQL |
| `includes/bootstrap.php` | PDO, CSRF, login & sesi, upload gambar → WebP, ikon & logo |
| `includes/data.php` | Pengambil data halaman publik |
| `includes/tema.php` | Pilihan warna utama & font tema Memphis |
| `includes/logos.php`, `includes/icons.php` | 70+ logo aplikasi satu warna & ikon garis |
| `pages/beranda.php`, `pages/proyek.php` | Halaman depan & studi kasus proyek |
| `pages/kirim.php` | Penerima formulir kontak |
| `pages/admin/*` | Halaman CMS |
| `assets/css`, `assets/js` | Tampilan & efek (tanpa framework) |
| `assets/img` | Potret & avatar ilustrasi, mockup proyek contoh |
| `assets/uploads` | File yang diunggah dari CMS |
| `database/porto_memphis.sql` | Skema + data contoh |

## Instalasi singkat

1. Salin folder `porto-memphis` ke `htdocs` (XAMPP) atau `www` (Laragon).
2. Jalankan Apache & MySQL, impor `database/porto_memphis.sql` lewat phpMyAdmin.
3. Sesuaikan `config/database.php` bila perlu.
4. Situs: `http://localhost/porto-memphis/` — CMS: `http://localhost/porto-memphis/index.php?page=login`
   Login awal **admin / admin123**, segera ganti di menu **Akun**.

## Yang bisa diatur dari CMS

- **Profil & Situs**: nama (kata pertama dipakai untuk sapaan "Halo, aku ..."), peran, kalimat hero, tagline, bio, kota, status, foto, CV PDF, kontak, media sosial, SEO, 4 warna utama (koral, teal, ungu, kuning).
- **Proyek**: semua detail + cover, galeri, alat, urutan. **Gambar galeri pertama dari proyek unggulan pertama** otomatis tampil di layar ponsel 3D di hero.
- **Teknologi / alat**: logo, kategori, tingkat penguasaan (jadi garis di bawah keycap).
- **Pengalaman & pendidikan** (garis berliku), **Layanan**, **Testimoni** (gelembung chat), **Pesan masuk** + CSV, **Dashboard**.

## Catatan keamanan

- PDO prepared statement, escape output, CSRF di semua form.
- Password hash, login dikunci 15 menit setelah 5 kali gagal, sesi lain otomatis keluar saat password diganti.
- Gambar dicek MIME aslinya lalu digambar ulang menjadi WebP; CV hanya PDF; folder upload diberi `.htaccess` anti-eksekusi.
- Hanya link `http(s)://` yang diterima.
- Formulir kontak: honeypot, maksimal 3 pesan per 10 menit per IP, tolak pesan dobel, pilihan anggaran divalidasi di server.
- CSV aman dari formula injection.

## Catatan tampilan

- Gerak bentuk & ponsel mengikuti kursor hanya di perangkat dengan mouse; di HP keduanya tetap bergerak mengikuti scroll.
- Semua animasi mati otomatis bila pengunjung mengaktifkan "kurangi gerakan".
