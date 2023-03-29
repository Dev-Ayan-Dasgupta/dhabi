import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VerifyMobileArgumentModel {
  final bool isBusiness;
  VerifyMobileArgumentModel({
    required this.isBusiness,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isBusiness': isBusiness,
    };
  }

  factory VerifyMobileArgumentModel.fromMap(Map<String, dynamic> map) {
    return VerifyMobileArgumentModel(
      isBusiness: map['isBusiness'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyMobileArgumentModel.fromJson(String source) =>
      VerifyMobileArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
