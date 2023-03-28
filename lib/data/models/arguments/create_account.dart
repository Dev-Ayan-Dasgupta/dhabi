import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CreateAccountArgumentModel {
  final String email;
  final bool isRetail;
  CreateAccountArgumentModel({
    required this.email,
    required this.isRetail,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'isRetail': isRetail,
    };
  }

  factory CreateAccountArgumentModel.fromMap(Map<String, dynamic> map) {
    return CreateAccountArgumentModel(
      email: map['email'] as String,
      isRetail: map['isRetail'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAccountArgumentModel.fromJson(String source) =>
      CreateAccountArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
