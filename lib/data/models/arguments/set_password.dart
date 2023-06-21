import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SetPasswordArgumentModel {
  bool fromTempPassword;
  SetPasswordArgumentModel({
    required this.fromTempPassword,
  });

  SetPasswordArgumentModel copyWith({
    bool? fromTempPassword,
  }) {
    return SetPasswordArgumentModel(
      fromTempPassword: fromTempPassword ?? this.fromTempPassword,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromTempPassword': fromTempPassword,
    };
  }

  factory SetPasswordArgumentModel.fromMap(Map<String, dynamic> map) {
    return SetPasswordArgumentModel(
      fromTempPassword: map['fromTempPassword'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SetPasswordArgumentModel.fromJson(String source) =>
      SetPasswordArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SetPasswordArgumentModel(fromTempPassword: $fromTempPassword)';

  @override
  bool operator ==(covariant SetPasswordArgumentModel other) {
    if (identical(this, other)) return true;

    return other.fromTempPassword == fromTempPassword;
  }

  @override
  int get hashCode => fromTempPassword.hashCode;
}
