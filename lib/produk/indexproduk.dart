import 'package:flutter/material.dart';
import 'package:kasir/produk/insertproduk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Map<String, dynamic>> produk = [];
  bool isLoading = true;

  @override
  void initState() { // Perbaikan typo "iniState"
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching produk: $e');
      setState(() {
        isLoading = false; // Pastikan loading dihentikan meskipun error
      });
      // Bisa juga tambahkan snackbar untuk memberi tahu pengguna
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data produk!')),
      );
    }
  }

  Future<void> deleteProduk(int id) async {
    try {
      await Supabase.instance.client.from('produk').delete().eq('ProdukId', id);
      fetchProduk(); // Refresh data setelah penghapusan
    } catch (e) {
      print('Error deleting produk: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.grey, size: 30),
            )
          : produk.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12, // Tambahkan jarak antar item
                  ),
                  padding: EdgeInsets.all(8),
                  itemCount: produk.length,
                  itemBuilder: (context, index) {
                    final produkItem = produk[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              produkItem['NamaProduk'] ?? 'Produk tidak tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              produkItem['Harga'] != null
                                  ? 'Rp ${produkItem['Harga']}'
                                  : 'Harga tidak tersedia',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              produkItem['Stok'] != null
                                  ? 'Stok: ${produkItem['Stok']}'
                                  : 'Stok tidak tersedia',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blueAccent),
                                  onPressed: () {
                                    final produkId =
                                        produkItem['ProdukId'] ?? 0;
                                    if (produkId != 0) {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => EditProduk(
                                      //         produkId: produkId),
                                      //   ),
                                      // );
                                    } else {
                                      print('ID produk tidak valid');
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    final produkId =
                                        produkItem['ProdukId'] ?? 0;
                                    if (produkId != 0) {
                                      deleteProduk(produkId);
                                    }
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
