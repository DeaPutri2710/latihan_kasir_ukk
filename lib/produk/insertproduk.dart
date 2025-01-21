import 'package:flutter/material.dart';
import 'package:kasir/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Insertproduk extends StatefulWidget {
  const Insertproduk({super.key});

  @override
  State<Insertproduk> createState() => _InsertprodukState();
}

class _InsertprodukState extends State<Insertproduk> {
  final _nmprdk = TeksEditingController();
  final _hrg = TeksEditingController();
  final _stk = TeksEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> produk() async {
    if (_formKey.currentState!.validate()) {
      final String NamaProduk = _nmprdk.text;
      final String Harga = _hrg.text;
      final String Stok = _stk.text;

      final response = await Supabase.instance.client.from('produk').insert({
        'Nama Produk': NamaProduk,
        'Harga': Harga,
        'Stok': Stok,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nmprdk,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hrg,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stk,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: produk,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
