import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DownloadStatementArgumentModel {
  final String accountNumber;
  DownloadStatementArgumentModel({
    required this.accountNumber,
  });

  DownloadStatementArgumentModel copyWith({
    String? accountNumber,
  }) {
    return DownloadStatementArgumentModel(
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
    };
  }

  factory DownloadStatementArgumentModel.fromMap(Map<String, dynamic> map) {
    return DownloadStatementArgumentModel(
      accountNumber: map['accountNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadStatementArgumentModel.fromJson(String source) =>
      DownloadStatementArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DownloadStatementArgumentModel(accountNumber: $accountNumber)';

  @override
  bool operator ==(covariant DownloadStatementArgumentModel other) {
    if (identical(this, other)) return true;

    return other.accountNumber == accountNumber;
  }

  @override
  int get hashCode => accountNumber.hashCode;
}
