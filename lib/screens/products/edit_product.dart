import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:paku/screens/products/models/product.dart';
import 'package:provider/provider.dart';
import 'package:paku/colors.dart';
import 'package:paku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class EditProductPage extends StatefulWidget {
  final String productId;
  final Product initialData;

  const EditProductPage({super.key, required this.productId, required this.initialData});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late int _price;
  late String _description;
  late String _category;

  @override
  void initState() {
    super.initState();
    // Initialize fields with data passed from previous page
    _productName = widget.initialData.fields.productName ?? "";
    _price = widget.initialData.fields.price ?? 0;
    _description = widget.initialData.fields.description ?? "";
    _category = widget.initialData.fields.category ?? "";
  }

  void _editProduct(BuildContext context, CookieRequest request) async {
    try {
      final response = await request.post(
        "http://localhost:8000/products/me/${widget.productId}/edit-product-flutter/",
        jsonEncode({
          "productName": _productName,
          "price": _price,
          "description": _description,
          "category": _category,
        }),
      );

      if (context.mounted) {
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produk berhasil diperbarui!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? "Gagal memperbarui produk")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
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
                  "Edit Product",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                buildTextField(
                  label: "Product Name",
                  hint: "Enter product name",
                  initialValue: _productName,
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
                  initialValue: _price.toString(),
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
                  initialValue: _description,
                  maxLines: 4,
                  onChanged: (value) => _description = value,
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
                  initialValue: _category,
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
                        _editProduct(context, request);
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
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
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
