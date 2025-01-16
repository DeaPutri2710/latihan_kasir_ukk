import 'package:flutter/material.dart';
import 'package:kasir/pelanggan/indexpelanggan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _produkList = []; // Daftar produk

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people, color: Colors.black), text: 'Pelanggan'),
              Tab(icon: Icon(Icons.inventory, color: Colors.black), text: 'Produk'),
              Tab(icon: Icon(Icons.shopping_cart, color: Colors.black), text: 'Penjualan'),
            ],
          ),
          backgroundColor: Colors.pink.shade50,
          title: const Text('Informasi Kasir'),
          centerTitle: true,
        ),
        drawer: _buildDrawer(context), // Tambahkan drawer di sini
        body: TabBarView(
          children: [
            PelangganTab(), // Halaman Pelanggan
            _buildProdukTab(context), // Halaman Produk
            const Center(child: Text('Halaman Penjualan')), // Halaman Penjualan
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.pink.shade50),
            child: const SizedBox(),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: const Text('Register'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Menutup drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _showEditProdukModal(context, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduk(index),
                          ),
                        ],
                      ),
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
                decoration: const InputDecoration(
                    labelText: 'Nama Produk', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hargaController,
                decoration: const InputDecoration(
                    labelText: 'Harga', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stokController,
                decoration: const InputDecoration(
                    labelText: 'Stok', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _produkList.add({
                      'nama': namaController.text,
                      'harga': hargaController.text,
                      'stok': stokController.text,
                    });
                  });
                  Navigator.pop(context); // Tutup modal
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditProdukModal(BuildContext context, int index) {
    final produk = _produkList[index];
    final TextEditingController namaController =
        TextEditingController(text: produk['nama']);
    final TextEditingController hargaController =
        TextEditingController(text: produk['harga']);
    final TextEditingController stokController =
        TextEditingController(text: produk['stok']);

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
                'Edit Produk',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                    labelText: 'Nama Produk', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hargaController,
                decoration: const InputDecoration(
                    labelText: 'Harga', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stokController,
                decoration: const InputDecoration(
                    labelText: 'Stok', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _produkList[index] = {
                      'nama': namaController.text,
                      'harga': hargaController.text,
                      'stok': stokController.text,
                    };
                  });
                  Navigator.pop(context); // Tutup modal
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteProduk(int index) {
    setState(() {
      _produkList.removeAt(index);
    });
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: const Center(child: Text('Halaman Profil')),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(child: Text('Halaman Register')),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Halaman Login')),
    );
  }
}
