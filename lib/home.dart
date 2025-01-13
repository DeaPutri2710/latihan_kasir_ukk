import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState(); // Corrected method name
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _produkList = []; // Daftar produk

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.people, color: Colors.black),child: Text('Customer'),),
              Tab(icon: Icon(Icons.inventory, color: Colors.black),child: Text('Produk'),),
              Tab(icon: Icon(Icons.shopping_cart, color: Colors.black),child: Text('Penjualan'),),
            ],
          ),
          backgroundColor: Colors.pink.shade50,
          title: const Text('Informasi Kasir'),
          centerTitle: true,
          leading: IconButton(icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context); // Fungsi untuk kembali ke halaman sebelumnya
            },
          ),
        ),
        body: TabBarView(
          children: [
            const Center(child: Text('Halaman Customer')), // Halaman Customer
            _buildProdukTab(context), // Halaman Produk
            const Center(child: Text('Halaman Penjualan')), // Halaman Penjualan
          ],
        ),
      ),
    );
  }
  Widget _buildProdukTab(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _showTambahProdukModal(context),
            child: const Text('Tambah Produk'),
          ),
        ),
        Expanded(
          child: _produkList.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada produk',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _produkList.length,
                  itemBuilder: (context, index) {
                    final produk = _produkList[index];
                    return ListTile(
                      title: Text(produk['nama'] ?? ''),
                      subtitle: Text('Harga: Rp ${produk['harga']}'),
                      trailing: Text('Stok: ${produk['stok']}'),
                    );
                  },
                ),
        ),
      ],
    );
  }
  void _showTambahProdukModal(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController hargaController = TextEditingController();
    final TextEditingController stokController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tambah Produk',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Produk',border: OutlineInputBorder(),),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hargaController,
                decoration: const InputDecoration(labelText: 'Harga',border: OutlineInputBorder(),),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stokController,
                decoration: const InputDecoration(labelText: 'Stok',border: OutlineInputBorder(),),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Tambahkan produk ke daftar
                  setState(() {
                    _produkList.add({
                      'nama': namaController.text,
                      'harga': hargaController.text,
                      'stok': stokController.text,
                    });
                  });
                  // Tutup modal
                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }
}
