import 'dart:convert';
import 'package:paku/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:paku/screens/products/my_products.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _productName = "";
  int _price = 0;
  String _description = "";
  String _category = "";

  void _addProduct(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "http://localhost:8000/products/create-product-flutter/",
      jsonEncode({
        "productName": _productName,
        "price": _price,
        "description": _description,
        "category": _category,
      }),
    );

    if (context.mounted) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
          content: Text("Produk baru berhasil disimpan!"),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyProductsPage()),
        );
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Tidak dapat menambahkan produk, silakan coba lagi.')),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaKu'),
        centerTitle: true,
        backgroundColor: TailwindColors.sageDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add New Product",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                buildTextField(
                  label: "Product Name",
                  hint: "Enter product name",
                  onChanged: (value) => _productName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Product name cannot be empty!";
                    }
                    if (value.length > 255) {
                      return "Product name cannot exceed 255 characters!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                buildTextField(
                  label: "Price",
                  hint: "Enter product price",
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _price = int.tryParse(value) ?? 0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Price cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Price must be a valid number!";
                    }
                    if (_price <= 0) {
                      return "Price must be greater than zero!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                buildTextField(
                  label: "Description",
                  hint: "Enter product description",
                  onChanged: (value) => _description = value,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                buildTextField(
                  label: "Category",
                  hint: "Enter product category",
                  onChanged: (value) => _category = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Category cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TailwindColors.sageDefault,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _addProduct(context, request);
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(fontSize: 16),
        hintStyle: const TextStyle(color: TailwindColors.whiteDark),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: TailwindColors.whiteDefault,
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
