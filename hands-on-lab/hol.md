# Hands-On Lab (2 Jam) — Dari Nol Membangun Data Pipeline & Dashboard Retail

> **Audiens:** mahasiswa baru (pemula, belum tentu pernah coding).
> **Acuan:** [Zero to Snowflake](https://www.snowflake.com/en/developers/guides/zero-to-snowflake/).
> **Cerita besar:** *"Hari ini kamu akan menjadi tim data di perusahaan retail —
> mulai dari menyiapkan data, menganalisis, membangun pipeline, sampai membuat dashboard."*
> **Dokumen ini = BLUEPRINT lab.** Sample data + kode Streamlit akan di-generate **setelah** hol.md disetujui.

---

## 0. Gambaran Alur (Story Arc)

```
Daftar Trial ──> Setup (warehouse/db) ──> Load Data dari S3
      │
      ▼
  [Babak 1: ANALIS PEMULA]  SELECT → Agregasi → JOIN → INSERT/UPDATE/DELETE → Mini-Challenge
      │
      ▼
  [Babak 2: DATA ENGINEER]  Pipeline: COPY INTO → Transform/Filter → Data Mart (Task otomatis)
      │
      ▼
  [Babak 3: DATA ANALYST]   Deploy Dashboard Streamlit → "WOW, aku berhasil!"
```

**Konsistensi penamaan** (dipakai sepanjang lab):
- Database: `RETAIL_DB`
- Schema: `RAW` (data mentah), `ANALYTICS` (hasil olahan / data mart)
- Warehouse: `LAB_WH` (ukuran X-Small)
- Perusahaan fiktif: **"NusantaraMart"** — retail dengan toko online & offline di Indonesia.

---

## 1. Dataset Retail (Spec) — *akan di-generate di langkah berikutnya*

5 tabel, skema bintang sederhana (mudah untuk JOIN & agregasi). Semua data **fiktif, di-generate sendiri**.

### 1.1 `customers` (pelanggan)
| Kolom | Tipe | Contoh |
|-------|------|--------|
| customer_id | INT (PK) | 1001 |
| full_name | STRING | "Budi Santoso" |
| email | STRING | "budi@email.com" |
| city | STRING | "Jakarta" |
| province | STRING | "DKI Jakarta" |
| segment | STRING | "Regular" / "Member" / "VIP" |
| signup_date | DATE | 2024-03-15 |

### 1.2 `products` (produk)
| Kolom | Tipe | Contoh |
|-------|------|--------|
| product_id | INT (PK) | 5001 |
| product_name | STRING | "Kopi Bubuk 200g" |
| category | STRING | "Makanan & Minuman" |
| brand | STRING | "NusaCoffee" |
| unit_price | NUMBER(10,2) | 25000.00 |

### 1.3 `stores` (toko)
| Kolom | Tipe | Contoh |
|-------|------|--------|
| store_id | INT (PK) | 10 |
| store_name | STRING | "NusantaraMart Kemang" |
| city | STRING | "Jakarta" |
| province | STRING | "DKI Jakarta" |
| region | STRING | "Jabodetabek" |
| channel | STRING | "Offline" / "Online" |

### 1.4 `orders` (pesanan / header)
| Kolom | Tipe | Contoh |
|-------|------|--------|
| order_id | INT (PK) | 900001 |
| customer_id | INT (FK) | 1001 |
| store_id | INT (FK) | 10 |
| order_date | DATE | 2025-01-12 |
| status | STRING | "Completed" / "Cancelled" / "Pending" |
| payment_method | STRING | "QRIS" / "Kartu" / "Tunai" / "E-Wallet" |

### 1.5 `order_items` (detail pesanan)
| Kolom | Tipe | Contoh |
|-------|------|--------|
| order_item_id | INT (PK) | 1 |
| order_id | INT (FK) | 900001 |
| product_id | INT (FK) | 5001 |
| quantity | INT | 3 |
| unit_price | NUMBER(10,2) | 25000.00 |
| discount_pct | NUMBER(4,2) | 0.10 |

**Volume target (cukup untuk demo, ringan untuk trial):**
- customers: ~500 | products: ~80 | stores: ~15 | orders: ~5.000 | order_items: ~15.000

**File CSV yang akan dibuat** (di-host di S3 publik / bucket instruktur):
`customers.csv`, `products.csv`, `stores.csv`, `orders.csv`, `order_items.csv`

> Catatan teknis (untuk instruktur): data di-generate via script Python (Faker) → diunggah ke
> bucket S3. Sebagai cadangan kalau S3 tak tersedia, disediakan juga skrip `INSERT`/seed SQL.

---

## 2. MODUL 0 — Setup (20 menit)

### Langkah 0.1 — Daftar Snowflake Trial
1. Buka **https://signup.snowflake.com/**
2. Isi nama, email (pakai email kampus/pribadi), perusahaan (boleh isi "Student").
3. Pilih:
   - **Edition:** *Enterprise* (fitur paling lengkap untuk belajar).
   - **Cloud Provider:** *AWS*.
   - **Region:** pilih terdekat (mis. *Asia Pacific (Jakarta)* atau *Singapore*).
4. Klik **Get Started** → cek email → **aktivasi** → buat **username & password**.
5. Login → masuk ke **Snowsight** (UI web Snowflake). Trial = **$400 kredit gratis / 30 hari**.

> Tips kelas: minta peserta daftar **H-1** agar 20 menit ini tidak habis untuk verifikasi email.

### Langkah 0.2 — Kenalan UI Snowsight (2 menit)
- **Worksheets** = tempat menulis & menjalankan SQL.
- **Databases** = tempat data tersimpan.
- **Warehouses** = "mesin"/compute yang menjalankan query.
- **Streamlit** = tempat membuat aplikasi/dashboard.

### Langkah 0.3 — Buat Warehouse, Database, Schema
> Buka **Worksheets → + Worksheet**, lalu jalankan:

```sql
-- "Mesin" untuk menjalankan query. X-Small = paling kecil & hemat.
CREATE OR REPLACE WAREHOUSE LAB_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60          -- auto mati setelah 60 detik idle (hemat kredit)
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- "Gedung" penyimpanan data
CREATE OR REPLACE DATABASE RETAIL_DB;

-- "Ruangan" di dalam gedung: RAW = data mentah, ANALYTICS = hasil olahan
CREATE OR REPLACE SCHEMA RETAIL_DB.RAW;
CREATE OR REPLACE SCHEMA RETAIL_DB.ANALYTICS;

-- Pakai konteks ini untuk sisa lab
USE WAREHOUSE LAB_WH;
USE DATABASE RETAIL_DB;
USE SCHEMA RAW;
```

**Konsep penting (jelaskan ke peserta):** di cloud, **compute (warehouse) terpisah dari storage
(database)** — persis materi teori! Warehouse bisa dihidup-matikan tanpa memengaruhi data.

---

## 3. MODUL 1 — Data Preparation: Load dari S3 (15 menit)

**Konsep:** Data engineer sering memuat data dari penyimpanan file (seperti **Amazon S3**) ke
dalam database. Caranya: buat **STAGE** (penunjuk lokasi file) → buat **TABLE** → `COPY INTO`.

### Langkah 1.1 — Buat tabel kosong (struktur)
```sql
USE SCHEMA RETAIL_DB.RAW;

CREATE OR REPLACE TABLE customers (
  customer_id INT, full_name STRING, email STRING,
  city STRING, province STRING, segment STRING, signup_date DATE);

CREATE OR REPLACE TABLE products (
  product_id INT, product_name STRING, category STRING,
  brand STRING, unit_price NUMBER(10,2));

CREATE OR REPLACE TABLE stores (
  store_id INT, store_name STRING, city STRING,
  province STRING, region STRING, channel STRING);

CREATE OR REPLACE TABLE orders (
  order_id INT, customer_id INT, store_id INT,
  order_date DATE, status STRING, payment_method STRING);

CREATE OR REPLACE TABLE order_items (
  order_item_id INT, order_id INT, product_id INT,
  quantity INT, unit_price NUMBER(10,2), discount_pct NUMBER(4,2));
```

### Langkah 1.2 — Buat Stage ke S3 + format file
```sql
-- Format file CSV (ada header, dipisah koma)
CREATE OR REPLACE FILE FORMAT csv_ff
  TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1;

-- Stage menunjuk ke bucket S3 publik berisi data lab
-- (URL final diisi setelah data diunggah; placeholder di bawah)
CREATE OR REPLACE STAGE retail_s3_stage
  URL = 's3://<BUCKET-LAB-RETAIL>/data/'
  FILE_FORMAT = csv_ff;

-- Lihat daftar file di stage
LIST @retail_s3_stage;
```

### Langkah 1.3 — `COPY INTO` (memuat data)
```sql
COPY INTO customers   FROM @retail_s3_stage/customers.csv;
COPY INTO products    FROM @retail_s3_stage/products.csv;
COPY INTO stores      FROM @retail_s3_stage/stores.csv;
COPY INTO orders      FROM @retail_s3_stage/orders.csv;
COPY INTO order_items FROM @retail_s3_stage/order_items.csv;

-- Cek jumlah baris ter-load
SELECT 'customers' t, COUNT(*) n FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;
```

> **Alternatif tanpa S3 (cadangan):** gunakan menu **Snowsight → Data → Load Data** (drag & drop CSV),
> atau jalankan skrip seed `INSERT` yang akan disediakan. Konsepnya tetap sama: file → tabel.

---

## 4. MODUL 2 — SELECT (15 menit)
> **Prinsip:** tiap contoh diawali **PERTANYAAN BISNIS**, dijawab dengan query.

**Konsep:** `SELECT` = mengambil data. `WHERE` = menyaring. `ORDER BY` = mengurutkan. `LIMIT` = batasi.

**❓ Pertanyaan 1:** "Siapa saja pelanggan kita?"
```sql
SELECT customer_id, full_name, city, segment FROM customers LIMIT 10;
```

**❓ Pertanyaan 2:** "Produk apa saja yang harganya di atas Rp50.000?"
```sql
SELECT product_name, category, unit_price
FROM products
WHERE unit_price > 50000
ORDER BY unit_price DESC;
```

**❓ Pertanyaan 3:** "Pelanggan VIP dari Jakarta, siapa saja?"
```sql
SELECT full_name, email, segment
FROM customers
WHERE segment = 'VIP' AND city = 'Jakarta';
```

**❓ Pertanyaan 4:** "5 pesanan terbaru di toko kita?"
```sql
SELECT order_id, customer_id, order_date, status
FROM orders
ORDER BY order_date DESC
LIMIT 5;
```

---

## 5. MODUL 3 — Agregasi (15 menit)

**Konsep:** `COUNT/SUM/AVG/MIN/MAX` meringkas banyak baris. `GROUP BY` mengelompokkan.

**❓ Pertanyaan 1:** "Berapa total pelanggan kita?"
```sql
SELECT COUNT(*) AS total_pelanggan FROM customers;
```

**❓ Pertanyaan 2:** "Berapa jumlah pelanggan per segment?"
```sql
SELECT segment, COUNT(*) AS jumlah
FROM customers
GROUP BY segment
ORDER BY jumlah DESC;
```

**❓ Pertanyaan 3:** "Berapa harga rata-rata produk per kategori?"
```sql
SELECT category,
       COUNT(*) AS jumlah_produk,
       ROUND(AVG(unit_price),0) AS harga_rata2
FROM products
GROUP BY category
ORDER BY harga_rata2 DESC;
```

**❓ Pertanyaan 4:** "Berapa jumlah pesanan per status, dan mana yang paling banyak?"
```sql
SELECT status, COUNT(*) AS jumlah_pesanan
FROM orders
GROUP BY status
ORDER BY jumlah_pesanan DESC;
```

---

## 6. MODUL 4 — JOIN (15 menit)

**Konsep:** JOIN menggabungkan tabel yang saling berhubungan (lewat kolom kunci/ID).

**❓ Pertanyaan 1:** "Siapa nama pelanggan untuk tiap pesanan?" (orders + customers)
```sql
SELECT o.order_id, o.order_date, c.full_name, c.city
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 10;
```

**❓ Pertanyaan 2:** "Berapa total nilai (omzet) tiap pesanan?" (orders + order_items)
```sql
SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)) AS total_nilai
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY total_nilai DESC
LIMIT 10;
```

**❓ Pertanyaan 3:** "Kategori produk apa yang paling laku (jumlah terjual)?" (order_items + products)
```sql
SELECT p.category, SUM(oi.quantity) AS total_terjual
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_terjual DESC;
```

**❓ Pertanyaan 4 (3 tabel):** "Omzet per kota toko?" (orders + order_items + stores)
```sql
SELECT s.city,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),0) AS omzet
FROM orders o
JOIN stores s      ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.city
ORDER BY omzet DESC;
```

---

## 7. MODUL 5 — INSERT / UPDATE / DELETE (10 menit)

**Konsep:** mengubah isi data. (Latihan di tabel `customers`.)

**❓ Skenario 1 (INSERT):** "Ada pelanggan baru mendaftar."
```sql
INSERT INTO customers (customer_id, full_name, email, city, province, segment, signup_date)
VALUES (9999, 'Siti Aminah', 'siti@email.com', 'Bandung', 'Jawa Barat', 'Member', CURRENT_DATE());

SELECT * FROM customers WHERE customer_id = 9999;
```

**❓ Skenario 2 (UPDATE):** "Siti naik status jadi VIP."
```sql
UPDATE customers SET segment = 'VIP' WHERE customer_id = 9999;

SELECT customer_id, full_name, segment FROM customers WHERE customer_id = 9999;
```

**❓ Skenario 3 (DELETE):** "Pelanggan minta akunnya dihapus."
```sql
DELETE FROM customers WHERE customer_id = 9999;

SELECT COUNT(*) AS sisa FROM customers WHERE customer_id = 9999;  -- harus 0
```

> ⚠️ **Pesan penting:** `UPDATE`/`DELETE` **tanpa `WHERE`** akan mengubah/menghapus SEMUA baris.
> Selalu cek `WHERE` dulu! (Snowflake punya **Time Travel** untuk memulihkan — bonus cerita).

---

## 8. MODUL 6 — Mini-Challenge (15 menit)
> Peserta kerjakan sendiri/berkelompok. Kunci jawaban dipegang instruktur.

1. **Berapa total omzet seluruh toko (status = 'Completed')?**
2. **Siapa 5 pelanggan dengan total belanja terbesar?** (orders + order_items + customers)
3. **Produk apa yang TIDAK PERNAH terjual?** (hint: `LEFT JOIN` + `IS NULL`)
4. **Bulan apa dengan omzet tertinggi di tahun 2025?** (hint: `MONTH(order_date)`)
5. **Berapa rata-rata nilai pesanan (AOV) per channel toko (Online vs Offline)?**

*(Kunci jawaban akan dibuat di file terpisah `solutions.sql` saat generate kode.)*

---

## 9. MODUL 7 — Jadi DATA ENGINEER: Bangun Pipeline (15 menit)

**Cerita:** *"Sekarang kamu data engineer. Tugasmu membuat alur data otomatis dari data mentah
menjadi data siap pakai (data mart)."*

**Konsep pipeline:** `RAW (data mentah)` → **Transform/Filter** → `ANALYTICS (data mart)`,
lalu **diotomasi** dengan **Task** (penjadwal di Snowflake).

### Langkah 7.1 — Transform & Filter (buat tabel bersih)
```sql
USE SCHEMA RETAIL_DB.ANALYTICS;

-- Ambil hanya pesanan 'Completed' & hitung nilai bersih tiap item
CREATE OR REPLACE TABLE sales_clean AS
SELECT
    o.order_id, o.order_date, o.store_id, o.customer_id,
    oi.product_id, oi.quantity,
    oi.quantity * oi.unit_price * (1 - oi.discount_pct) AS net_amount
FROM RETAIL_DB.RAW.orders o
JOIN RETAIL_DB.RAW.order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed';
```

### Langkah 7.2 — Bangun Data Mart (agregasi siap dashboard)
```sql
-- Data mart 1: penjualan harian
CREATE OR REPLACE TABLE mart_daily_sales AS
SELECT order_date,
       COUNT(DISTINCT order_id) AS jumlah_order,
       SUM(net_amount)          AS omzet
FROM sales_clean
GROUP BY order_date;

-- Data mart 2: penjualan per kategori
CREATE OR REPLACE TABLE mart_category_sales AS
SELECT p.category,
       SUM(s.quantity)   AS unit_terjual,
       SUM(s.net_amount) AS omzet
FROM sales_clean s
JOIN RETAIL_DB.RAW.products p ON s.product_id = p.product_id
GROUP BY p.category;

-- Data mart 3: penjualan per wilayah
CREATE OR REPLACE TABLE mart_region_sales AS
SELECT st.region, st.city,
       SUM(s.net_amount) AS omzet
FROM sales_clean s
JOIN RETAIL_DB.RAW.stores st ON s.store_id = st.store_id
GROUP BY st.region, st.city;
```

### Langkah 7.3 — Otomasi dengan TASK (jadwalkan harian)
```sql
-- Bungkus transformasi jadi prosedur sederhana
CREATE OR REPLACE PROCEDURE refresh_marts()
RETURNS STRING LANGUAGE SQL
AS
$$
BEGIN
  CREATE OR REPLACE TABLE sales_clean AS
    SELECT o.order_id, o.order_date, o.store_id, o.customer_id,
           oi.product_id, oi.quantity,
           oi.quantity * oi.unit_price * (1 - oi.discount_pct) AS net_amount
    FROM RETAIL_DB.RAW.orders o
    JOIN RETAIL_DB.RAW.order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed';

  CREATE OR REPLACE TABLE mart_daily_sales AS
    SELECT order_date, COUNT(DISTINCT order_id) AS jumlah_order, SUM(net_amount) AS omzet
    FROM sales_clean GROUP BY order_date;

  RETURN 'Marts refreshed';
END;
$$;

-- Task: jalankan otomatis tiap hari jam 1 pagi
CREATE OR REPLACE TASK task_refresh_marts
  WAREHOUSE = LAB_WH
  SCHEDULE = 'USING CRON 0 1 * * * Asia/Jakarta'
AS CALL refresh_marts();

-- Task dibuat dalam keadaan SUSPENDED; aktifkan:
ALTER TASK task_refresh_marts RESUME;

-- Coba jalankan manual sekarang (tanpa nunggu jadwal):
EXECUTE TASK task_refresh_marts;
```

**Konsep yang ditanam:** inilah inti pekerjaan **data engineer** — bikin data mentah jadi data
rapi & otomatis. Dashboard nanti tinggal baca dari data mart ini.

---

## 10. MODUL 8 — Jadi DATA ANALYST: Deploy Dashboard Streamlit (15 menit)

**Cerita:** *"Sekarang kamu data analyst. Data mart sudah siap — saatnya bikin dashboard agar
manajemen bisa lihat performa bisnis."*

### Langkah 10.1 — Buat Streamlit App di Snowsight
1. Snowsight → menu **Streamlit** → **+ Streamlit App**.
2. Beri nama: `Retail Dashboard`, pilih **Database** `RETAIL_DB`, **Schema** `ANALYTICS`,
   **Warehouse** `LAB_WH`.
3. **Hapus** kode contoh bawaan → **tempel** kode dari file `streamlit_app.py`
   (akan di-generate di langkah berikutnya).
4. Klik **Run** → dashboard muncul: KPI omzet, grafik penjualan harian, top kategori, peta/region.

### Langkah 10.2 — Isi Dashboard (preview konten)
- **KPI cards:** Total Omzet, Jumlah Order, Rata-rata Nilai Order (AOV).
- **Line chart:** omzet harian (`mart_daily_sales`).
- **Bar chart:** omzet per kategori (`mart_category_sales`).
- **Bar/Map:** omzet per wilayah (`mart_region_sales`).

> Kode `streamlit_app.py` membaca langsung dari data mart via `get_active_session()` — peserta
> **tidak menulis kode dari nol**, cukup *deploy* → efek **"WOW, aku berhasil bikin dashboard!"**

---

## 11. Wrap-Up (5 menit)
- Rekap perjalanan: **Setup → Load → Analisis SQL → Pipeline → Dashboard**.
- "Hari ini kamu sudah mencicipi 3 peran: **analis, data engineer, data analyst**."
- Langkah lanjut: latihan SQL mandiri, ikuti quickstart lain, eksplor trial sampai 30 hari.
- Bersihkan resource (opsional, hemat kredit):
```sql
ALTER TASK task_refresh_marts SUSPEND;
ALTER WAREHOUSE LAB_WH SUSPEND;
-- DROP DATABASE RETAIL_DB;  -- kalau ingin hapus total
```

---

## 12. Daftar Artefak yang Akan Di-generate Berikutnya
> Setelah `hol.md` ini disetujui, kita buat:

| File | Isi |
|------|-----|
| `generate_data.py` | Script Python (Faker) untuk membuat 5 CSV retail |
| `data/*.csv` | Output: customers, products, stores, orders, order_items |
| `setup.sql` | Gabungan DDL Modul 0–1 (warehouse, db, schema, table, stage, COPY INTO) |
| `lab_queries.sql` | Semua query Modul 2–7 berurutan (siap copy-paste) |
| `solutions.sql` | Kunci jawaban Mini-Challenge (Modul 6) |
| `streamlit_app.py` | Kode dashboard Streamlit-in-Snowflake (Modul 8) |
| `seed_insert.sql` | Cadangan load data tanpa S3 (INSERT) |

---

## 13. Catatan Instruktur / Persiapan
- **H-1:** minta peserta sudah **daftar trial & verifikasi email**.
- Siapkan **bucket S3** (atau pakai S3 publik) + unggah 5 CSV → isi URL di `setup.sql`.
- Uji jalankan seluruh `setup.sql` + `lab_queries.sql` di akun trial sendiri sebelum hari-H.
- Region trial: pilih yang dekat (Jakarta/Singapore) agar latensi rendah.
- Sediakan **cadangan** `seed_insert.sql` kalau jaringan/S3 bermasalah.
- **Tetap netral di sesi teori; sesi lab** memang memakai platform Snowflake (boleh, ini praktik).

### Keputusan yang sudah dikunci:
- **Akun:** 1 **trial per mahasiswa** → wajib daftar & verifikasi email **H-1** (Modul 0.1 jadi cepat).
- **Sumber data:** **S3 bucket** (sesuai cerita data engineer). Cadangan `seed_insert.sql` tetap disiapkan.
- **Profil peserta:** campuran/umum, **pemula tanpa background coding** → bahasa sangat sederhana,
  banyak analogi, query siap copy-paste, hindari jargon teknis.

### Masih perlu disiapkan instruktur:
1. **S3 bucket** (atau S3 publik) + unggah 5 CSV → isi URL di `setup.sql`.
2. Region trial yang disarankan ke peserta (Jakarta vs Singapore).
