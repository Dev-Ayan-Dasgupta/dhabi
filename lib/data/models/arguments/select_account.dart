import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SelectAccountArgumentModel {
  final String emailId;
  final List cifDetails;
  final bool isPwChange;
  final bool isLogin;
  SelectAccountArgumentModel({
    required this.emailId,
    required this.cifDetails,
    required this.isPwChange,
    required this.isLogin,
  });

  SelectAccountArgumentModel copyWith({
    String? emailId,
    List? cifDetails,
    bool? isPwChange,
    bool? isLogin,
  }) {
    return SelectAccountArgumentModel(
      emailId: emailId ?? this.emailId,
      cifDetails: cifDetails ?? this.cifDetails,
      isPwChange: isPwChange ?? this.isPwChange,
      isLogin: isLogin ?? this.isLogin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'emailId': emailId,
      'cifDetails': cifDetails,
      'isPwChange': isPwChange,
      'isLogin': isLogin,
    };
  }

  factory SelectAccountArgumentModel.fromMap(Map<String, dynamic> map) {
    return SelectAccountArgumentModel(
      emailId: map['emailId'] as String,
      cifDetails: List.from((map['cifDetails'] as List)),
      isPwChange: map['isPwChange'] as bool,
      isLogin: map['isLogin'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectAccountArgumentModel.fromJson(String source) =>
      SelectAccountArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SelectAccountArgumentModel(emailId: $emailId, cifDetails: $cifDetails, isPwChange: $isPwChange, isLogin: $isLogin)';
  }

  @override
  bool operator ==(covariant SelectAccountArgumentModel other) {
    if (identical(this, other)) return true;

    return other.emailId == emailId &&
        listEquals(other.cifDetails, cifDetails) &&
        other.isPwChange == isPwChange &&
        other.isLogin == isLogin;
  }

  @override
  int get hashCode {
    return emailId.hashCode ^
        cifDetails.hashCode ^
        isPwChange.hashCode ^
        isLogin.hashCode;
  }
}
