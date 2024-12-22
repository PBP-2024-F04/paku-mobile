import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/settings.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class AddPromoPage extends StatefulWidget {
  const AddPromoPage({super.key});

  @override
  State<AddPromoPage> createState() => _AddPromoPageState();
}

class _AddPromoPageState extends State<AddPromoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();

  String _judulPromo = '';
  String _deskripsiPromo = '';
  DateTime? _tanggalBatas;

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalBatas ?? DateTime.now(),
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

  Future<void> _submitPromo(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final request = context.read<CookieRequest>();

      try {
        // Format the date as 'yyyy-MM-dd' or send null
        String? formattedDate = _tanggalBatas != null
            ? DateFormat('yyyy-MM-dd').format(_tanggalBatas!)
            : null;

        // Prepare the data to send
        Map<String, dynamic> data = {
          'promo_title': _judulPromo,
          'promo_description': _deskripsiPromo,
          'batas_penggunaan': formattedDate, // Send as string or null
        };

        // Send the POST request
        final response = await request.postJson(
          '$apiURL/promos/create_promo_json/',
          jsonEncode(data),
        );

        if (context.mounted) {
          if (response['status'] == 'success') {
            _showSuccessDialog(context);
          } else {
            _showErrorDialogWithMessage(
              context,
              response['message'] ?? 'Gagal menambahkan promo.',
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          _showErrorDialog(context);
        }
      }
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Promo Berhasil Ditambahkan!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Judul Promo: $_judulPromo"),
              Text("Deskripsi: $_deskripsiPromo"),
              if (_tanggalBatas != null)
                Text("Batas Penggunaan: ${DateFormat('dd-MM-yyyy').format(_tanggalBatas!)}"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to the previous page
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialogWithMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Terjadi Kesalahan!"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    _showErrorDialogWithMessage(context, "Tidak dapat menambahkan promo. Silakan coba lagi.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Promo")),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Tambah Promo Baru",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TailwindColors.sageDark,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Silakan isi informasi promo yang ingin Anda tambahkan.",
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

                    // Field 3: Batas Penggunaan with DatePicker
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
                            readOnly: true, // Read-only to ensure DatePicker is used
                            validator: (value) {
                              return null; // Optional validation
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Button Group
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [ ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Cancel button
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
                          onPressed: () => _submitPromo(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TailwindColors.sageDefault,
                          ),
                          child: const Text(
                            "Tambah Promo",
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
