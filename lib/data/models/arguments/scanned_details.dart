import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ScannedDetailsArgumentModel {
  final bool isEID;
  final String? fullName;
  final String? idNumber;
  final String? nationality;
  final String? expiryDate;
  final String? dob;
  final String? gender;
  final String? photo;
  ScannedDetailsArgumentModel({
    required this.isEID,
    required this.fullName,
    required this.idNumber,
    required this.nationality,
    required this.expiryDate,
    required this.dob,
    required this.gender,
    required this.photo,
  });

  ScannedDetailsArgumentModel copyWith({
    bool? isEID,
    String? fullName,
    String? idNumber,
    String? nationality,
    String? expiryDate,
    String? dob,
    String? gender,
    String? photo,
  }) {
    return ScannedDetailsArgumentModel(
      isEID: isEID ?? this.isEID,
      fullName: fullName ?? this.fullName,
      idNumber: idNumber ?? this.idNumber,
      nationality: nationality ?? this.nationality,
      expiryDate: expiryDate ?? this.expiryDate,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isEID': isEID,
      'fullName': fullName,
      'idNumber': idNumber,
      'nationality': nationality,
      'expiryDate': expiryDate,
      'dob': dob,
      'gender': gender,
      'photo': photo,
    };
  }

  factory ScannedDetailsArgumentModel.fromMap(Map<String, dynamic> map) {
    return ScannedDetailsArgumentModel(
      isEID: map['isEID'] as bool,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      idNumber: map['idNumber'] != null ? map['idNumber'] as String : null,
      nationality:
          map['nationality'] != null ? map['nationality'] as String : null,
      expiryDate:
          map['expiryDate'] != null ? map['expiryDate'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScannedDetailsArgumentModel.fromJson(String source) =>
      ScannedDetailsArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScannedDetailsArgumentModel(isEID: $isEID, fullName: $fullName, idNumber: $idNumber, nationality: $nationality, expiryDate: $expiryDate, dob: $dob, gender: $gender, photo: $photo)';
  }

  @override
  bool operator ==(covariant ScannedDetailsArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isEID == isEID &&
        other.fullName == fullName &&
        other.idNumber == idNumber &&
        other.nationality == nationality &&
        other.expiryDate == expiryDate &&
        other.dob == dob &&
        other.gender == gender &&
        other.photo == photo;
  }

  @override
  int get hashCode {
    return isEID.hashCode ^
        fullName.hashCode ^
        idNumber.hashCode ^
        nationality.hashCode ^
        expiryDate.hashCode ^
        dob.hashCode ^
        gender.hashCode ^
        photo.hashCode;
  }
}
