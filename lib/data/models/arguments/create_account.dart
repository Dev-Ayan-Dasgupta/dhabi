import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CreateAccountArgumentModel {
  final String email;
  CreateAccountArgumentModel({
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
    };
  }

  factory CreateAccountArgumentModel.fromMap(Map<String, dynamic> map) {
    return CreateAccountArgumentModel(
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAccountArgumentModel.fromJson(String source) =>
      CreateAccountArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
