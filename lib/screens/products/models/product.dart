import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    Model model;
    String pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String? user;
    String productName;
    String restaurant;
    int price;
    String description;
    String category;

    Fields({
        required this.user,
        required this.productName,
        required this.restaurant,
        required this.price,
        required this.description,
        required this.category,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        productName: json["product_name"],
        restaurant: json["restaurant"],
        price: json["price"],
        description: json["description"],
        category: json["category"]!,
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "product_name": productName,
        "restaurant": restaurant,
        "price": price,
        "description": description,
        "category": categoryValues.reverse[category],
    };
}

enum Category {
    BEVERAGES,
    CHINESE,
    INDONESIAN,
    JAPANESE,
    NOODLES,
    SEAFOOD,
    SNACKS,
    WESTERN
}

final categoryValues = EnumValues({
    "Beverages": Category.BEVERAGES,
    "Chinese": Category.CHINESE,
    "Indonesian": Category.INDONESIAN,
    "Japanese": Category.JAPANESE,
    "Noodles": Category.NOODLES,
    "Seafood": Category.SEAFOOD,
    "Snacks": Category.SNACKS,
    "Western": Category.WESTERN
});

enum Model {
    PRODUCTS_PRODUCT
}

final modelValues = EnumValues({
    "products.product": Model.PRODUCTS_PRODUCT
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}