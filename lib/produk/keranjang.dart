import 'package:flutter/material.dart';

class ProdukDetail extends StatefulWidget {
  final Map<String, dynamic> produk;
  const ProdukDetail({Key? key, required this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  int jumlahPesanan = 0;

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final harga = produk['Harga'] ?? 0;
    final totalHarga = jumlahPesanan * harga;

    void updatePesanan(int delta) {
      setState(() => jumlahPesanan = (jumlahPesanan + delta).clamp(0, 999));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(produk['NamaProduk'] ?? 'Detail Produk'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(produk['NamaProduk'] ?? 'Tidak Tersedia',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      SizedBox(height: 8),
                      Text('Harga: Rp$harga',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Stok: ${produk['Stok'] ?? 'Tidak Tersedia'}',
                          style: TextStyle(fontSize: 16, color: Colors.black54)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () => updatePesanan(-1),
                      icon: Icon(Icons.remove_circle, color: Colors.red, size: 40)),
                  Text('$jumlahPesanan',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  IconButton(
                      onPressed: () => updatePesanan(1),
                      icon: Icon(Icons.add_circle, color: Colors.green, size: 40)),
                ],
              ),
              Spacer(),
              Text('Total Harga: Rp$totalHarga',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text('Tutup',
                        style: TextStyle(fontSize: 18, color: Colors.black87)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Konfirmasi Pesanan'),
                          content: Text('Total harga pesanan: Rp$totalHarga'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Pesanan berhasil dibuat!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              child: Text('Pesan'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text('Pesan',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}