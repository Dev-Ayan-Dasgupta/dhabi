import 'dart:convert';

import 'package:dialup_mobile_app/data/models/widgets/index.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CountryTileModel {
  final String flagImgUrl;
  final String country;
  final List<dynamic> supportedCurrencies;
  final bool isBank;
  final bool isWallet;
  final String countryShortCode;
  final String currencyCode;
  final String currencyFlag;
  final List<String> currencies;
  final List<DropDownCountriesModel> currencyModels;
  CountryTileModel({
    required this.flagImgUrl,
    required this.country,
    required this.supportedCurrencies,
    required this.isBank,
    required this.isWallet,
    required this.countryShortCode,
    required this.currencyCode,
    required this.currencyFlag,
    required this.currencies,
    required this.currencyModels,
  });
}

class SupportedCurrenciesModel {
  final String currencyCode;
  final String currencyFlag;
  final bool isBank;
  final bool isWallet;
  SupportedCurrenciesModel({
    required this.currencyCode,
    required this.currencyFlag,
    required this.isBank,
    required this.isWallet,
  });

  SupportedCurrenciesModel copyWith({
    String? currencyCode,
    String? currencyFlag,
    bool? isBank,
    bool? isWallet,
  }) {
    return SupportedCurrenciesModel(
      currencyCode: currencyCode ?? this.currencyCode,
      currencyFlag: currencyFlag ?? this.currencyFlag,
      isBank: isBank ?? this.isBank,
      isWallet: isWallet ?? this.isWallet,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currencyCode': currencyCode,
      'currencyFlag': currencyFlag,
      'isBank': isBank,
      'isWallet': isWallet,
    };
  }

  factory SupportedCurrenciesModel.fromMap(Map<String, dynamic> map) {
    return SupportedCurrenciesModel(
      currencyCode: map['currencyCode'] as String,
      currencyFlag: map['currencyFlag'] as String,
      isBank: map['isBank'] as bool,
      isWallet: map['isWallet'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SupportedCurrenciesModel.fromJson(String source) =>
      SupportedCurrenciesModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SupportedCurrenciesModel(currencyCode: $currencyCode, currencyFlag: $currencyFlag, isBank: $isBank, isWallet: $isWallet)';
  }

  @override
  bool operator ==(covariant SupportedCurrenciesModel other) {
    if (identical(this, other)) return true;

    return other.currencyCode == currencyCode &&
        other.currencyFlag == currencyFlag &&
        other.isBank == isBank &&
        other.isWallet == isWallet;
  }

  @override
  int get hashCode {
    return currencyCode.hashCode ^
        currencyFlag.hashCode ^
        isBank.hashCode ^
        isWallet.hashCode;
  }
}
