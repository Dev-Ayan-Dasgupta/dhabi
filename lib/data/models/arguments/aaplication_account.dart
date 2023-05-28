import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApplicationAccountArgumentModel {
  final bool isInitial;
  ApplicationAccountArgumentModel({
    required this.isInitial,
  });

  ApplicationAccountArgumentModel copyWith({
    bool? isInitial,
  }) {
    return ApplicationAccountArgumentModel(
      isInitial: isInitial ?? this.isInitial,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isInitial': isInitial,
    };
  }

  factory ApplicationAccountArgumentModel.fromMap(Map<String, dynamic> map) {
    return ApplicationAccountArgumentModel(
      isInitial: map['isInitial'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicationAccountArgumentModel.fromJson(String source) =>
      ApplicationAccountArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ApplicationAccountArgumentModel(isInitial: $isInitial)';

  @override
  bool operator ==(covariant ApplicationAccountArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isInitial == isInitial;
  }

  @override
  int get hashCode => isInitial.hashCode;
}
