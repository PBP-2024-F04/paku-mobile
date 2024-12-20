import 'dart:convert';

class Promo {
  final String id;
  final String promoTitle;
  final String restaurantName;
  final String promoDescription;
  final String batasPenggunaan;

  Promo({
    required this.id,
    required this.promoTitle,
    required this.restaurantName,
    required this.promoDescription,
    required this.batasPenggunaan,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['id'].toString(),
      promoTitle: json['promo_title'],
      restaurantName: json['restaurant_name'],
      promoDescription: json['promo_description'],
      batasPenggunaan: json['batas_penggunaan'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'promo_title': promoTitle,
        'restaurant_name': restaurantName,
        'promo_description': promoDescription,
        'batas_penggunaan': batasPenggunaan,
      };
}

List<Promo> promoFromJson(String str) =>
    List<Promo>.from(json.decode(str).map((x) => Promo.fromJson(x)));
