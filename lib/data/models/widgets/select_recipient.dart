// ignore_for_file: public_member_api_docs, sort_constructors_first
class RecipientModel {
  // final bool isWithinDhabi;
  final int beneficiaryId;
  final String flagImgUrl;
  final String name;
  final String address;
  final int accountType;
  final String countryShortCode;
  final int swiftReference;
  final String accountNumber;
  final String currency;

  RecipientModel({
    required this.beneficiaryId,
    required this.flagImgUrl,
    required this.name,
    required this.address,
    required this.accountType,
    required this.countryShortCode,
    required this.swiftReference,
    required this.accountNumber,
    required this.currency,
  });
}
