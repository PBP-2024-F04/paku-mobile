import 'package:flutter/material.dart';
import 'package:paku/colors.dart';

class AddPromoPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                      decoration: InputDecoration(
                        labelText: "Judul Promo",
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        hintText: "Masukkan judul promo",
                      ),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Deskripsi promo tidak boleh kosong.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Field 3: Batas Penggunaan
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Batas Penggunaan",
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        hintText: "Masukkan tanggal batas penggunaan (opsional)",
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
                              // Simulasi submit
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Promo berhasil ditambahkan!"),
                                  backgroundColor: TailwindColors.sageDark,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TailwindColors.sageDefault,
                          ),
                          child: Text(
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
