import 'package:flutter/material.dart';
import 'package:paku/colors.dart';

class ProductEditFormPage extends StatefulWidget {
  final String initialProductName;
  final String initialRestaurant;
  final int initialPrice;
  final String initialDescription;
  final String initialCategory;

  const ProductEditFormPage({
    super.key,
    required this.initialProductName,
    required this.initialRestaurant,
    required this.initialPrice,
    required this.initialDescription,
    required this.initialCategory,
  });

  @override
  State<ProductEditFormPage> createState() => _ProductEditFormPageState();
}

class _ProductEditFormPageState extends State<ProductEditFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late String _restaurant;
  late int _price;
  late String _description;
  late String _category;

  @override
  void initState() {
    super.initState();
    // Initialize the form fields with the initial values
    _productName = widget.initialProductName;
    _restaurant = widget.initialRestaurant;
    _price = widget.initialPrice;
    _description = widget.initialDescription;
    _category = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Your Product",
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
                  label: "Restaurant",
                  hint: "Enter restaurant name",
                  initialValue: _restaurant,
                  onChanged: (value) => _restaurant = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Restaurant name cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                buildTextField(
                  label: "Price",
                  hint: "Enter product price",
                  keyboardType: TextInputType.number,
                  initialValue: _price.toString(),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Product Updated"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Product Name: $_productName"),
                                  Text("Restaurant: $_restaurant"),
                                  Text("Price: $_price"),
                                  Text("Description: $_description"),
                                  Text("Category: $_category"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context, {
                                      'productName': _productName,
                                      'restaurant': _restaurant,
                                      'price': _price,
                                      'description': _description,
                                      'category': _category,
                                    });
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Update",
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
    required String initialValue,
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
      initialValue: initialValue,
    );
  }
}