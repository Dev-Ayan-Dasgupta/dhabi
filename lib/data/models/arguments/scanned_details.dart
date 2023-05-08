import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_face_api/face_api.dart' as regula;

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ScannedDetailsArgumentModel {
  final bool isEID;
  final String? fullName;
  final String? idNumber;
  final String? nationality;
  final String? nationalityCode;
  final String? expiryDate;
  final String? dob;
  final String? gender;
  final String? photo;
  final String? docPhoto;
  final Image img1;
  final regula.MatchFacesImage image1;

  ScannedDetailsArgumentModel({
    required this.isEID,
    required this.fullName,
    required this.idNumber,
    required this.nationality,
    required this.nationalityCode,
    required this.expiryDate,
    required this.dob,
    required this.gender,
    required this.photo,
    required this.docPhoto,
    required this.img1,
    required this.image1,
  });

  ScannedDetailsArgumentModel copyWith({
    bool? isEID,
    String? fullName,
    String? idNumber,
    String? nationality,
    String? nationalityCode,
    String? expiryDate,
    String? dob,
    String? gender,
    String? photo,
    String? docPhoto,
    Image? img1,
    regula.MatchFacesImage? image1,
  }) {
    return ScannedDetailsArgumentModel(
      isEID: isEID ?? this.isEID,
      fullName: fullName ?? this.fullName,
      idNumber: idNumber ?? this.idNumber,
      nationality: nationality ?? this.nationality,
      nationalityCode: nationalityCode ?? this.nationalityCode,
      expiryDate: expiryDate ?? this.expiryDate,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
      docPhoto: docPhoto ?? this.docPhoto,
      img1: img1 ?? this.img1,
      image1: image1 ?? this.image1,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isEID': isEID,
      'fullName': fullName,
      'idNumber': idNumber,
      'nationality': nationality,
      'nationalityCode': nationalityCode,
      'expiryDate': expiryDate,
      'dob': dob,
      'gender': gender,
      'photo': photo,
      'docPhoto': docPhoto,
      'img1': img1,
      'image1': image1,
    };
  }

  factory ScannedDetailsArgumentModel.fromMap(Map<String, dynamic> map) {
    return ScannedDetailsArgumentModel(
      isEID: map['isEID'] as bool,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      idNumber: map['idNumber'] != null ? map['idNumber'] as String : null,
      nationality:
          map['nationality'] != null ? map['nationality'] as String : null,
      nationalityCode: map['nationalityCode'] != null
          ? map['nationalityCode'] as String
          : null,
      expiryDate:
          map['expiryDate'] != null ? map['expiryDate'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      docPhoto: map['docPhoto'] != null ? map['docPhoto'] as String : null,
      img1: (map['img1'] as Image),
      image1: (map['image1'] as regula.MatchFacesImage),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScannedDetailsArgumentModel.fromJson(String source) =>
      ScannedDetailsArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScannedDetailsArgumentModel(isEID: $isEID, fullName: $fullName, idNumber: $idNumber, nationality: $nationality, nationalityCode: $nationalityCode, expiryDate: $expiryDate, dob: $dob, gender: $gender, photo: $photo, docPhoto: $docPhoto, img1: $img1, image1: $image1)';
  }

  @override
  bool operator ==(covariant ScannedDetailsArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isEID == isEID &&
        other.fullName == fullName &&
        other.idNumber == idNumber &&
        other.nationality == nationality &&
        other.nationalityCode == nationalityCode &&
        other.expiryDate == expiryDate &&
        other.dob == dob &&
        other.gender == gender &&
        other.photo == photo &&
        other.docPhoto == docPhoto &&
        other.img1 == img1 &&
        other.image1 == image1;
  }

  @override
  int get hashCode {
    return isEID.hashCode ^
        fullName.hashCode ^
        idNumber.hashCode ^
        nationality.hashCode ^
        nationalityCode.hashCode ^
        expiryDate.hashCode ^
        dob.hashCode ^
        gender.hashCode ^
        photo.hashCode ^
        docPhoto.hashCode ^
        img1.hashCode ^
        image1.hashCode;
  }
}