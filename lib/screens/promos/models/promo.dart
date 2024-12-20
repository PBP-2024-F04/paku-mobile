import 'package:intl/intl.dart';

class Promo {
  final String id;
  final String promoTitle;
  final String promoDescription;
  final DateTime? batasPenggunaan; // Nullable DateTime

  Promo({
    required this.id,
    required this.promoTitle,
    required this.promoDescription,
    this.batasPenggunaan,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    String? rawDate = json['batas_penggunaan'];
    DateTime? parsedDate;

    if (rawDate != null && rawDate.toString().isNotEmpty) {
      try {
        // Parse the date from 'dd-MM-yyyy' format
        parsedDate = DateFormat('dd-MM-yyyy').parse(rawDate);
      } catch (e) {
        parsedDate = null; // Set to null if parsing fails
      }
    } else {
      parsedDate = null; // Set to null if rawDate is null or empty
    }

    return Promo(
      id: json['id'].toString(),
      promoTitle: json['promo_title'],
      promoDescription: json['promo_description'],
      batasPenggunaan: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promo_title': promoTitle,
      'promo_description': promoDescription,
      'batas_penggunaan': batasPenggunaan != null
          ? DateFormat('dd-MM-yyyy').format(batasPenggunaan!)
          : null, // Handle null appropriately
    };
  }
}
