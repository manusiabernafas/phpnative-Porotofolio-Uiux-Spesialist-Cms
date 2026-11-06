<?php
require ROOT . '/includes/data.php';
$D = data_beranda();
$s = setting();
$kontak = $_SESSION['kontak'] ?? null;
unset($_SESSION['kontak']);
$foto = gambar($s['foto'] ?? '', 'assets/img/potret.svg');
$wa = nomor_wa($s['whatsapp'] ?? '');
$sapa = explode(' ', $s['nama'])[0];
// Layar ponsel 3D di hero memakai galeri proyek unggulan pertama (atau cover-nya)
$utama = array_values(array_filter($D['proyek'], fn($p) => $p['unggulan']))[0] ?? ($D['proyek'][0] ?? null);
$layar = $utama ? gambar((string) (q('SELECT file FROM proyek_gambar WHERE proyek_id = ? ORDER BY urutan LIMIT 1', [$utama['id']])->fetchColumn() ?: $utama['cover'])) : 'assets/img/kosong.svg';
$warna = ['c-acc', 'c-teal', 'c-yel', 'c-vio'];

/** Bentuk dekorasi Memphis: segitiga, lingkaran, zigzag, kotak, titik-titik. */
function bentuk(string $jenis, string $warna): string
{
    $svg = [
        'segitiga' => '<path d="M30 4l26 48H4z" fill="' . $warna . '" stroke="#231942" stroke-width="3" stroke-linejoin="round"/>',
        'lingkaran' => '<circle cx="30" cy="30" r="22" fill="none" stroke="' . $warna . '" stroke-width="9"/>',
        'zigzag' => '<path d="M4 38l10-16 10 16 10-16 10 16 10-16" fill="none" stroke="' . $warna . '" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>',
        'kotak' => '<rect x="12" y="12" width="36" height="36" rx="4" fill="' . $warna . '" stroke="#231942" stroke-width="3"/>',
        'titik' => implode('', array_map(fn($i) => '<circle cx="' . (10 + ($i % 4) * 13) . '" cy="' . (10 + intdiv($i, 4) * 13) . '" r="3.5" fill="' . $warna . '"/>', range(0, 15))),
        'gelombang' => '<path d="M4 30q7-12 14 0t14 0 14 0 14 0" fill="none" stroke="' . $warna . '" stroke-width="6" stroke-linecap="round"/>',
    ][$jenis];
    return '<svg viewBox="0 0 60 60" aria-hidden="true">' . $svg . '</svg>';
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?= meta_head($s['nama'] . ' · ' . $s['peran']) ?>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?<?= FONT_SITE ?>&display=swap">
    <link rel="stylesheet" href="assets/css/site.css">
    <?= css_aksen() ?>
    <script>document.documentElement.classList.add('js')</script>
</head>
<body>
<div class="scrollbar" aria-hidden="true"><i></i></div>
<header class="nav">
    <a href="#top" class="brand"><span class="brand-dot"></span><?= e($s['nama']) ?></a>
    <nav class="links" id="links"><a href="#karya">Karya</a><a href="#alat">Alat</a><a href="#jasa">Jasa</a><a href="#cerita">Cerita</a></nav>
    <a href="#halo" class="btn btn-acc btn-sm">Ayo ngobrol <?= icon('message-circle', 17) ?></a>
    <button class="burger btn btn-sm" aria-label="Menu" onclick="document.body.classList.toggle('menu-open')"><?= icon('menu', 20) ?></button>
</header>

<main id="top">
    <!-- HERO -->
    <section class="hero wrap">
        <div class="hero-text">
            <p class="hi-sticker">Halo, aku <?= e($sapa) ?>! <span class="wave"><?= icon('sparkles', 18) ?></span></p>
            <h1 class="bouncy"><?= e($s['judul_hero']) ?></h1>
            <p class="lead"><?= e($s['tagline']) ?></p>
            <div class="cta">
                <a class="btn btn-acc" href="#karya"><?= icon('mouse-pointer-click', 18) ?> Lihat karyaku</a>
                <?php if (!empty($s['cv'])): ?><a class="btn" href="<?= e(gambar($s['cv'])) ?>" download><?= icon('download', 18) ?> Unduh CV</a><?php endif; ?>
            </div>
            <?php if (($s['tersedia'] ?? '1') === '1'): ?><p class="avail"><span></span><?= e($s['status_teks']) ?></p><?php endif; ?>
        </div>
        <div class="hero-art" id="heroArt">
            <?php foreach ([['segitiga', '#ffc93c', 8, 4, 30], ['lingkaran', '#18b8a6', 78, 2, 50], ['zigzag', '#7b5cff', 2, 70, 20], ['kotak', '#ff5d73', 84, 74, 40], ['titik', '#231942', 64, 40, 12], ['gelombang', '#ff5d73', 20, 44, 26]] as [$j, $w, $x, $y, $d]): ?>
                <span class="shape" data-depth="<?= $d ?>" style="left:<?= $x ?>%;top:<?= $y ?>%"><?= bentuk($j, $w) ?></span>
            <?php endforeach; ?>
            <div class="phone-stage">
                <div class="phone" id="phone">
                    <div class="phone-side"></div>
                    <div class="phone-face"><span class="notch"></span><img src="<?= e($layar) ?>" alt="<?= e($utama['judul'] ?? '') ?>"></div>
                </div>
            </div>
            <img class="me" src="<?= e($foto) ?>" alt="<?= e($s['nama']) ?>" data-depth="18">
            <?php if ($utama): ?><a class="bubble" href="<?= url('proyek', ['slug' => $utama['slug']]) ?>" data-depth="34"><small>Karya terbaru</small><b><?= e($utama['judul']) ?></b></a><?php endif; ?>
        </div>
    </section>

    <!-- PITA ALAT -->
    <div class="ribbon" aria-hidden="true">
        <div class="ribbon-track">
            <?php for ($r = 0; $r < 2; $r++): foreach ($D['teknologi'] as $t): ?><span><?= logo($t['logo'], 26, $t['nama']) ?><?= e($t['nama']) ?></span><?php endforeach; endfor; ?>
        </div>
    </div>

    <!-- TENTANG -->
    <section class="wrap about" id="tentang">
        <div class="about-pic rv"><span class="ring"></span><img src="<?= e($foto) ?>" alt=""><span class="shape s-a"><?= bentuk('segitiga', '#7b5cff') ?></span><span class="shape s-b"><?= bentuk('titik', '#ff5d73') ?></span></div>
        <div>
            <h2 class="sec-title rv">Sedikit <span class="hl">tentang aku</span></h2>
            <div class="bio rv"><?= markdown_mini($s['bio'] ?? '') ?></div>
            <div class="facts">
                <?php foreach ([['tahun', 'tahun ngedesain'], ['proyek', 'produk dirilis'], ['klien', 'klien bahagia'], ['tek', 'alat favorit']] as $i => [$k, $l]): ?>
                    <div class="fact rv <?= $warna[$i % 4] ?>" style="--r:<?= [-3, 2, -2, 3][$i] ?>deg"><b data-count="<?= $D['angka'][$k] ?>">0</b><span><?= $l ?></span></div>
                <?php endforeach; ?>
            </div>
        </div>
    </section>

    <!-- KARYA: kartu bertumpuk saat scroll -->
    <section class="wrap" id="karya">
        <div class="sec-head">
            <h2 class="sec-title rv">Karya <span class="hl">pilihan</span></h2>
            <div class="chips" role="tablist">
                <button class="chip on" data-f="*">Semua</button>
                <?php foreach ($D['kategori'] as $k): ?><button class="chip" data-f="<?= e($k) ?>"><?= e($k) ?></button><?php endforeach; ?>
            </div>
        </div>
        <div class="stack">
            <?php foreach ($D['proyek'] as $i => $p): ?>
                <a class="scard <?= $warna[$i % 4] ?>" href="<?= url('proyek', ['slug' => $p['slug']]) ?>" data-k="<?= e($p['kategori']) ?>" style="--i:<?= $i ?>">
                    <div class="scard-img"><img src="<?= e(gambar($p['cover'])) ?>" alt="<?= e($p['judul']) ?>" loading="lazy"></div>
                    <div class="scard-body">
                        <p class="scard-meta"><span class="pill"><?= e($p['kategori']) ?></span><span><?= $p['tahun'] ?></span><?php if ($p['unggulan']): ?><span class="pill pill-star"><?= icon('star', 14) ?> Favorit</span><?php endif; ?></p>
                        <h3><?= e($p['judul']) ?></h3>
                        <p><?= e($p['ringkasan']) ?></p>
                        <div class="scard-foot"><span class="tools"><?php foreach ($p['tek'] as $t): ?><i title="<?= e($t['nama']) ?>"><?= logo($t['logo'], 20, $t['nama']) ?></i><?php endforeach; ?></span><span class="go"><?= icon('arrow-up-right', 24) ?></span></div>
                    </div>
                    <span class="scard-no"><?= str_pad((string) ($i + 1), 2, '0', STR_PAD_LEFT) ?></span>
                </a>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- ALAT: tombol keyboard -->
    <section class="wrap" id="alat">
        <h2 class="sec-title rv">Isi <span class="hl">tas kerjaku</span></h2>
        <p class="sub rv">Coba tekan tombolnya.</p>
        <div class="keys rv">
            <?php foreach ($D['teknologi'] as $i => $t): ?>
                <button class="key" type="button" style="--lv:<?= (int) $t['level'] ?>%"><span class="cap <?= $warna[$i % 4] ?>"><?= logo($t['logo'], 30, $t['nama']) ?><b><?= e($t['nama']) ?></b><small><?= e($t['kategori']) ?> &middot; <?= (int) $t['level'] ?>%</small><i></i></span></button>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- JASA -->
    <?php if ($D['layanan']): ?>
    <section class="wrap" id="jasa">
        <h2 class="sec-title rv">Bisa aku <span class="hl">bantu</span></h2>
        <div class="services">
            <?php foreach ($D['layanan'] as $i => $l): ?>
                <article class="svc rv">
                    <span class="svc-ic <?= $warna[$i % 4] ?>"><?= icon($l['ikon'], 30) ?></span>
                    <h3><?= e($l['judul']) ?></h3>
                    <p><?= e($l['deskripsi']) ?></p>
                    <p class="price"><?= $l['harga_mulai'] ? 'mulai <b>' . rupiah((int) $l['harga_mulai']) . '</b>' : 'harga sesuai kebutuhan' ?></p>
                </article>
            <?php endforeach; ?>
        </div>
    </section>
    <?php endif; ?>

    <!-- CERITA: timeline garis berliku -->
    <section class="wrap" id="cerita">
        <h2 class="sec-title rv">Perjalanan <span class="hl">sejauh ini</span></h2>
        <div class="path-wrap" id="pathWrap">
            <svg class="path-line" viewBox="0 0 100 1000" preserveAspectRatio="none" aria-hidden="true"><path id="pathDraw" d="M50 0C90 80 10 160 50 250S90 410 50 500 10 660 50 750 90 910 50 1000" fill="none" stroke="var(--ink)" stroke-width="4" vector-effect="non-scaling-stroke" stroke-linecap="round"/></svg>
            <?php foreach (array_merge($D['kerja'], $D['pendidikan']) as $i => $x): ?>
                <div class="stop rv <?= $i % 2 ? 'right' : 'left' ?>">
                    <span class="dot <?= $warna[$i % 4] ?>"><?= icon($x['jenis'] === 'kerja' ? 'briefcase' : 'graduation-cap', 20) ?></span>
                    <div class="stop-card">
                        <p class="when"><?= bulan_tahun($x['mulai']) ?> &ndash; <?= bulan_tahun($x['selesai']) ?></p>
                        <h3><?= e($x['posisi']) ?></h3>
                        <p class="where"><?= e($x['instansi']) ?><?= $x['kota'] ? ' &middot; ' . e($x['kota']) : '' ?></p>
                        <p><?= e($x['deskripsi']) ?></p>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- TESTIMONI: percakapan -->
    <?php if ($D['testimoni']): ?>
    <section class="wrap chat-sec" id="kata">
        <h2 class="sec-title rv">Kata <span class="hl">mereka</span></h2>
        <div class="chat" id="chat">
            <div class="chat-head"><img src="<?= e($foto) ?>" alt=""><span><b>Grup Klien Kesayangan</b><small><?= count($D['testimoni']) ?> anggota &middot; online</small></span></div>
            <div class="chat-body">
                <?php foreach ($D['testimoni'] as $i => $t): ?>
                    <div class="msg <?= $i % 2 ? 'r' : 'l' ?>" style="--n:<?= $i ?>">
                        <img src="<?= e(gambar($t['foto'], 'assets/img/avatar.svg')) ?>" alt="" loading="lazy">
                        <div class="msg-bubble <?= $warna[$i % 4] ?>"><b><?= e($t['nama']) ?> <small><?= e($t['jabatan']) ?></small></b><p><?= e($t['isi']) ?></p><span class="stars" aria-label="<?= (int) $t['rating'] ?> dari 5"><?php for ($k = 0; $k < (int) $t['rating']; $k++): ?><?= icon('star', 13) ?><?php endfor; ?></span></div>
                    </div>
                <?php endforeach; ?>
                <div class="typing" aria-hidden="true"><i></i><i></i><i></i></div>
            </div>
        </div>
    </section>
    <?php endif; ?>

    <!-- KONTAK -->
    <section class="wrap" id="halo">
        <div class="contact rv">
            <div class="contact-side">
                <h2 class="sec-title">Ayo bikin sesuatu <span class="hl">bareng!</span></h2>
                <p>Cerita sedikit tentang produkmu. Aku akan balas paling lambat 1x24 jam di hari kerja.</p>
                <ul class="ways">
                    <?php if (!empty($s['email'])): ?><li><a class="btn btn-sm" href="mailto:<?= e($s['email']) ?>"><?= icon('mail', 17) ?> <?= e($s['email']) ?></a></li><?php endif; ?>
                    <?php if ($wa): ?><li><a class="btn btn-sm" href="https://wa.me/<?= e($wa) ?>" target="_blank" rel="noopener"><?= icon('message-circle', 17) ?> WhatsApp</a></li><?php endif; ?>
                    <?php foreach (sosial() as $so): ?><li><a class="btn btn-sm" href="<?= e($so['url']) ?>" target="_blank" rel="noopener"><?= $so['svg'] ?> <?= e($so['label']) ?></a></li><?php endforeach; ?>
                </ul>
            </div>
            <form class="cform" method="post" action="<?= url('kirim') ?>" id="cform" novalidate>
                <?= csrf_field() ?>
                <div class="hp" aria-hidden="true"><label>Website<input name="website" tabindex="-1" autocomplete="off"></label></div>
                <div class="two"><label>Namamu<input name="nama" required maxlength="100" autocomplete="name"></label><label>Email<input type="email" name="email" required maxlength="150" autocomplete="email"></label></div>
                <label>Topik<input name="subjek" maxlength="150" placeholder="Desain aplikasi booking"></label>
                <fieldset><legend>Perkiraan anggaran</legend>
                    <div class="radio-chips"><?php foreach (ANGGARAN as $a): ?><label><input type="radio" name="anggaran" value="<?= e($a) ?>"><span><?= e($a) ?></span></label><?php endforeach; ?></div>
                </fieldset>
                <label>Ceritanya<textarea name="isi" rows="5" required minlength="10" maxlength="3000" placeholder="Aplikasinya untuk siapa, masalahnya apa..."></textarea></label>
                <button class="btn btn-acc btn-lg" type="submit"><?= icon('send', 19) ?> Kirim pesan</button>
                <p class="form-msg <?= $kontak ? ($kontak[0] ? 'ok' : 'err') : '' ?>" id="formMsg" role="status"><?= $kontak ? e($kontak[1]) : '' ?></p>
            </form>
        </div>
    </section>
</main>

<footer class="foot">
    <div class="wrap">
        <p class="foot-big">Sampai <span class="hl">ketemu</span> lagi!</p>
        <div class="foot-row"><span>&copy; <?= date('Y') ?> <?= e($s['nama']) ?> &middot; dibuat dengan PHP &amp; MySQL</span><a href="<?= url('login') ?>" rel="nofollow"><?= icon('lock', 14) ?> CMS</a></div>
    </div>
</footer>
<script src="assets/js/site.js"></script>
</body>
</html>
