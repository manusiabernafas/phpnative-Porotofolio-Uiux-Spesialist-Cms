<?php
require ROOT . '/includes/data.php';
$p = data_proyek((string) ($_GET['slug'] ?? ''));
if (!$p) { http_response_code(404); require ROOT . '/pages/404.php'; exit; }
$s = setting();
$info = array_filter(['Klien' => $p['klien'] ?: 'Proyek pribadi', 'Peran' => $p['peran'], 'Tahun' => $p['tahun'], 'Durasi' => $p['durasi']]);
$warna = ['c-acc', 'c-teal', 'c-yel', 'c-vio'];
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?= meta_head($p['judul'] . ' · ' . $s['nama'], $p['ringkasan'], gambar($p['cover'])) ?>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?<?= FONT_SITE ?>&display=swap">
    <link rel="stylesheet" href="assets/css/site.css">
    <?= css_aksen() ?>
    <script>document.documentElement.classList.add('js')</script>
</head>
<body class="detail">
<div class="scrollbar" aria-hidden="true"><i></i></div>
<header class="nav">
    <a href="index.php#karya" class="brand"><?= icon('arrow-left', 20) ?> Semua karya</a>
    <a href="index.php#halo" class="btn btn-acc btn-sm">Ayo ngobrol <?= icon('message-circle', 17) ?></a>
</header>
<main>
    <section class="wrap d-hero">
        <p class="hi-sticker"><?= e($p['kategori']) ?> &middot; <?= $p['tahun'] ?></p>
        <h1 class="bouncy"><?= e($p['judul']) ?></h1>
        <p class="lead"><?= e($p['ringkasan']) ?></p>
        <div class="d-meta"><?php foreach (array_values($info) as $i => $v): ?><span class="fact <?= $warna[$i % 4] ?>"><small><?= array_keys($info)[$i] ?></small><b><?= e($v) ?></b></span><?php endforeach; ?></div>
    </section>
    <div class="d-cover-stage wrap"><figure class="d-cover" id="dcover"><span class="dots"><i></i><i></i><i></i></span><img src="<?= e(gambar($p['cover'])) ?>" alt="<?= e($p['judul']) ?>"></figure></div>
    <section class="wrap d-body">
        <article class="prose rv"><?= markdown_mini($p['isi']) ?></article>
        <aside class="d-side rv">
            <?php if ($p['tek']): ?><h3>Alat yang dipakai</h3><ul class="d-tek"><?php foreach ($p['tek'] as $i => $t): ?><li class="<?= $warna[$i % 4] ?>"><?= logo($t['logo'], 20, $t['nama']) ?> <?= e($t['nama']) ?></li><?php endforeach; ?></ul><?php endif; ?>
            <?php if ($u = link_aman($p['link_demo'])): ?><a class="btn btn-acc" href="<?= e($u) ?>" target="_blank" rel="noopener"><?= icon('external-link', 18) ?> Coba prototipenya</a><?php endif; ?>
            <?php if ($u = link_aman($p['link_repo'])): ?><a class="btn" href="<?= e($u) ?>" target="_blank" rel="noopener"><?= icon('file-text', 18) ?> Dokumen</a><?php endif; ?>
        </aside>
    </section>
    <?php if ($p['galeri']): ?>
    <section class="wrap d-gallery">
        <?php foreach ($p['galeri'] as $i => $g): ?>
            <figure class="rv"><a href="<?= e(gambar($g['file'])) ?>" data-lb><img src="<?= e(gambar($g['file'])) ?>" alt="<?= e($g['keterangan']) ?>" loading="lazy"></a><?php if ($g['keterangan']): ?><figcaption class="<?= $warna[$i % 4] ?>"><?= e($g['keterangan']) ?></figcaption><?php endif; ?></figure>
        <?php endforeach; ?>
    </section>
    <?php endif; ?>
    <?php if ($p['berikut']): ?>
    <nav class="wrap d-next">
        <a href="<?= url('proyek', ['slug' => $p['sebelum']['slug']]) ?>" class="c-teal"><small><?= icon('arrow-left', 16) ?> Sebelumnya</small><b><?= e($p['sebelum']['judul']) ?></b></a>
        <a href="<?= url('proyek', ['slug' => $p['berikut']['slug']]) ?>" class="c-yel nx"><small>Berikutnya <?= icon('arrow-right', 16) ?></small><b><?= e($p['berikut']['judul']) ?></b></a>
    </nav>
    <?php endif; ?>
</main>
<div class="lightbox" id="lb" hidden><button class="btn btn-sm" aria-label="Tutup"><?= icon('x', 20) ?></button><img alt=""></div>
<footer class="foot"><div class="wrap foot-row"><span>&copy; <?= date('Y') ?> <?= e($s['nama']) ?></span><a href="index.php#halo">Ayo ngobrol</a></div></footer>
<script src="assets/js/site.js"></script>
</body>
</html>
