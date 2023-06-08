// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OTPArgumentModel {
  // final String code;
  final String emailOrPhone;
  final bool isEmail;
  final bool isBusiness;
  final bool isInitial;
  final bool isLogin;
  final bool isEmailIdUpdate;
  final bool isMobileUpdate;
  OTPArgumentModel({
    required this.emailOrPhone,
    required this.isEmail,
    required this.isBusiness,
    required this.isInitial,
    required this.isLogin,
    required this.isEmailIdUpdate,
    required this.isMobileUpdate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'emailOrPhone': emailOrPhone,
      'isEmail': isEmail,
      'isBusiness': isBusiness,
      'isInitial': isInitial,
      'isLogin': isLogin,
      'isEmailIdUpdate': isEmailIdUpdate,
      'isMobileUpdate': isMobileUpdate,
    };
  }

  factory OTPArgumentModel.fromMap(Map<String, dynamic> map) {
    return OTPArgumentModel(
      emailOrPhone: map['emailOrPhone'] as String,
      isEmail: map['isEmail'] as bool,
      isBusiness: map['isBusiness'] as bool,
      isInitial: map['isInitial'] as bool,
      isLogin: map['isLogin'] as bool,
      isEmailIdUpdate: map['isEmailIdUpdate'] as bool,
      isMobileUpdate: map['isMobileUpdate'] as bool,
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
    bool? isLogin,
    bool? isEmailIdUpdate,
    bool? isMobileUpdate,
  }) {
    return OTPArgumentModel(
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      isEmail: isEmail ?? this.isEmail,
      isBusiness: isBusiness ?? this.isBusiness,
      isInitial: isInitial ?? this.isInitial,
      isLogin: isLogin ?? this.isLogin,
      isEmailIdUpdate: isEmailIdUpdate ?? this.isEmailIdUpdate,
      isMobileUpdate: isMobileUpdate ?? this.isMobileUpdate,
    );
  }

  @override
  String toString() {
    return 'OTPArgumentModel(emailOrPhone: $emailOrPhone, isEmail: $isEmail, isBusiness: $isBusiness, isInitial: $isInitial, isLogin: $isLogin, isEmailIdUpdate: $isEmailIdUpdate, isMobileUpdate: $isMobileUpdate)';
  }

  @override
  bool operator ==(covariant OTPArgumentModel other) {
    if (identical(this, other)) return true;

    return other.emailOrPhone == emailOrPhone &&
        other.isEmail == isEmail &&
        other.isBusiness == isBusiness &&
        other.isInitial == isInitial &&
        other.isLogin == isLogin &&
        other.isEmailIdUpdate == isEmailIdUpdate &&
        other.isMobileUpdate == isMobileUpdate;
  }

  @override
  int get hashCode {
    return emailOrPhone.hashCode ^
        isEmail.hashCode ^
        isBusiness.hashCode ^
        isInitial.hashCode ^
        isLogin.hashCode ^
        isEmailIdUpdate.hashCode ^
        isMobileUpdate.hashCode;
  }
}
