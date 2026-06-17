#!/usr/bin/env python3
"""
Generate synthetic retail sample data for the "NusantaraMart" hands-on lab.

Outputs 5 CSV files into ./data :
  customers.csv, products.csv, stores.csv, orders.csv, order_items.csv

No third-party dependencies (standard library only) so it runs anywhere.
Usage:
  python3 generate_data.py
  python3 generate_data.py --seed 7 --customers 500 --orders 5000
"""
import argparse
import csv
import os
import random
from datetime import date, timedelta

OUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")

FIRST_NAMES = [
    "Budi", "Siti", "Andi", "Dewi", "Rizki", "Putri", "Agus", "Rina", "Joko", "Maya",
    "Eko", "Sari", "Dian", "Bayu", "Nina", "Hadi", "Wati", "Fajar", "Lestari", "Yusuf",
    "Indah", "Rudi", "Ayu", "Bambang", "Citra", "Doni", "Eka", "Gita", "Hendra", "Intan",
]
LAST_NAMES = [
    "Santoso", "Wijaya", "Pratama", "Nugroho", "Lestari", "Saputra", "Hidayat", "Kurniawan",
    "Permata", "Wibowo", "Halim", "Maulana", "Anggraini", "Susanto", "Hartono", "Putra",
    "Ramadhan", "Setiawan", "Utami", "Firmansyah",
]

# city -> (province, region)
CITIES = {
    "Jakarta": ("DKI Jakarta", "Jabodetabek"),
    "Bogor": ("Jawa Barat", "Jabodetabek"),
    "Depok": ("Jawa Barat", "Jabodetabek"),
    "Tangerang": ("Banten", "Jabodetabek"),
    "Bekasi": ("Jawa Barat", "Jabodetabek"),
    "Bandung": ("Jawa Barat", "Jawa Barat"),
    "Semarang": ("Jawa Tengah", "Jawa Tengah"),
    "Surabaya": ("Jawa Timur", "Jawa Timur"),
    "Malang": ("Jawa Timur", "Jawa Timur"),
    "Yogyakarta": ("DI Yogyakarta", "Jawa Tengah"),
    "Medan": ("Sumatera Utara", "Sumatera"),
    "Palembang": ("Sumatera Selatan", "Sumatera"),
    "Makassar": ("Sulawesi Selatan", "Sulawesi"),
    "Denpasar": ("Bali", "Bali Nusra"),
    "Balikpapan": ("Kalimantan Timur", "Kalimantan"),
}
CITY_LIST = list(CITIES.keys())

SEGMENTS = ["Regular", "Member", "VIP"]
SEGMENT_WEIGHTS = [0.6, 0.3, 0.1]

# category -> list of (product base name, brand, (min_price, max_price))
CATALOG = {
    "Makanan & Minuman": [
        ("Kopi Bubuk 200g", "NusaCoffee"), ("Teh Celup 25s", "TehSegar"),
        ("Air Mineral 1.5L", "AquaNusa"), ("Biskuit Cokelat", "RotiKita"),
        ("Mie Instan Goreng", "MieMantap"), ("Susu UHT 1L", "SapiSehat"),
        ("Minyak Goreng 2L", "DapurEmas"), ("Gula Pasir 1kg", "ManisRaya"),
        ("Beras Premium 5kg", "PadiSubur"), ("Kecap Manis 600ml", "RasaNusantara"),
    ],
    "Perawatan Diri": [
        ("Sabun Mandi", "BersihWangi"), ("Sampo 340ml", "RambutIndah"),
        ("Pasta Gigi", "GigiPutih"), ("Sikat Gigi", "GigiPutih"),
        ("Tisu Wajah", "LembutCare"), ("Deodoran", "FreshDay"),
    ],
    "Rumah Tangga": [
        ("Deterjen Bubuk 1kg", "CuciBersih"), ("Pembersih Lantai", "KilauHome"),
        ("Sabun Cuci Piring", "PiringKinclong"), ("Pengharum Ruangan", "WangiRumah"),
        ("Kantong Sampah", "RapiHome"),
    ],
    "Elektronik": [
        ("Lampu LED 12W", "TerangMax"), ("Powerbank 10000mAh", "ChargeGo"),
        ("Kabel USB-C", "ConnectPro"), ("Earphone", "SoundNusa"),
        ("Baterai AA 4pcs", "VoltPlus"),
    ],
    "Fashion": [
        ("Kaos Polos", "GayaKita"), ("Kaos Kaki 3pcs", "LangkahNyaman"),
        ("Topi Baseball", "GayaKita"), ("Sandal Jepit", "LangkahNyaman"),
    ],
}

STATUS = ["Completed", "Completed", "Completed", "Completed", "Pending", "Cancelled"]
PAYMENTS = ["QRIS", "E-Wallet", "Kartu Debit", "Kartu Kredit", "Tunai"]


def write_csv(name, header, rows):
    path = os.path.join(OUT_DIR, name)
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(header)
        w.writerows(rows)
    print(f"  wrote {len(rows):>6} rows -> {name}")


def rand_date(start, end):
    delta = (end - start).days
    return start + timedelta(days=random.randint(0, delta))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--customers", type=int, default=500)
    ap.add_argument("--stores", type=int, default=15)
    ap.add_argument("--orders", type=int, default=5000)
    args = ap.parse_args()
    random.seed(args.seed)
    os.makedirs(OUT_DIR, exist_ok=True)
    print("Generating NusantaraMart retail data...")

    # ---- customers ----
    customers = []
    for i in range(args.customers):
        cid = 1001 + i
        fn = f"{random.choice(FIRST_NAMES)} {random.choice(LAST_NAMES)}"
        city = random.choice(CITY_LIST)
        prov, _ = CITIES[city]
        seg = random.choices(SEGMENTS, weights=SEGMENT_WEIGHTS)[0]
        email = fn.lower().replace(" ", ".") + f"{cid}@email.com"
        signup = rand_date(date(2023, 1, 1), date(2024, 12, 31))
        customers.append([cid, fn, email, city, prov, seg, signup.isoformat()])
    write_csv("customers.csv",
              ["customer_id", "full_name", "email", "city", "province", "segment", "signup_date"],
              customers)

    # ---- products ----
    products = []
    pid = 5001
    for category, items in CATALOG.items():
        for base, brand in items:
            price = random.choice([5000, 7500, 10000, 12500, 15000, 20000, 25000,
                                   30000, 45000, 55000, 75000, 99000, 125000, 150000])
            products.append([pid, base, category, brand, f"{price:.2f}"])
            pid += 1
    write_csv("products.csv",
              ["product_id", "product_name", "category", "brand", "unit_price"],
              products)
    product_price = {p[0]: float(p[4]) for p in products}
    product_ids = list(product_price.keys())

    # ---- stores ----
    stores = []
    used_cities = CITY_LIST[:]
    random.shuffle(used_cities)
    for i in range(args.stores):
        sid = 10 + i
        city = used_cities[i % len(used_cities)]
        prov, region = CITIES[city]
        channel = random.choices(["Offline", "Online"], weights=[0.7, 0.3])[0]
        sname = f"NusantaraMart {city}" + (" Online" if channel == "Online" else "")
        stores.append([sid, sname, city, prov, region, channel])
    write_csv("stores.csv",
              ["store_id", "store_name", "city", "province", "region", "channel"],
              stores)
    store_ids = [s[0] for s in stores]
    customer_ids = [c[0] for c in customers]

    # ---- orders + order_items ----
    orders = []
    items = []
    item_id = 1
    for i in range(args.orders):
        oid = 900001 + i
        cust = random.choice(customer_ids)
        store = random.choice(store_ids)
        odate = rand_date(date(2025, 1, 1), date(2025, 12, 31))
        status = random.choice(STATUS)
        pay = random.choice(PAYMENTS)
        orders.append([oid, cust, store, odate.isoformat(), status, pay])
        # 1-5 line items per order
        n_items = random.randint(1, 5)
        chosen = random.sample(product_ids, n_items)
        for prod in chosen:
            qty = random.randint(1, 6)
            disc = random.choices([0.0, 0.05, 0.10, 0.15, 0.20],
                                  weights=[0.55, 0.2, 0.15, 0.05, 0.05])[0]
            price = product_price[prod]
            items.append([item_id, oid, prod, qty, f"{price:.2f}", f"{disc:.2f}"])
            item_id += 1
    write_csv("orders.csv",
              ["order_id", "customer_id", "store_id", "order_date", "status", "payment_method"],
              orders)
    write_csv("order_items.csv",
              ["order_item_id", "order_id", "product_id", "quantity", "unit_price", "discount_pct"],
              items)

    print("Done. Files in:", OUT_DIR)


if __name__ == "__main__":
    main()
