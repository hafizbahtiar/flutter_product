import 'dart:convert';

class Company {
  final int id;
  final int parentCompanyId;
  final String name;
  final String description;

  Company({
    required this.id,
    required this.parentCompanyId,
    required this.name,
    required this.description,
  });

  Company copyWith({
    int? id,
    int? parentCompanyId,
    String? name,
    String? description,
  }) =>
      Company(
        id: id ?? this.id,
        parentCompanyId: parentCompanyId ?? this.parentCompanyId,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  factory Company.fromRawJson(String str) => Company.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        parentCompanyId: json["parent_company_id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_company_id": parentCompanyId,
        "name": name,
        "description": description,
      };
}
