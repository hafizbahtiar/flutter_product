import 'dart:convert';

class Category {
  final int id;
  final int parentCategoryId;
  final String title;

  Category({
    required this.id,
    required this.parentCategoryId,
    required this.title,
  });

  Category copyWith({
    int? id,
    int? parentCategoryId,
    String? title,
  }) =>
      Category(
        id: id ?? this.id,
        parentCategoryId: parentCategoryId ?? this.parentCategoryId,
        title: title ?? this.title,
      );

  factory Category.fromRawJson(String str) => Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        parentCategoryId: json["parent_category_id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_category_id": parentCategoryId,
        "title": title,
      };
}
