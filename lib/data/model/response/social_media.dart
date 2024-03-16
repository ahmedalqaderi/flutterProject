// To parse this JSON data, do
//
//     final concat = concatFromJson(jsonString);

import 'dart:convert';

List<Concat> concatFromJson(String str) => List<Concat>.from(json.decode(str).map((x) => Concat.fromJson(x)));

String concatToJson(List<Concat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Concat {
    int? id;
    String? name;
    String? link;
    int? status;
    dynamic createdAt;
    DateTime? updatedAt;

    Concat({
        required this.id,
        required this.name,
        required this.link,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Concat.fromJson(Map<String, dynamic> json) => Concat(
        id: json["id"],
        name: json["name"],
        link: json["link"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "link": link,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
    };
}
