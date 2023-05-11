import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SelectAccountArgumentModel {
  final List cifDetails;
  final bool isPwChange;
  SelectAccountArgumentModel({
    required this.cifDetails,
    required this.isPwChange,
  });

  SelectAccountArgumentModel copyWith({
    List? cifDetails,
    bool? isPwChange,
  }) {
    return SelectAccountArgumentModel(
      cifDetails: cifDetails ?? this.cifDetails,
      isPwChange: isPwChange ?? this.isPwChange,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cifDetails': cifDetails,
      'isPwChange': isPwChange,
    };
  }

  factory SelectAccountArgumentModel.fromMap(Map<String, dynamic> map) {
    return SelectAccountArgumentModel(
      cifDetails: List.from((map['cifDetails'] as List)),
      isPwChange: map['isPwChange'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectAccountArgumentModel.fromJson(String source) =>
      SelectAccountArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SelectAccountArgumentModel(cifDetails: $cifDetails, isPwChange: $isPwChange)';

  @override
  bool operator ==(covariant SelectAccountArgumentModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.cifDetails, cifDetails) &&
        other.isPwChange == isPwChange;
  }

  @override
  int get hashCode => cifDetails.hashCode ^ isPwChange.hashCode;
}
