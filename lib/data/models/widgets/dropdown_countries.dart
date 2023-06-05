import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DropDownCountriesModel {
  final String? countryFlagBase64;
  String? countrynameOrCode;
  DropDownCountriesModel({
    this.countryFlagBase64,
    required this.countrynameOrCode,
  });

  DropDownCountriesModel copyWith({
    String? countryFlagBase64,
    String? countrynameOrCode,
  }) {
    return DropDownCountriesModel(
      countryFlagBase64: countryFlagBase64 ?? this.countryFlagBase64,
      countrynameOrCode: countrynameOrCode ?? this.countrynameOrCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'countryFlagBase64': countryFlagBase64,
      'countrynameOrCode': countrynameOrCode,
    };
  }

  factory DropDownCountriesModel.fromMap(Map<String, dynamic> map) {
    return DropDownCountriesModel(
      countryFlagBase64: map['countryFlagBase64'] != null
          ? map['countryFlagBase64'] as String
          : null,
      countrynameOrCode: map['countrynameOrCode'] != null
          ? map['countrynameOrCode'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DropDownCountriesModel.fromJson(String source) =>
      DropDownCountriesModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DropDownCountriesModel(countryFlagBase64: $countryFlagBase64, countrynameOrCode: $countrynameOrCode)';

  @override
  bool operator ==(covariant DropDownCountriesModel other) {
    if (identical(this, other)) return true;

    return other.countryFlagBase64 == countryFlagBase64 &&
        other.countrynameOrCode == countrynameOrCode;
  }

  @override
  int get hashCode => countryFlagBase64.hashCode ^ countrynameOrCode.hashCode;
}
