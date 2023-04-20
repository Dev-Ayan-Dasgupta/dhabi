import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OnboardingStatusArgumentModel {
  final int stepsCompleted;
  final bool isFatca;
  final bool isPassport;
  OnboardingStatusArgumentModel({
    required this.stepsCompleted,
    required this.isFatca,
    required this.isPassport,
  });

  OnboardingStatusArgumentModel copyWith({
    int? stepsCompleted,
    bool? isFatca,
    bool? isPassport,
  }) {
    return OnboardingStatusArgumentModel(
      stepsCompleted: stepsCompleted ?? this.stepsCompleted,
      isFatca: isFatca ?? this.isFatca,
      isPassport: isPassport ?? this.isPassport,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stepsCompleted': stepsCompleted,
      'isFatca': isFatca,
      'isPassport': isPassport,
    };
  }

  factory OnboardingStatusArgumentModel.fromMap(Map<String, dynamic> map) {
    return OnboardingStatusArgumentModel(
      stepsCompleted: map['stepsCompleted'] as int,
      isFatca: map['isFatca'] as bool,
      isPassport: map['isPassport'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnboardingStatusArgumentModel.fromJson(String source) =>
      OnboardingStatusArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OnboardingStatusArgumentModel(stepsCompleted: $stepsCompleted, isFatca: $isFatca, isPassport: $isPassport)';

  @override
  bool operator ==(covariant OnboardingStatusArgumentModel other) {
    if (identical(this, other)) return true;

    return other.stepsCompleted == stepsCompleted &&
        other.isFatca == isFatca &&
        other.isPassport == isPassport;
  }

  @override
  int get hashCode =>
      stepsCompleted.hashCode ^ isFatca.hashCode ^ isPassport.hashCode;
}
