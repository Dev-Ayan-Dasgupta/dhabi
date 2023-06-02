// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OTPArgumentModel {
  // final String code;
  final String emailOrPhone;
  final bool isEmail;
  final bool isBusiness;
  final bool isInitial;
  final bool isLogin;
  final bool isIncompleteOnboarding;
  OTPArgumentModel({
    required this.emailOrPhone,
    required this.isEmail,
    required this.isBusiness,
    required this.isInitial,
    required this.isLogin,
    required this.isIncompleteOnboarding,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'emailOrPhone': emailOrPhone,
      'isEmail': isEmail,
      'isBusiness': isBusiness,
      'isInitial': isInitial,
      'isLogin': isLogin,
      'isIncompleteOnboarding': isIncompleteOnboarding,
    };
  }

  factory OTPArgumentModel.fromMap(Map<String, dynamic> map) {
    return OTPArgumentModel(
      emailOrPhone: map['emailOrPhone'] as String,
      isEmail: map['isEmail'] as bool,
      isBusiness: map['isBusiness'] as bool,
      isInitial: map['isInitial'] as bool,
      isLogin: map['isLogin'] as bool,
      isIncompleteOnboarding: map['isIncompleteOnboarding'] as bool,
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
    bool? isIncompleteOnboarding,
  }) {
    return OTPArgumentModel(
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      isEmail: isEmail ?? this.isEmail,
      isBusiness: isBusiness ?? this.isBusiness,
      isInitial: isInitial ?? this.isInitial,
      isLogin: isLogin ?? this.isLogin,
      isIncompleteOnboarding:
          isIncompleteOnboarding ?? this.isIncompleteOnboarding,
    );
  }

  @override
  String toString() {
    return 'OTPArgumentModel(emailOrPhone: $emailOrPhone, isEmail: $isEmail, isBusiness: $isBusiness, isInitial: $isInitial, isLogin: $isLogin, isIncompleteOnboarding: $isIncompleteOnboarding)';
  }

  @override
  bool operator ==(covariant OTPArgumentModel other) {
    if (identical(this, other)) return true;

    return other.emailOrPhone == emailOrPhone &&
        other.isEmail == isEmail &&
        other.isBusiness == isBusiness &&
        other.isInitial == isInitial &&
        other.isLogin == isLogin &&
        other.isIncompleteOnboarding == isIncompleteOnboarding;
  }

  @override
  int get hashCode {
    return emailOrPhone.hashCode ^
        isEmail.hashCode ^
        isBusiness.hashCode ^
        isInitial.hashCode ^
        isLogin.hashCode ^
        isIncompleteOnboarding.hashCode;
  }
}
