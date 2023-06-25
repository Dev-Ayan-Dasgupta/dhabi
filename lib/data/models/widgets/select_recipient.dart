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
  final String benBankCode;
  final String benMobileNo;
  final String benSubBankCode;
  final String benIdType;
  final String benIdNo;
  final String benIdExpiryDate;
  final String benBankName;
  final String benSwiftCode;
  final String benCity;
  final String remittancePurpose;
  final String sourceOfFunds;
  final String relation;

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
    required this.benBankCode,
    required this.benMobileNo,
    required this.benSubBankCode,
    required this.benIdType,
    required this.benIdNo,
    required this.benIdExpiryDate,
    required this.benBankName,
    required this.benSwiftCode,
    required this.benCity,
    required this.remittancePurpose,
    required this.sourceOfFunds,
    required this.relation,
  });
}
