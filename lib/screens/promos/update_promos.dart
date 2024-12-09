import 'package:flutter/material.dart';
import 'package:paku/colors.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePromoPage extends StatefulWidget {
  @override
  _UpdatePromoPageState createState() => _UpdatePromoPageState();
}

class _UpdatePromoPageState extends State<UpdatePromoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _tanggalController = TextEditingController();
  String _judulPromo = '';
  String _deskripsiPromo = '';
  String _tanggalBatas = '';
  late String promoId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the promo ID passed from the previous screen
    final args = ModalRoute.of(context)!.settings.arguments as String;
    promoId = args; // Get promoId from the argument
    _fetchPromoDetails(promoId);  // Fetch the promo details
  }

  // Function to fetch existing promo details from the backend
  Future<void> _fetchPromoDetails(String promoId) async {
    final url = Uri.parse('https://your-backend-api.com/update_promo/$promoId'); // Replace with your API URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _judulPromo = data['judul_promo'];
        _deskripsiPromo = data['deskripsi_promo'];
        _tanggalBatas = data['tanggal_batas'];
        _tanggalController.text = _tanggalBatas;
      });
    } else {
      // Handle error if promo details cannot be fetched
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat data promo')));
    }
  }

  // Function to update the promo
  Future<void> _updatePromo() async {
    final url = Uri.parse('https://your-backend-api.com/update_promo/$promoId'); // Replace with your API URL
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'judul_promo': _judulPromo,
        'deskripsi_promo': _deskripsiPromo,
        'tanggal_batas': _tanggalBatas,
      }),
    );

    if (response.statusCode == 200) {
      // Berhasil mengupdate promo
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(responseData['errors']);
      }
    } else {
      _showErrorDialog('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  // Menampilkan dialog sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Promo Berhasil Diperbarui!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Judul Promo: $_judulPromo"),
              Text("Deskripsi: $_deskripsiPromo"),
              Text("Batas Penggunaan: $_tanggalBatas"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
              },
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog error
  void _showErrorDialog(dynamic errors) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Terjadi Kesalahan!"),
          content: Text(errors.toString()),
          actions: <Widget>[
            TextButton(
              child: Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PaKu")),
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
              "Ubah informasi promo yang ingin diperbarui. Pastikan detailnya sudah benar.",
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
                        hintText: "Masukkan judul promo yang menarik",
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
                        hintText: "Jelaskan lebih lanjut tentang promo ini",
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
                        hintText: "Pilih tanggal batas promo",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Button Group
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // UI: Evenly spaced buttons
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the screen without saving (Cancel action)
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TailwindColors.yellowDefault, // Match the background color for the Cancel button
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            "Batal",  // Label for the Cancel button
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _updatePromo();  // Call the update promo function to save the promo
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TailwindColors.sageDefault, // Match the background color for the Update button
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            "Perbarui Promo",  // Label for the Update button
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

  // DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _tanggalBatas = "${picked.toLocal()}".split(' ')[0];
        _tanggalController.text = _tanggalBatas;
      });
    }
  }
}
