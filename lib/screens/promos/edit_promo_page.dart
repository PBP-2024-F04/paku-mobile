// lib/screens/promos/edit_promo_page.dart

import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'dart:convert'; // Untuk json encoding
import 'package:paku/screens/promos/models/promo.dart';

class EditPromoPage extends StatefulWidget {
  final Promo promo;

  EditPromoPage({required this.promo});

  @override
  _EditPromoPageState createState() => _EditPromoPageState();
}

class _EditPromoPageState extends State<EditPromoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _tanggalController = TextEditingController();
  late String _judulPromo;
  late String _deskripsiPromo;
  late String _tanggalBatas;

  @override
  void initState() {
    super.initState();
    _judulPromo = widget.promo.promoTitle;
    _deskripsiPromo = widget.promo.promoDescription;
    _tanggalBatas = widget.promo.batasPenggunaan;
    _tanggalController.text = _tanggalBatas;
  }

  // Fungsi untuk memilih tanggal dengan DatePicker
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    if (_tanggalBatas.isNotEmpty) {
      try {
        initialDate = DateFormat('dd-MM-yyyy').parse(_tanggalBatas);
      } catch (e) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = DateFormat('dd-MM-yyyy').format(picked);
        _tanggalBatas = _tanggalController.text;
      });
    }
  }

  // Fungsi untuk mengirim data promo yang telah diedit ke Django
  Future<void> _submitEditPromo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final request = context.read<CookieRequest>();

      try {
        final response = await request.post(
          'http://localhost:8000/promos/edit_promo_json/${widget.promo.id}/',
          {
            'promo_title': _judulPromo,
            'promo_description': _deskripsiPromo,
            'batas_penggunaan': _tanggalBatas,
          },
        );

        if (response['success']) {
          // Berhasil diupdate, kembali ke halaman sebelumnya
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
          Navigator.pop(context);
        } else {
          // Tampilkan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Gagal mengubah promo')),
          );
        }
      } catch (e) {
        print('Error editing promo: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error editing promo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Promo")),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Edit Promo",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TailwindColors.sageDark,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Silakan edit informasi promo yang ingin Anda ubah.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TailwindColors.mossGreenDarker,
                  ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Field 1: Judul Promo
                    TextFormField(
                      initialValue: _judulPromo,
                      decoration: InputDecoration(
                        labelText: "Judul Promo",
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        hintText: "Masukkan judul promo",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _judulPromo = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Judul promo tidak boleh kosong.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Field 2: Deskripsi Promo
                    TextFormField(
                      initialValue: _deskripsiPromo,
                      decoration: InputDecoration(
                        labelText: "Deskripsi Promo",
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        hintText: "Masukkan deskripsi promo",
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          _deskripsiPromo = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Deskripsi promo tidak boleh kosong.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Field 3: Batas Penggunaan dengan DatePicker
                    TextFormField(
                      controller: _tanggalController,
                      decoration: InputDecoration(
                        labelText: "Batas Penggunaan",
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        hintText: "Masukkan tanggal batas penggunaan",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      readOnly: true, // Membuat field hanya bisa diisi melalui DatePicker
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Batas penggunaan tidak boleh kosong.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Button Group
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Tombol "Batal"
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TailwindColors.yellowDefault,
                          ),
                          child: Text(
                            "Batal",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _submitEditPromo, // Submit ke Django
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TailwindColors.sageDefault,
                          ),
                          child: Text(
                            "Simpan Perubahan",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
