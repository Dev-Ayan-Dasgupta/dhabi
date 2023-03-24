// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OTPArgumentModel {
  final String code;
  final String email;
  OTPArgumentModel({
    required this.code,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'email': email,
    };
  }

  factory OTPArgumentModel.fromMap(Map<String, dynamic> map) {
    return OTPArgumentModel(
      code: map['code'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OTPArgumentModel.fromJson(String source) =>
      OTPArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
