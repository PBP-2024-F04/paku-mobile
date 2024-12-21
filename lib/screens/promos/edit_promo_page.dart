import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paku/colors.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:paku/screens/promos/models/promo.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditPromoPage extends StatefulWidget {
  final Promo promo;

  const EditPromoPage({required this.promo, super.key});

  @override
  State<EditPromoPage> createState() => _EditPromoPageState();
}

class _EditPromoPageState extends State<EditPromoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();

  late String _judulPromo;
  late String _deskripsiPromo;
  DateTime? _tanggalBatas;

  @override
  void initState() {
    super.initState();
    _judulPromo = widget.promo.promoTitle;
    _deskripsiPromo = widget.promo.promoDescription;
    _tanggalBatas = widget.promo.batasPenggunaan;

    if (_tanggalBatas != null) {
      _tanggalController.text = DateFormat('dd-MM-yyyy').format(_tanggalBatas!);
    } else {
      _tanggalController.text = '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = _tanggalBatas ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _tanggalBatas = picked;
        _tanggalController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _clearDate() {
    setState(() {
      _tanggalBatas = null;
      _tanggalController.text = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tanggal batas penggunaan telah dihapus.')),
    );
  }

  Future<void> _submitEditPromo(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final request = context.read<CookieRequest>();

      try {
        // Format the date as 'yyyy-MM-dd' if it's not null
        String? formattedDate = _tanggalBatas != null
            ? DateFormat('yyyy-MM-dd').format(_tanggalBatas!)
            : null;

        // Prepare the data to send
        Map<String, dynamic> data = {
          'promo_title': _judulPromo,
          'promo_description': _deskripsiPromo,
          'batas_penggunaan': formattedDate, // Send as string or null
        };

        // Send the POST request with the correct headers
        final response = await request.postJson(
          'http://localhost:8000/promos/edit_promo_json/${widget.promo.id}/',
          jsonEncode(data),
        );

        if (context.mounted) {
          if (response['success']) {
            // Successfully updated, navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'])),
            );
            Navigator.pop(context);
          } else {
            // Show error from response
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'] ?? 'Gagal mengubah promo')),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error editing promo')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (UI code remains unchanged)
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
                  boxShadow: const [
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tanggalController,
                            decoration: InputDecoration(
                              labelText: "Batas Penggunaan",
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                              hintText: "Masukkan tanggal batas penggunaan",
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(context),
                                  ),
                                  if (_tanggalBatas != null)
                                    IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: _clearDate,
                                      tooltip: 'Hapus Tanggal',
                                    ),
                                ],
                              ),
                            ),
                            readOnly: true, // Make field read-only to use DatePicker
                            validator: (value) {
                              // If date is optional, return null
                              // If required, add validation here
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Button Group
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // "Batal" button
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TailwindColors.yellowDefault,
                          ),
                          child: const Text(
                            "Batal",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _submitEditPromo(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TailwindColors.sageDefault,
                          ),
                          child: const Text(
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
