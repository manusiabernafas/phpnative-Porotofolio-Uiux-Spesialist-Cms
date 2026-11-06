// Efek halaman Memphis: huruf memantul, ponsel 3D, kartu bertumpuk, keycap, garis berliku, chat testimoni
(() => {
    const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
    const fine = matchMedia('(hover: hover)').matches;
    const $ = (s, el = document) => el.querySelector(s);
    const $$ = (s, el = document) => [...el.querySelectorAll(s)];
    const esc = t => t.replace(/&/g, '&amp;').replace(/</g, '&lt;');

    // Judul: pecah per huruf (dibungkus per kata agar tetap terpotong rapi di HP)
    $$('.bouncy').forEach(h => {
        let n = 0;
        h.innerHTML = h.textContent.trim().split(/\s+/).map(w => `<span class="wd">${[...w].map(c => `<span class="ch" style="transition-delay:${(n++) * 22}ms">${esc(c)}</span>`).join('')}</span>`).join(' ');
        setTimeout(() => h.classList.add('in'), 150);
        setTimeout(() => $$('.ch', h).forEach(c => { c.style.transitionDelay = ''; }), 150 + n * 22 + 600);
    });

    // Parallax bentuk & ponsel 3D mengikuti kursor dan scroll
    const art = $('#heroArt'), phone = $('#phone'), movers = art ? $$('[data-depth]', art) : [];
    let mx = 0, my = 0;
    const paintHero = () => {
        const sy = Math.min(scrollY, 800);
        movers.forEach(el => { const d = +el.dataset.depth; el.style.translate = `${mx * d}px ${my * d - sy * d / 50}px`; });
        if (phone) phone.style.transform = `rotateY(${-22 + mx * 30 + sy / 18}deg) rotateX(${8 - my * 16}deg) rotateZ(${sy / 60}deg)`;
    };
    if (art && !reduce && fine) addEventListener('pointermove', e => { mx = e.clientX / innerWidth - 0.5; my = e.clientY / innerHeight - 0.5; requestAnimationFrame(paintHero); });

    // Kartu proyek bertumpuk: kartu yang tertimpa sedikit mengecil
    const cards = $$('.scard');
    const paintStack = () => {
        const vis = cards.filter(c => !c.classList.contains('hide'));
        vis.forEach((c, i) => {
            const next = vis[i + 1];
            if (!next || reduce) { c.style.transform = ''; return; }
            const gap = next.getBoundingClientRect().top - c.getBoundingClientRect().top;
            const p = Math.min(1, Math.max(0, 1 - gap / c.offsetHeight));
            c.style.transform = `scale(${1 - p * 0.06}) rotate(${p * (i % 2 ? 1.2 : -1.2)}deg)`;
        });
    };

    // Garis berliku perjalanan tergambar sesuai scroll
    const path = $('#pathDraw'), pathWrap = $('#pathWrap');
    let pathLen = 0;
    if (path) { pathLen = path.getTotalLength(); path.style.strokeDasharray = `${pathLen}`; path.style.strokeDashoffset = reduce ? 0 : pathLen; }
    const paintPath = () => {
        if (!path || reduce) return;
        const r = pathWrap.getBoundingClientRect();
        const p = Math.min(1, Math.max(0, (innerHeight * 0.75 - r.top) / r.height));
        path.style.strokeDashoffset = pathLen * (1 - p);
    };

    const bar = $('.scrollbar i'), cover = $('#dcover');
    let ticking = false;
    const onScroll = () => {
        const h = document.documentElement.scrollHeight - innerHeight;
        if (bar) bar.style.transform = `scaleX(${h > 0 ? scrollY / h : 0})`;
        if (!reduce) paintHero();
        paintStack(); paintPath();
        if (cover && !reduce) {
            const r = cover.getBoundingClientRect();
            const t = Math.min(1, Math.max(0, 1 - (r.top - 100) / (innerHeight * 0.6)));
            cover.style.transform = `rotateX(${16 * (1 - t)}deg) scale(${0.94 + 0.06 * t})`;
        }
        ticking = false;
    };
    addEventListener('scroll', () => { if (!ticking) { ticking = true; requestAnimationFrame(onScroll); } }, { passive: true });
    addEventListener('resize', onScroll);
    onScroll();

    // Reveal & hitung angka
    const count = el => {
        const n = +el.dataset.count; if (reduce) { el.textContent = n; return; }
        const t0 = performance.now();
        const step = t => { const p = Math.min(1, (t - t0) / 1000); el.textContent = Math.round(n * (1 - Math.pow(1 - p, 3))); if (p < 1) requestAnimationFrame(step); };
        requestAnimationFrame(step);
    };
    const io = new IntersectionObserver(es => es.forEach(en => {
        if (!en.isIntersecting) return;
        en.target.classList.add('in');
        $$('[data-count]', en.target).forEach(count);
        if (en.target.dataset.count) count(en.target);
        io.unobserve(en.target);
    }), { threshold: 0.12 });
    $$('.rv').forEach(el => io.observe(el));

    // Filter kategori karya
    $$('.chips .chip').forEach(b => b.addEventListener('click', () => {
        $$('.chips .chip').forEach(x => x.classList.toggle('on', x === b));
        cards.forEach(c => c.classList.toggle('hide', b.dataset.f !== '*' && c.dataset.k !== b.dataset.f));
        onScroll();
    }));

    // Keycap: klik atau ketik huruf awal nama alat untuk "menekan" tombolnya
    const keys = $$('.key');
    const press = k => { k.classList.add('press'); setTimeout(() => k.classList.remove('press'), 140); };
    keys.forEach(k => k.addEventListener('click', () => press(k)));
    addEventListener('keydown', e => {
        if (e.ctrlKey || e.metaKey || e.altKey || /input|textarea|select/i.test(document.activeElement?.tagName || '')) return;
        const huruf = e.key.length === 1 ? e.key.toLowerCase() : '';
        if (huruf) keys.filter(k => $('b', k).textContent.trim().toLowerCase().startsWith(huruf)).forEach(press);
    });

    // Chat testimoni: pesan muncul satu per satu dengan indikator "mengetik"
    const chat = $('#chat');
    if (chat) {
        const msgs = $$('.msg', chat), typing = $('.typing', chat), body = $('.chat-body', chat);
        const play = () => {
            let i = 0;
            const next = () => {
                if (i >= msgs.length) { typing.classList.remove('on'); return; }
                typing.classList.add('on');
                if (msgs[i].classList.contains('r')) typing.style.alignSelf = 'flex-end'; else typing.style.alignSelf = 'flex-start';
                body.appendChild(typing);
                setTimeout(() => { msgs[i].classList.add('show'); i++; next(); }, reduce ? 0 : 900);
            };
            next();
        };
        const cio = new IntersectionObserver(es => { if (es[0].isIntersecting) { play(); cio.disconnect(); } }, { threshold: 0.3 });
        cio.observe(chat);
    }

    // Formulir kontak (fetch), tetap jalan tanpa JS
    const form = $('#cform'), msg = $('#formMsg');
    if (form) form.addEventListener('submit', async e => {
        e.preventDefault();
        if (!form.reportValidity()) return;
        const btn = $('button[type=submit]', form);
        btn.disabled = true; msg.className = 'form-msg'; msg.textContent = 'Lagi dikirim...';
        try {
            const r = await fetch(form.action, { method: 'POST', body: new FormData(form), headers: { 'X-Requested-With': 'fetch' } });
            const j = await r.json();
            msg.className = 'form-msg ' + (j.ok ? 'ok' : 'err'); msg.textContent = j.msg;
            if (j.ok) form.reset();
        } catch { msg.className = 'form-msg err'; msg.textContent = 'Koneksinya putus. Coba lagi ya.'; }
        btn.disabled = false;
    });

    // Lightbox galeri
    const lb = $('#lb');
    if (lb) {
        $$('[data-lb]').forEach(a => a.addEventListener('click', e => { e.preventDefault(); $('img', lb).src = a.href; $('img', lb).alt = $('img', a).alt; lb.hidden = false; }));
        lb.addEventListener('click', () => { lb.hidden = true; });
        addEventListener('keydown', e => { if (e.key === 'Escape') lb.hidden = true; });
    }
    $$('#links a').forEach(a => a.addEventListener('click', () => document.body.classList.remove('menu-open')));
})();
