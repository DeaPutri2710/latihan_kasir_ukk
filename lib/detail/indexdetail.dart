import 'package:flutter/material.dart';
import 'package:kasir/home.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPenjualan extends StatefulWidget {
  const DetailPenjualan({super.key});

  @override
  State<DetailPenjualan> createState() => _DetailPenjualanState();
}

class _DetailPenjualanState extends State<DetailPenjualan> {
  List<Map<String, dynamic>> detaill = [];
  bool isLoading = false;
 
  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client.from('detailpenjualan').select();
      setState(() => detaill = List<Map<String, dynamic>>.from(response));
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> transaksi(int PelangganID, int Subtotal) async {
    try {
      await Supabase.instance.client.from('penjualan').insert({
        'PelangganID': PelangganID,
        'TotalHarga': Subtotal,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil disimpan!')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat menyimpan pesanan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.blue,
                size: 40,
              ),
            )
          : detaill.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada detail penjualan.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: detaill.length,
                  itemBuilder: (context, index) {
                    final detail = detaill[index];
                    final int Subtotal = int.tryParse(detail['Subtotal'].toString()) ?? 0;
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          'Produk ID: ${detail['ProdukID'] ?? '-'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Jumlah: ${detail['JumlahProduk'] ?? '-'}'),
                            Text('Subtotal: Rp. ${detail['Subtotal'] ?? '-'}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => transaksi(1, Subtotal),
                          child: const Text('Pesan'),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchDetail,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}