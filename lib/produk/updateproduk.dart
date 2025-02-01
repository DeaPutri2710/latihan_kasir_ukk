import 'package:flutter/material.dart';
import 'package:kasir/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateProduk extends StatefulWidget {
  final int ProdukID;

  const UpdateProduk({super.key, required this.ProdukID});

  @override
  State<UpdateProduk> createState() => _UpdateProdukState();
}

class _UpdateProdukState extends State<UpdateProduk> {
  final _namaProdukController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataProduk();
  }

  Future<void> _loadDataProduk() async {
    try {
      final data = await Supabase.instance.client
          .from('produk')
          .select()
          .eq('ProdukID', widget.ProdukID)
          .single();

      setState(() {
        _namaProdukController.text = data['NamaProduk'] ?? '';
        _hargaController.text = data['Harga'].toString();
        _stokController.text = data['Stok'].toString();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading produk data: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data produk.')),
      );
    }
  }

  Future<void> _updateProduk() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('produk').update({
          'NamaProduk': _namaProdukController.text,
          'Harga': int.parse(_hargaController.text),
          'Stok': int.parse(_stokController.text),
        }).eq('ProdukID', widget.ProdukID);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data produk berhasil diperbarui.')),
        );

        Navigator.of(context).pop(true); // Kembali ke halaman sebelumnya dan kirim status perubahan
      } catch (e) {
        print('Error updating produk: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data produk.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Produk'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _namaProdukController,
                      decoration: InputDecoration(
                        labelText: 'Nama Produk',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Produk tidak boleh kosong.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _hargaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Harga harus berupa angka.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _stokController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Stok',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok tidak boleh kosong.';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Stok harus berupa angka.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateProduk,
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}