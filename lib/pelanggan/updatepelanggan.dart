import 'package:flutter/material.dart';
import 'package:kasir/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdatePelanggan extends StatefulWidget {
  final int PelangganID;

  const UpdatePelanggan({super.key, required this.PelangganID});

  @override
  State<UpdatePelanggan> createState() => _UpdatePelangganState();
}

class _UpdatePelangganState extends State<UpdatePelanggan> {
  final _namaPelangganController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataPelanggan();
  }

  Future<void> _loadDataPelanggan() async {
    try {
      final data = await Supabase.instance.client
          .from('pelanggan')
          .select()
          .eq('PelangganID', widget.PelangganID)
          .single();

      setState(() {
        _namaPelangganController.text = data['NamaPelanggan'] ?? '';
        _alamatController.text = data['Alamat'] ?? '';
        _teleponController.text = data['NomorTelepon'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading pelanggan data: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data pelanggan.')),
      );
    }
  }

  Future<void> _updatePelanggan() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('pelanggan').update({
          'NamaPelanggan': _namaPelangganController.text,
          'Alamat': _alamatController.text,
          'NomorTelepon': _teleponController.text,
        }).eq('PelangganID', widget.PelangganID);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data pelanggan berhasil diperbarui.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        print('Error updating pelanggan: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data pelanggan.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Pelanggan'),
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
                      controller: _namaPelangganController,
                      decoration: InputDecoration(
                        labelText: 'Nama Pelanggan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama pelanggan tidak boleh kosong.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _alamatController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat tidak boleh kosong.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _teleponController,
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor telepon tidak boleh kosong.';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Nomor telepon harus berupa angka.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updatePelanggan,
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
