import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginPasswordArgumentModel {
  final String userId;
  LoginPasswordArgumentModel({
    required this.userId,
  });

  LoginPasswordArgumentModel copyWith({
    String? userId,
  }) {
    return LoginPasswordArgumentModel(
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
    };
  }

  factory LoginPasswordArgumentModel.fromMap(Map<String, dynamic> map) {
    return LoginPasswordArgumentModel(
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginPasswordArgumentModel.fromJson(String source) =>
      LoginPasswordArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LoginPasswordArgumentModel(userId: $userId)';

  @override
  bool operator ==(covariant LoginPasswordArgumentModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
