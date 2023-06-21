import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FdSeedAccount {
  final String accountNumber;
  final double fdCreationThreshold;
  final String currency;
  final double bal;
  final int accountType;
  FdSeedAccount({
    required this.accountNumber,
    required this.fdCreationThreshold,
    required this.currency,
    required this.bal,
    required this.accountType,
  });

  FdSeedAccount copyWith({
    String? accountNumber,
    double? fdCreationThreshold,
    String? currency,
    double? bal,
    int? accountType,
  }) {
    return FdSeedAccount(
      accountNumber: accountNumber ?? this.accountNumber,
      fdCreationThreshold: fdCreationThreshold ?? this.fdCreationThreshold,
      currency: currency ?? this.currency,
      bal: bal ?? this.bal,
      accountType: accountType ?? this.accountType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
      'fdCreationThreshold': fdCreationThreshold,
      'currency': currency,
      'bal': bal,
      'accountType': accountType,
    };
  }

  factory FdSeedAccount.fromMap(Map<String, dynamic> map) {
    return FdSeedAccount(
      accountNumber: map['accountNumber'] as String,
      fdCreationThreshold: map['fdCreationThreshold'] as double,
      currency: map['currency'] as String,
      bal: map['bal'] as double,
      accountType: map['accountType'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory FdSeedAccount.fromJson(String source) =>
      FdSeedAccount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FdSeedAccount(accountNumber: $accountNumber, fdCreationThreshold: $fdCreationThreshold, currency: $currency, bal: $bal, accountType: $accountType)';
  }

  @override
  bool operator ==(covariant FdSeedAccount other) {
    if (identical(this, other)) return true;

    return other.accountNumber == accountNumber &&
        other.fdCreationThreshold == fdCreationThreshold &&
        other.currency == currency &&
        other.bal == bal &&
        other.accountType == accountType;
  }

  @override
  int get hashCode {
    return accountNumber.hashCode ^
        fdCreationThreshold.hashCode ^
        currency.hashCode ^
        bal.hashCode ^
        accountType.hashCode;
  }
}
