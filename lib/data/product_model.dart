import 'dart:convert';

class Product {
  final int id;
  final int companyId;
  final int categoryId;
  final String name;
  final int price;
  final String description;
  final String barcode;

  Product({
    required this.id,
    required this.companyId,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.description,
    required this.barcode,
  });

  Product copyWith({
    int? id,
    int? companyId,
    int? categoryId,
    String? name,
    int? price,
    String? description,
    String? barcode,
  }) =>
      Product(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        price: price ?? this.price,
        description: description ?? this.description,
        barcode: barcode ?? this.barcode,
      );

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        companyId: json["company_id"],
        categoryId: json["category_id"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        barcode: json["barcode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "category_id": categoryId,
        "name": name,
        "price": price,
        "description": description,
        "barcode": barcode,
      };
}
