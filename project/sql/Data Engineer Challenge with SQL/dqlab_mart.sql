-- Tampilkan daftar produk yang memiliki harga antara 50.000 and 150.000.
SELECT no_urut, kode_produk, nama_produk, harga
FROM ms_produk
WHERE harga > 50000 AND harga < 150000;

-- Tampilkan semua produk yang mengandung kata Flashdisk.
SELECT no_urut, kode_produk, nama_produk, harga
FROM ms_produk
WHERE nama_produk LIKE '%flashdisk%';

-- Tampilkan hanya nama-nama pelanggan yang hanya memiliki gelar-gelar berikut: S.H, Ir. dan Drs.
SELECT no_urut, kode_pelanggan, nama_pelanggan, alamat
FROM ms_pelanggan
WHERE nama_pelanggan LIKE '%S.H%' OR nama_pelanggan LIKE '%Ir.%' OR nama_pelanggan LIKE '%Drs.%';

-- Tampilkan nama-nama pelanggan dan urutkan hasilnya berdasarkan kolom nama_pelanggan dari yang terkecil ke yang terbesar (A ke Z).
SELECT nama_pelanggan 
FROM ms_pelanggan 
ORDER BY nama_pelanggan;

-- Tampilkan nama-nama pelanggan dan urutkan hasilnya berdasarkan kolom nama_pelanggan dari yang terkecil ke yang terbesar (A ke Z), 
-- namun gelar tidak boleh menjadi bagian dari urutan. Contoh: Ir. Agus Nugraha harus berada di atas Heidi Goh.
SELECT nama_pelanggan
FROM ms_pelanggan
ORDER BY SUBSTRING_INDEX(nama_pelanggan, '. ', -1);

-- Tampilkan nama pelanggan yang memiliki nama paling panjang. 
-- Jika ada lebih dari 1 orang yang memiliki panjang nama yang sama, tampilkan semuanya.
SELECT nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) = (
    SELECT MAX(LENGTH(nama_pelanggan))
	FROM ms_pelanggan);

-- Tampilkan nama orang yang memiliki nama paling panjang (pada row atas), dan nama orang paling pendek (pada row setelahnya). 
-- Gelar menjadi bagian dari nama. Jika ada lebih dari satu nama yang paling panjang atau paling pendek, harus ditampilkan semuanya.
SELECT nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) = (
	SELECT MAX(LENGTH(nama_pelanggan))
	FROM ms_pelanggan)
	OR LENGTH(nama_pelanggan) = (
        SELECT MIN(LENGTH(nama_pelanggan))
	  FROM ms_pelanggan)
ORDER BY LENGTH(nama_pelanggan) DESC;

-- Tampilkan produk yang paling banyak terjual dari segi kuantitas. 
-- Jika ada lebih dari 1 produk dengan nilai yang sama, tampilkan semua produk tersebut.
SELECT t1.kode_produk, t2.nama_produk, SUM(t1.qty) AS total_qty
FROM tr_penjualan_detail AS t1
INNER JOIN ms_produk AS t2
ON t1.kode_produk = t2.kode_produk
GROUP BY t1.kode_produk, t2.nama_produk
ORDER BY total_qty DESC
LIMIT 2;

-- Siapa saja pelanggan yang paling banyak menghabiskan uangnya untuk belanja? 
-- Jika ada lebih dari 1 pelanggan dengan nilai yang sama, tampilkan semua pelanggan tersebut.
SELECT t1.kode_pelanggan, t1.nama_pelanggan, SUM(t2.qty * t2.harga_satuan) AS total_harga
FROM ms_pelanggan t1
INNER JOIN tr_penjualan t3
ON t1.kode_pelanggan = t3.kode_pelanggan 
INNER JOIN tr_penjualan_detail t2
ON t2.kode_transaksi = t3.kode_transaksi
GROUP BY t1.kode_pelanggan, t1.nama_pelanggan
ORDER BY total_harga DESC
LIMIT 1;

-- Tampilkan daftar pelanggan yang belum pernah melakukan transaksi.
SELECT kode_pelanggan, nama_pelanggan, alamat
FROM ms_pelanggan AS t1
WHERE t1.kode_pelanggan NOT IN (
SELECT kode_pelanggan
FROM tr_penjualan);

-- Tampilkan transaksi-transaksi yang memiliki jumlah item produk lebih dari 1 jenis produk. 
-- Dengan lain kalimat, tampilkan transaksi-transaksi yang memiliki jumlah baris data pada table tr_penjualan_detail lebih dari satu.
SELECT 
    t1.kode_transaksi,
    t1.kode_pelanggan,
    t2.nama_pelanggan,
    t1.tanggal_transaksi,
    COUNT(t3.qty) AS jumlah_detail
FROM tr_penjualan t1
INNER JOIN ms_pelanggan t2
ON t1.kode_pelanggan = t2.kode_pelanggan
INNER JOIN tr_penjualan_detail t3
ON t1.kode_transaksi = t3.kode_transaksi
GROUP BY
    t1.kode_transaksi,
    t1.kode_pelanggan,
    t2.nama_pelanggan,
    t1.tanggal_transaksi
HAVING jumlah_detail > 1;