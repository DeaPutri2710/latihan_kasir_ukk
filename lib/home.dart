import 'package:flutter/material.dart';
import 'package:kasir/Penjualan/indexpenjualan.dart';
import 'package:kasir/detail/indexdetail.dart';
import 'package:kasir/main.dart';
import 'package:kasir/pelanggan/indexpelanggan.dart';
import 'package:kasir/produk/indexproduk.dart';
import 'package:kasir/register/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade50,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people, color: Colors.black),text: 'Pelanggan'),
              Tab(icon: Icon(Icons.inventory, color: Colors.black),text: 'Produk'),
              Tab(icon: Icon(Icons.shopping_cart, color: Colors.black),text: 'Penjualan'),
              Tab(icon: Icon(Icons.account_balance_wallet, color: Colors.black),text: 'Detail Penjualan'),
            ],
          ),
        ),
        drawer: _buildDrawer(context), // Tambahkan drawer di sini
        body: TabBarView(
          children: [
            PelangganTab(), // Halaman Pelanggan
            ProdukTab(), // Halaman Produk
            indexpenjualan(), // Halaman Penjualan
            DetailPenjualan() // Halaman Detail Penjualan
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
            leading: const Icon(Icons.app_registration),
            title: const Text('Register'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserRegister()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())); // Menutup drawer
            },
          ),    
        ],
      ),
    );
  }

  Widget _buildProdukTab(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Produk',
        style: TextStyle(fontSize: 16),
      ),
    );
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