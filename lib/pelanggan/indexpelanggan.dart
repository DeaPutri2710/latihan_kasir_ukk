import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membuat UI.
import 'package:kasir/pelanggan/insertpelanggan.dart'; // Mengimpor file untuk halaman penambahan pelanggan.
import 'package:supabase_flutter/supabase_flutter.dart'; // Mengimpor paket Supabase untuk integrasi backend.
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Mengimpor widget animasi loading.
import 'updatepelanggan.dart'; // Mengimpor file untuk halaman pembaruan pelanggan.

class PelangganTab extends StatefulWidget { // Widget stateful untuk tab pelanggan.
  @override
  _PelangganTabState createState() => _PelangganTabState(); // Membuat state untuk widget ini.
}

class _PelangganTabState extends State<PelangganTab> {
  List<Map<String, dynamic>> pelanggan = []; // List untuk menyimpan data pelanggan.
  bool isLoading = true; // Flag untuk menandai apakah data sedang dimuat.

  @override
  void initState() { // Metode yang dipanggil saat widget pertama kali diinisialisasi.
    super.initState();
    fetchPelanggan(); // Memanggil fungsi untuk mengambil data pelanggan.
  }

  Future<void> fetchPelanggan() async { // Fungsi untuk mengambil data pelanggan dari database Supabase.
    setState(() {
      isLoading = true; // Menandai bahwa data sedang dimuat.
    });
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select(); // Query untuk mengambil data dari tabel 'pelanggan'.
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response); // Mengisi data pelanggan ke dalam list.
        isLoading = false; // Menandai bahwa loading selesai.
      });
    } catch (e) {
      print('Error fetching pelanggan: $e'); // Menangkap dan mencetak error jika terjadi.
      setState(() {
        isLoading = false; // Menghentikan loading jika ada error.
      });
    }
  }

  Future<void> deletePelanggan(int id) async { // Fungsi untuk menghapus pelanggan berdasarkan ID.
    try {
      await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganID', id); // Query untuk menghapus data pelanggan berdasarkan ID.
      fetchPelanggan(); // Memuat ulang data pelanggan setelah penghapusan.
    } catch (e) {
      print('Error deleting pelanggan: $e'); // Menangkap dan mencetak error jika terjadi.
    }
  }

  @override
  Widget build(BuildContext context) { // Fungsi untuk membangun UI.
    return Scaffold(
      body: isLoading // Menampilkan indikator loading jika data sedang dimuat.
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.grey, size: 30), // Widget animasi loading.
            )
          : pelanggan.isEmpty // Menampilkan pesan jika tidak ada data pelanggan.
              ? Center(
                  child: Text(
                    'Tidak ada pelanggan', // Pesan untuk data kosong.
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder( // Menampilkan data pelanggan dalam bentuk grid.
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Jumlah kolom grid.
                    crossAxisSpacing: 12, // Jarak antar kolom.
                  ),
                  padding: EdgeInsets.all(8), // Padding grid.
                  itemCount: pelanggan.length, // Jumlah item yang akan ditampilkan.
                  itemBuilder: (context, index) { // Builder untuk setiap item grid.
                    final langgan = pelanggan[index]; // Mengambil data pelanggan berdasarkan indeks.
                    return Card(
                      elevation: 4, // Memberikan bayangan pada kartu.
                      margin: EdgeInsets.symmetric(vertical: 8), // Margin vertikal untuk setiap kartu.
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)), // Membuat kartu dengan sudut membulat.
                      child: Padding(
                        padding: EdgeInsets.all(12), // Padding di dalam kartu.
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Menyusun widget secara vertikal.
                          children: [
                            Text(
                              langgan['NamaPelanggan'] ?? // Menampilkan nama pelanggan.
                                  'Pelanggan tidak tersedia', // Pesan jika nama pelanggan kosong.
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 4), // Memberikan jarak vertikal kecil.
                            Text(
                              langgan['Alamat'] ?? 'Alamat Tidak tersedia', // Menampilkan alamat pelanggan.
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8), // Memberikan jarak vertikal.
                            Text(
                              langgan['NomorTelepon'] ?? // Menampilkan nomor telepon pelanggan.
                                  'Nomor Telepon Tidak tersedia', // Pesan jika nomor telepon kosong.
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify, // Menyesuaikan teks agar rapi.
                            ),
                            const Divider(), // Garis pembatas.
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end, // Menyusun widget di sisi kanan.
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blueAccent), // Ikon edit.
                                  onPressed: () {
                                    final PelangganID = langgan[
                                            'PelangganID'] ?? 0; // Mengambil ID pelanggan.
                                    if (PelangganID != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                               UpdatePelanggan(PelangganID: PelangganID)) // Navigasi ke halaman update pelanggan.
                                      );
                                    } else {
                                      print('ID pelanggan tidak valid'); // Pesan error jika ID tidak valid.
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent), // Ikon hapus.
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Hapus Pelanggan'), // Judul dialog.
                                          content: const Text(
                                              'Apakah Anda yakin ingin menghapus pelanggan ini?'), // Pesan konfirmasi.
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context), // Menutup dialog.
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deletePelanggan(
                                                    langgan['PelangganID']); // Menghapus pelanggan.
                                                Navigator.pop(context); // Menutup dialog setelah penghapusan.
                                              },
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => insertPage()), // Navigasi ke halaman tambah pelanggan.
          );
        },
        child: Icon(Icons.add), // Ikon tambah pelanggan.
      ),
    );
  }
}
