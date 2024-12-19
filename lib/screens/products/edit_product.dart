import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paku/colors.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:paku/screens/products/my_products.dart';

class EditProductPage extends StatefulWidget {
  final dynamic product;

  const EditProductPage({super.key, required this.product});

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
    _productName = widget.product['product_name'];
    _price = widget.product['price'];
    _description = widget.product['description'];
    _category = widget.product['category'];
  }

  void _updateProduct(BuildContext context, CookieRequest request) async {
    final response = await request.postJson(
      "http://localhost:8000/products/me/${widget.product['id']}/edit-product-flutter/",
      jsonEncode({
        "product_name": _productName,
        "price": _price,
        "description": _description,
        "category": _category,
      }),
    );

    print("Response: ${response.body}");
    print("Status Code: ${response.statusCode}");
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Produk berhasil diperbarui.")),
      );
    } else {
      print("Error: ${response['errors'] ?? 'Unknown error'}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update product.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        backgroundColor: TailwindColors.sageDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                  label: "Product Name",
                  initialValue: _productName,
                  onChanged: (value) => _productName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Product name cannot be empty.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildTextField(
                  label: "Price",
                  initialValue: _price.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _price = int.tryParse(value) ?? 0,
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return "Price must be a valid number.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildTextField(
                  label: "Description",
                  initialValue: _description,
                  maxLines: 4,
                  onChanged: (value) => _description = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description cannot be empty.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildTextField(
                  label: "Category",
                  initialValue: _category,
                  onChanged: (value) => _category = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Category cannot be empty.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProduct(context, request);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TailwindColors.sageDark,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      "Save Changes",
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
    required String initialValue,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
