import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RegistrationArgumentModel {
  final bool isInitial;
  RegistrationArgumentModel({
    required this.isInitial,
  });

  RegistrationArgumentModel copyWith({
    bool? isInitial,
  }) {
    return RegistrationArgumentModel(
      isInitial: isInitial ?? this.isInitial,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isInitial': isInitial,
    };
  }

  factory RegistrationArgumentModel.fromMap(Map<String, dynamic> map) {
    return RegistrationArgumentModel(
      isInitial: map['isInitial'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegistrationArgumentModel.fromJson(String source) =>
      RegistrationArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RegistrationArgumentModel(isInitial: $isInitial)';

  @override
  bool operator ==(covariant RegistrationArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isInitial == isInitial;
  }

  @override
  int get hashCode => isInitial.hashCode;
}
