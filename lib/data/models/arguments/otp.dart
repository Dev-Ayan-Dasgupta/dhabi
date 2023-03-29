// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OTPArgumentModel {
  final String code;
  final String emailOrPhone;
  final bool isEmail;
  final bool isBusiness;
  OTPArgumentModel({
    required this.code,
    required this.emailOrPhone,
    required this.isEmail,
    required this.isBusiness,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'emailOrPhone': emailOrPhone,
      'isEmail': isEmail,
      'isBusiness': isBusiness,
    };
  }

  factory OTPArgumentModel.fromMap(Map<String, dynamic> map) {
    return OTPArgumentModel(
      code: map['code'] as String,
      emailOrPhone: map['emailOrPhone'] as String,
      isEmail: map['isEmail'] as bool,
      isBusiness: map['isBusiness'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory OTPArgumentModel.fromJson(String source) =>
      OTPArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
