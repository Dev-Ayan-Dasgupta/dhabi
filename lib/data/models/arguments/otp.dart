// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OTPArgumentModel {
  // final String code;
  final String emailOrPhone;
  final bool isEmail;
  final bool isBusiness;
  final bool isInitial;
  OTPArgumentModel({
    required this.emailOrPhone,
    required this.isEmail,
    required this.isBusiness,
    required this.isInitial,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'emailOrPhone': emailOrPhone,
      'isEmail': isEmail,
      'isBusiness': isBusiness,
      'isInitial': isInitial,
    };
  }

  factory OTPArgumentModel.fromMap(Map<String, dynamic> map) {
    return OTPArgumentModel(
      emailOrPhone: map['emailOrPhone'] as String,
      isEmail: map['isEmail'] as bool,
      isBusiness: map['isBusiness'] as bool,
      isInitial: map['isInitial'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory OTPArgumentModel.fromJson(String source) =>
      OTPArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  OTPArgumentModel copyWith({
    String? emailOrPhone,
    bool? isEmail,
    bool? isBusiness,
    bool? isInitial,
  }) {
    return OTPArgumentModel(
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      isEmail: isEmail ?? this.isEmail,
      isBusiness: isBusiness ?? this.isBusiness,
      isInitial: isInitial ?? this.isInitial,
    );
  }

  @override
  String toString() {
    return 'OTPArgumentModel(emailOrPhone: $emailOrPhone, isEmail: $isEmail, isBusiness: $isBusiness, isInitial: $isInitial)';
  }

  @override
  bool operator ==(covariant OTPArgumentModel other) {
    if (identical(this, other)) return true;

    return other.emailOrPhone == emailOrPhone &&
        other.isEmail == isEmail &&
        other.isBusiness == isBusiness &&
        other.isInitial == isInitial;
  }

  @override
  int get hashCode {
    return emailOrPhone.hashCode ^
        isEmail.hashCode ^
        isBusiness.hashCode ^
        isInitial.hashCode;
  }
}
