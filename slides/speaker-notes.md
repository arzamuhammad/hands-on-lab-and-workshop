# Naskah Pemateri — "From Zero to Data" (Sesi Teori 2 Jam)

Panduan bicara **detail per slide**. Audiens: **mahasiswa baru, tanpa background coding.**
Tempo: ~100 menit konten + ~20 menit buffer/Q&A. Energi tinggi, banyak analogi, sering tanya balik.

> 🎯 Aturan emas: 1 ide besar per slide. Bicara *ke* mahasiswa, bukan membaca slide.
> 🗣️ Bagian **"Naskah"** boleh dibacakan/ diparafrase. **"Tanya"** = pancing interaksi.

---

## Slide 1 — Cover: FROM ZERO TO DATA  ⏱️ ~3 menit
**Tujuan:** sambutan hangat + bikin mereka penasaran & tidak takut.
**Naskah:**
> "Selamat pagi semuanya! Hari ini kita akan jalan-jalan ke dunia DATA. Tenang — kalian tidak
> perlu bisa coding sama sekali. Dalam 4 jam ke depan, kalian yang sekarang merasa 'nol soal data'
> akan benar-benar membangun sebuah dashboard data sungguhan dengan tangan kalian sendiri."

- Perkenalkan diri singkat (nama, pekerjaan, kenapa suka data) — maksimal 30 detik.
- Tegaskan janji: "Tidak ada yang namanya pertanyaan bodoh hari ini."
**Transisi:** "Sebelum mulai, mari lihat dulu apa saja yang akan kita pelajari."

---

## Slide 2 — Agenda: TODAY'S JOURNEY  ⏱️ ~2 menit
**Tujuan:** beri peta perjalanan agar mereka tahu arah.
**Naskah:** jelaskan 5 bagian satu per satu, singkat:
> "Pertama, kita kenalan dengan database. Kedua, dua dunia data: OLTP dan OLAP. Ketiga, kita
> bandingkan cara lama vs cara modern. Keempat — ini yang paling seru — peluang karier di dunia
> data. Kelima, kenalan dengan SQL. Lalu setelah istirahat, kita praktik langsung."
**Tanya:** "Coba angkat tangan, siapa yang belum pernah menulis satu baris kode pun?"
→ apa pun jawabannya, yakinkan: "Sesi ini memang dirancang untuk kalian."
**Transisi:** "Mari mulai dari hal paling dekat dengan kita: data di kehidupan sehari-hari."

---

## Slide 3 — Data Is Everywhere Around You  ⏱️ ~4 menit
**Tujuan:** ice-breaker, bikin data terasa nyata & personal.
**Tanya:** "Menurut kalian, sebanyak apa data yang sudah kalian buat hari ini sebelum makan siang?"
→ tunggu beberapa jawaban, beri respons.
**Naskah:**
> "Setiap kali kalian scroll TikTok, aplikasi mencatat video apa yang kalian tonton dan berapa lama.
> Setiap pesan WhatsApp, setiap pesan Gojek, setiap bayar pakai QRIS — semua itu menghasilkan data.
> Artinya, kalian sebenarnya sudah berinteraksi dengan sistem data raksasa setiap hari, bahkan tanpa
> sadar. Hari ini kita akan buka 'kap mesin'-nya: ke mana data itu pergi, dan bagaimana ia diolah
> jadi keputusan."
**Poin kunci:** data itu BUKAN sesuatu yang abstrak — itu kehidupan mereka sendiri.
**Transisi:** "Semua data tadi harus disimpan di suatu tempat yang rapi. Tempat itu namanya database."

---

## Slide 4 — Section: PART 1 — UNDERSTANDING DATABASES  ⏱️ ~30 detik
**Tujuan:** penanda babak.
**Naskah:** "Babak pertama: fondasi paling dasar — apa itu database dan kenapa ia penting."

---

## Slide 5 — From Data to Decisions  ⏱️ ~4 menit
**Tujuan:** tanam konsep tangga data → informasi → keputusan.
**Naskah:**
> "Ada tiga tingkatan. Pertama DATA — fakta mentah, misalnya angka 37, 42, 29. Sendirian, angka ini
> tidak berarti apa-apa. Kedua INFORMASI — saat data kita susun & olah jadi punya makna, misalnya
> 'rata-rata nilai kelas adalah 36'. Ketiga KEPUTUSAN — aksi dari informasi itu, misalnya 'berarti
> kelas ini butuh jam tambahan'."
**Tanya:** "Jadi, mana yang lebih berharga: data mentah, atau keputusan?" → arahkan ke jawaban:
data mentah baru berharga kalau bisa diubah jadi keputusan.
**Poin kunci:** seluruh pekerjaan orang data = mengubah data jadi keputusan. Database adalah titik awalnya.
**Transisi:** "Nah, di mana data mentah tadi disimpan dengan rapi? Di database. Tapi, apa sih database itu?"

---

## Slide 6 — What Is a Database?  ⏱️ ~4 menit
**Tujuan:** definisi lewat analogi yang sangat relatable.
**Naskah (mulai dari analogi, bukan definisi):**
> "Bayangkan sebuah lemari arsip raksasa. Tapi bukan lemari biasa yang berantakan — ini lemari yang
> super rapi: setiap dokumen punya tempatnya, diberi label, dan bisa ditemukan dalam sepersekian
> detik. Itulah database: tempat menyimpan data supaya bisa dicari dan diambil secepat kilat."
- Bandingkan: cari satu kertas di kamar berantakan (lama, frustrasi) vs ketik di database (instan).
**Tanya:** "Ada yang pakai aplikasi Kontak di HP? Itu sebenarnya database mini — nama, nomor,
email, tersimpan rapi dan bisa dicari. Kalian sudah pakai database tiap hari!"
**Poin kunci:** database = lemari arsip digital yang super rapi & super cepat.
**Transisi:** "Kalau buat HP saja berguna, bayangkan untuk perusahaan besar. Kenapa mereka wajib punya?"

---

## Slide 7 — Why Every Enterprise Needs One (dua kolom)  ⏱️ ~5 menit
**Tujuan:** tunjukkan pentingnya database lewat kontras & contoh nyata.
**Kolom kiri — "Tanpa database":**
> "Kalau perusahaan tidak punya database: data tersebar di mana-mana — di Excel si A, di catatan si B,
> di email si C. Akibatnya lambat, gampang salah, dan tidak ada yang bisa dipercaya sebagai 'sumber
> kebenaran tunggal'."
**Kolom kanan — contoh nyata:**
> "Bank: setiap transaksi kalian harus tercatat aman — tidak boleh hilang sepeser pun. E-commerce:
> jutaan produk, pesanan, pembayaran harus terorganisir. Rumah sakit: data pasien harus bisa diambil
> dalam hitungan detik saat darurat."
**Tanya:** "Bayangkan kalau bank kehilangan catatan transaksi kalian. Kacau, kan?"
**Poin kunci:** database = tulang punggung setiap perusahaan serius.
**Transisi:** "Tapi tidak semua database mengerjakan tugas yang sama. Ada DUA keluarga besar."

---

## Slide 8 — Section: PART 2 — OLTP vs OLAP  ⏱️ ~30 detik
**Naskah:** "Babak kedua. Dua jenis database yang tugasnya sangat berbeda: OLTP dan OLAP.
Istilahnya terdengar teknis, tapi konsepnya sederhana. Akan saya jelaskan pelan-pelan."

---

## Slide 9 — Two Worlds of Data  ⏱️ ~3 menit
**Tujuan:** siapkan kontras inti: mencatat vs menganalisis.
**Naskah:**
> "Ada sistem yang tugasnya MENCATAT apa yang sedang terjadi — namanya transaksi. Ada juga sistem
> yang tugasnya MENGANALISIS apa yang sudah terjadi — namanya analitik. Supaya gampang, kita pakai
> satu contoh yang sama: sebuah toko ritel / minimarket."
**Poin kunci:** satu untuk 'mencatat sekarang', satu untuk 'memahami yang lalu'.
**Transisi:** "Mari kita sandingkan keduanya."

---

## Slide 10 — OLTP vs OLAP (dua kolom)  ⏱️ ~6 menit
**Tujuan:** slide INTI. Pastikan kontras terasa jelas.
**Kolom kiri — OLTP (Transaksi):**
> "OLTP itu MOMEN saat kalian tap tombol 'Bayar' di kasir. Cepat, satu transaksi, satu baris data,
> real-time. Banyak orang melakukannya bersamaan, dan datanya selalu yang TERBARU. Sistem ini sibuk
> MENULIS data baru terus-menerus."
**Kolom kanan — OLAP (Analitik):**
> "OLAP itu saat MANAJER bertanya: 'produk apa yang paling laku 3 bulan terakhir di seluruh cabang
> se-Indonesia?'. Untuk menjawabnya, sistem harus MEMBACA jutaan baris data dan meringkasnya.
> Penggunanya sedikit (para analis), tapi setiap pertanyaan berat. Ini soal data HISTORIS."
**Tanya (kuis kecil):** beri 2-3 skenario, minta mereka tebak OLTP atau OLAP:
- "Kalian top-up e-wallet?" → OLTP.
- "CEO minta laporan penjualan tahunan?" → OLAP.
- "Kalian beli pulsa?" → OLTP.
**Poin kunci:** OLTP = mencatat cepat 1 baris; OLAP = membaca & meringkas jutaan baris.
**Transisi:** "Kenapa pembedaan ini penting buat kalian? Ini dia."

---

## Slide 11 — Why It Matters  ⏱️ ~3 menit
**Tujuan:** sambungkan ke relevansi & ke topik karier.
**Naskah:**
> "OLTP membuat bisnis tetap BERJALAN setiap detik — tanpa itu, kalian tidak bisa checkout. Tapi
> OLAP yang membuat bisnis BERKEMBANG — karena dari analisis-lah perusahaan tahu harus melangkah ke
> mana. Dan ini bocoran penting: profesi-profesi data yang akan kita bahas sebentar lagi, sebagian
> besar hidup di dunia OLAP."
**Poin kunci:** OLTP menjalankan bisnis; OLAP menumbuhkan bisnis.
👉 **Slide QUIZ 1 muncul setelah ini** (Databases & OLTP/OLAP) — lihat Kunci Jawaban di bawah.
   Tips: jalankan paralel di Kahoot/Mentimeter agar interaktif.
**Transisi:** "Sekarang, bagaimana perusahaan dulu melakukan analitik sebelum ada cloud? Mari kita mesin waktu."

---

## Slide 12 — Section: PART 3 — THEN vs NOW  ⏱️ ~30 detik
**Naskah:** "Babak ketiga: perbandingan cara LAMA (on-premise) dan cara BARU (cloud). Di sinilah
kalian akan paham kenapa dunia data meledak beberapa tahun terakhir."

---

## Slide 13 — The Old Way: On-Premise (dua kolom)  ⏱️ ~5 menit
**Tujuan:** gambarkan cara lama + rasa sakitnya (pain point).
**Kolom kiri — cara kerjanya:**
> "Dulu, kalau perusahaan mau olah data, mereka harus BELI server dan storage sendiri. Disimpan di
> ruangan khusus yang dingin (ber-AC kuat), dan ada tim yang merawatnya 24 jam."
**Kolom kanan — rasa sakitnya:**
> "Masalahnya: biaya di muka SANGAT besar (istilahnya CAPEX). Kapasitas harus ditebak bertahun-tahun
> ke depan. Dan yang paling penting — STORAGE dan COMPUTE terkunci jadi satu. Mau nambah tenaga
> hitung saja, harus beli mesin baru lengkap. Mau scaling? Bisa berbulan-bulan."
**Tekankan** frasa "terkunci jadi satu" — ini kunci yang akan terbayar di slide cloud nanti.
**Transisi:** "Biar lebih kena, saya kasih analogi sederhana."

---

## Slide 14 — Analogy: Owning a Private Generator  ⏱️ ~3 menit
**Tujuan:** bikin pain on-premise terasa.
**Naskah:**
> "On-premise itu seperti kalian harus punya GENSET pribadi untuk dapat listrik. Mahal beli-nya,
> mahal rawatnya. Ukurannya tetap — kalau kekecilan listrik kurang, kalau kebesaran jadi mubazir.
> Dan kalau rusak? Kalian sendiri yang harus benerin tengah malam."
**Tanya:** "Enak nggak hidup begitu?" → biarkan mereka merasakan frustrasinya.
**Transisi:** "Untungnya, sekarang ada cara yang jauh lebih baik."

---

## Slide 15 — The New Way: Cloud (dua kolom)  ⏱️ ~5 menit
**Tujuan:** reveal solusi modern.
**Kolom kiri — apa yang berubah:**
> "Sekarang, kita pakai 'data platform' lewat internet. Tidak perlu beli hardware, tidak perlu rawat
> apa-apa. Butuh sumber daya? Tinggal nyalakan, selesai pakai tinggal matikan."
**Kolom kanan — kenapa lebih baik:**
> "Bayar hanya sesuai pemakaian (OPEX, bukan beli mahal di depan). Elastis — bisa membesar/mengecil
> dalam hitungan detik. Dan tim kecil pun bisa fokus ke DATA, bukan ngurus server."
**Naskah penyemangat:**
> "Inilah kenapa sekarang startup beranggota 2 orang bisa melakukan hal yang dulu hanya bisa dilakukan
> bank besar. Lapangan bermainnya jadi setara."
**Transisi:** "Tapi ada satu ide inti yang membuat semua ini mungkin. Ini yang paling penting."

---

## Slide 16 — The Big Idea: Storage Separates from Compute  ⏱️ ~4 menit
**Tujuan:** tanam konsep paling penting era modern. Ucapkan PELAN.
**Naskah:**
> "Di era cloud, STORAGE (tempat data) dan COMPUTE (mesin pengolah) DIPISAH. Mereka bisa membesar
> sendiri-sendiri. Butuh tenaga hitung lebih banyak? Tambah compute saja, tanpa menyentuh storage.
> Storage banyak tapi jarang dihitung? Bayar storage murah, compute matikan."
**Analogi:**
> "Bayangkan perpustakaan. Buku-bukunya (storage) tetap. Saat ramai, kita cukup menambah meja baca &
> pembaca (compute), bukan membangun gedung baru. Saat sepi, meja dikurangi. Hemat dan fleksibel."
**Poin kunci:** pemisahan storage & compute = keunggulan utama cloud. (Ingatkan ini lawan dari
"terkunci jadi satu" di slide on-premise.)
**Transisi:** "Sekali lagi, dengan analogi yang tadi."

---

## Slide 17 — Analogy: Plugging into the Power Grid  ⏱️ ~2 menit
**Tujuan:** tutup analogi listrik.
**Naskah:**
> "Kalau on-premise itu genset pribadi, maka cloud itu COLOK ke PLN. Listrik tersedia kapan pun
> dibutuhkan, dan kalian cuma bayar sesuai meteran. Tidak perlu punya pembangkit sendiri. Begitulah
> cara kerja data platform modern."
**Transisi:** "Kalian mungkin akan sering dengar beberapa istilah. Yuk kenalan sebentar."

---

## Slide 18 — Modern Terms You'll Hear  ⏱️ ~3 menit
**Tujuan:** kosakata ringan biar tidak kaget di dunia kerja.
**Naskah:**
> "Tiga istilah yang sering muncul. DATA WAREHOUSE — gudang data rapi & terstruktur untuk analitik.
> DATA LAKE — danau data: menampung data mentah jenis apa pun, murah. LAKEHOUSE — gabungan keduanya
> dalam satu platform. Tidak perlu hafal sekarang; cukup supaya nanti tidak asing saat mendengarnya."
👉 **Slide QUIZ 2 muncul setelah Bagian Karier** (Cloud & Careers) — lihat Kunci Jawaban di bawah.
**Transisi:** "Oke, sekarang bagian yang paling kalian tunggu: peluang karier."

---

## Slide 19 — Section: PART 4 — CAREERS IN DATA  ⏱️ ~30 detik
**Naskah:** "Babak keempat — dan ini tentang MASA DEPAN kalian. Mari kita bicara peluang kerja di dunia data."

---

## Slide 20 — A Field Full of Opportunity (stat)  ⏱️ ~3 menit
**Tujuan:** bangun antusiasme (jujur, tidak melebih-lebihkan).
**Naskah:**
> "Profesi data termasuk yang PALING dicari di dunia teknologi. Gajinya menarik bahkan untuk pemula.
> Dan kabar baiknya: HAMPIR SEMUA industri butuh orang data — perbankan, e-commerce, kesehatan,
> logistik, pemerintahan, sampai startup."
- Lokalkan: sebutkan perusahaan Indonesia yang aktif merekrut talenta data (bank besar, e-commerce, dll).
**Tanya:** "Siapa di sini yang tadinya belum kepikiran kerja di bidang data?"
**Transisi:** "Tapi 'orang data' itu bukan satu profesi — ada beberapa peran. Saya pakai analogi tim restoran."

---

## Slide 21 — Analogy: The Data Restaurant Team  ⏱️ ~2 menit
**Tujuan:** perkenalkan analogi pemersatu agar 6 peran mudah diingat.
**Naskah:**
> "Bayangkan menjalankan restoran yang hebat. Tidak mungkin satu orang. Butuh TIM: ada yang masak,
> ada yang urus bahan, ada yang layani tamu, ada yang desain restorannya. Nah, setiap peran di dunia
> data itu seperti satu anggota tim restoran ini. Mari kita kenalan satu per satu."
**Transisi:** "Kita mulai dari tiga peran pertama."

---

## Slide 22 — Meet the Team (1 of 2): Analyst / Scientist / Engineer  ⏱️ ~5 menit
**Tujuan:** jelaskan 3 peran dengan analogi restoran + tugas + tools.
**Naskah:**
> "DATA ANALYST — ibarat orang yang membaca laporan penjualan restoran lalu memberi saran ke manajer:
> 'menu A laris, menu B perlu promo'. Tugasnya membaca data & memberi insight. Tools: SQL & dashboard.
>
> DATA SCIENTIST — si 'peramal' berbasis matematika. Ia memprediksi: 'bulan depan menu apa yang akan
> laku?'. Membangun model machine learning. Tools: Python & statistika.
>
> DATA ENGINEER — yang membangun DAPUR dan jalur pasokan bahan. Tanpa dia, data tidak mengalir.
> Ia menyiapkan data bersih agar siap dipakai. Tools: SQL & pipeline. (Hari ini kalian akan
> merasakan peran ini di lab!)"
**Transisi:** "Tiga peran berikutnya, yang menjaga restoran tetap kokoh & aman."

---

## Slide 23 — Meet the Team (2 of 2): Architect / Governance / DBA  ⏱️ ~5 menit
**Naskah:**
> "DATA ARCHITECT — perancang BLUEPRINT seluruh restoran. Ia menentukan bagaimana data mengalir dari
> awal sampai akhir. Pemikir gambaran besar.
>
> DATA GOVERNANCE — penjaga mutu & aturan. Memastikan 'bahan' aman, halal, sesuai regulasi, dan
> datanya berkualitas. Penjaga KEPERCAYAAN.
>
> DATA ADMINISTRATOR (DBA) — yang memastikan 'gudang/dapur' tetap NYALA: cepat, aman, selalu siap.
> Spesialis operasional."
**Tanya:** "Dari enam peran tadi, mana yang paling kalian banget? Kenapa?"
→ ini membuat mereka mulai membayangkan diri di salah satu peran.
**Transisi:** "Pertanyaannya: kalau mau masuk ke dunia ini, mulai dari mana?"

---

## Slide 24 — How Do I Start? (dua kolom)  ⏱️ ~4 menit
**Tujuan:** beri arah konkret + jembatan ke lab.
**Kolom kiri — basics:**
> "Mulai dari tiga hal: SQL (bahasa data — kita pelajari hari ini), spreadsheet (analisis cepat),
> dan satu alat visualisasi/dashboard."
**Kolom kanan — lalu berkembang:**
> "Setelah itu: latihan pakai dataset nyata, bangun proyek-proyek kecil, isi portofolio. Dan tebak
> apa? Proyek pertama kalian dimulai beberapa menit lagi di sesi lab."
**Poin kunci:** jalur belajar itu jelas & bisa dimulai HARI INI.
**Transisi:** "Ada satu keterampilan yang dipakai SEMUA peran tadi. Mari kita kenalan."

---

## Slide 25 — Section: PART 5 — MEET SQL  ⏱️ ~30 detik
**Naskah:** "Babak terakhir sebelum praktik: kenalan dengan SQL — bahasa untuk 'ngobrol' dengan data."

---

## Slide 26 — SQL: How We Ask Questions to Data  ⏱️ ~3 menit
**Tujuan:** turunkan rasa takut terhadap SQL.
**Naskah:**
> "SQL singkatan dari Structured Query Language. Tenang — ia hampir seperti bahasa Inggris sederhana.
> Yang keren: kalian cukup bilang APA yang kalian mau, bukan BAGAIMANA caranya. Databasenya yang
> mencarikan. SQL ini bahasa 'pemrograman' paling ramah untuk pemula."
**Poin kunci:** SQL = cara bertanya ke data, mudah dipelajari.
**Transisi:** "Biar terasa, saya tunjukkan satu contoh yang bikin 'wow'."

---

## Slide 27 — A Simple 'Wow' Example  ⏱️ ~3 menit
**Tujuan:** bangun rasa penasaran tepat sebelum lab.
**Naskah:**
> "Lihat satu baris ini: SELECT name FROM students WHERE major = 'IT';
> Dibaca seperti bahasa biasa: 'ambil nama dari tabel mahasiswa, yang jurusannya IT'. Sekali jalan,
> dalam sekejap, kalian dapat SEMUA mahasiswa IT — dari ribuan, bahkan jutaan baris."
**Tanya:** "Bayangkan kalau ini data 1 juta baris, dan kalian dapat jawabannya dalam sedetik. Keren, kan?"
**Transisi:** "Dan sebentar lagi, kalian sendiri yang akan menulis query seperti ini."

---

## Slide 28 — Quote / Motivation  ⏱️ ~2 menit
**Tujuan:** puncak emosional sebelum praktik.
**Naskah (ucapkan pelan, beri jeda):**
> "Hari ini, kalian akan menjadi seorang analis, seorang data engineer, dan seorang pembangun
> dashboard — semuanya dalam 2 jam ke depan."
- Biarkan kalimat itu 'mendarat'. Tatap audiens, senyum.
**Transisi:** "Siap? Ayo kita bangun!"

---

## Slide 29 — Thank You / LET'S BUILD!  ⏱️ ~2 menit
**Tujuan:** transisi energik ke sesi lab.
**Naskah:**
> "Saatnya praktik! Sebelum lanjut, pastikan semua sudah berhasil daftar akun trial. Ambil napas,
> regangkan badan sebentar, lalu kita mulai membangun data pipeline dan dashboard pertama kalian."
- Logistik: bagikan link/QR sesi lab; cek kesiapan akun; bentuk kelompok bila perlu.

---

## Tips Fasilitator (Umum)
- **Kuis interaktif** (Kahoot/Mentimeter): sisipkan setelah Slide 11 dan Slide 18. Beri hadiah kecil.
- **Interaksi tiap ~15 menit**: lempar pertanyaan agar tidak ada yang ngantuk.
- **Kalau waktu mepet**, slide yang aman dipangkas: 14, 17, 18 (analogi & kosakata).
- **Tetap netral vendor**: bahas konsep/kategori, hindari menyebut/menjual produk tertentu.
- **Bahasa tubuh**: banyak gerak, kontak mata, dan ANALOGI > definisi.

---

## 🎯 KUNCI JAWABAN QUIZ (untuk pemateri)

Ada 3 slide quiz pilihan ganda, muncul setiap selesai 2 section. Setiap quiz = 2 soal.
Cara pakai: tampilkan slide, beri ~30 detik, minta angkat tangan / jawab di Kahoot, baru ungkap jawaban.

**QUIZ 1 — Databases & OLTP/OLAP** (setelah Part 1 & 2)
- Q1: **B. A super-organized digital filing cabinet** — database = lemari arsip digital rapi.
- Q2: **C. OLTP** — bayar di kasir = transaksi cepat & real-time.

**QUIZ 2 — Cloud & Data Careers** (setelah Part 3 & 4)
- Q1: **B. Storage and compute scale independently** — keunggulan inti cloud.
- Q2: **C. Data Engineer** — yang membangun pipeline agar data mengalir bersih.

**QUIZ 3 — Meet SQL** (setelah Part 5)
- Q1: **B. Ask questions to a database** — SQL = bahasa untuk bertanya ke data.
- Q2: **C. SELECT** — keyword untuk mengambil/membaca data.

> Catatan: jawaban sengaja TIDAK ditulis di slide agar jadi quiz sungguhan. Ungkap lisan setelah audiens menebak.
