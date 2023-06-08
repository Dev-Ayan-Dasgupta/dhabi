import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VerifyMobileArgumentModel {
  final bool isBusiness;
  final bool isUpdate;
  VerifyMobileArgumentModel({
    required this.isBusiness,
    required this.isUpdate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isBusiness': isBusiness,
      'isUpdate': isUpdate,
    };
  }

  factory VerifyMobileArgumentModel.fromMap(Map<String, dynamic> map) {
    return VerifyMobileArgumentModel(
      isBusiness: map['isBusiness'] as bool,
      isUpdate: map['isUpdate'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyMobileArgumentModel.fromJson(String source) =>
      VerifyMobileArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  VerifyMobileArgumentModel copyWith({
    bool? isBusiness,
    bool? isUpdate,
  }) {
    return VerifyMobileArgumentModel(
      isBusiness: isBusiness ?? this.isBusiness,
      isUpdate: isUpdate ?? this.isUpdate,
    );
  }

  @override
  String toString() =>
      'VerifyMobileArgumentModel(isBusiness: $isBusiness, isUpdate: $isUpdate)';

  @override
  bool operator ==(covariant VerifyMobileArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isBusiness == isBusiness && other.isUpdate == isUpdate;
  }

  @override
  int get hashCode => isBusiness.hashCode ^ isUpdate.hashCode;
}
