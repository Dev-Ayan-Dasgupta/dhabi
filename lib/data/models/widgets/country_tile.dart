// ignore_for_file: public_member_api_docs, sort_constructors_first
class CountryTileModel {
  final String flagImgUrl;
  final String country;
  final List<String> currencies;
  final bool isBank;
  final bool isWallet;
  final String countryShortCode;
  final String currencyCode;
  CountryTileModel({
    required this.flagImgUrl,
    required this.country,
    required this.currencies,
    required this.isBank,
    required this.isWallet,
    required this.countryShortCode,
    required this.currencyCode,
  });
}
