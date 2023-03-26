import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RetailDashboardArgumentModel {
  final String imgUrl;
  final String name;
  RetailDashboardArgumentModel({
    required this.imgUrl,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imgUrl': imgUrl,
      'name': name,
    };
  }

  factory RetailDashboardArgumentModel.fromMap(Map<String, dynamic> map) {
    return RetailDashboardArgumentModel(
      imgUrl: map['imgUrl'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RetailDashboardArgumentModel.fromJson(String source) =>
      RetailDashboardArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
