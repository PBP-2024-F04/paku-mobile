import 'package:flutter/material.dart';
import 'package:paku/colors.dart';

class UpdatePromoPage extends StatefulWidget {
  @override
  _UpdatePromoPageState createState() => _UpdatePromoPageState();
}

class _UpdatePromoPageState extends State<UpdatePromoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _tanggalController = TextEditingController();
  String _judulPromo = 'Diskon 50% Hari Ini!';
  String _deskripsiPromo = 'Promo spesial untuk hari ini saja. Jangan lewatkan kesempatan ini.';
  String _tanggalBatas = '2024-12-31';

  @override
  void initState() {
    super.initState();
    // Data sudah diset di sini langsung, tanpa perlu load dari server
    _tanggalController.text = _tanggalBatas;
  }

  // Fungsi untuk memilih tanggal dengan DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _tanggalController.text = "${picked.toLocal()}".split(' ')[0];
        _tanggalBatas = _tanggalController.text;
      });
    }
  }

  // Fungsi untuk menampilkan AlertDialog setelah submit
  void _showSuccessDialog(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PaKu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: TailwindColors.mossGreenDarker,
          ),
        ),
        backgroundColor: TailwindColors.sageDark,
      ),
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Menampilkan dialog sukses dengan detail promo
                              _showSuccessDialog(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TailwindColors.sageDefault,
                          ),
                          child: Text(
                            "Perbarui Promo",
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
