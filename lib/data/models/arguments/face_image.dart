// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:camera/camera.dart';

class FaceImageArgumentModel {
  final XFile capturedImage;
  FaceImageArgumentModel({
    required this.capturedImage,
  });

  FaceImageArgumentModel copyWith({
    XFile? capturedImage,
  }) {
    return FaceImageArgumentModel(
      capturedImage: capturedImage ?? this.capturedImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'capturedImage': capturedImage,
    };
  }

  factory FaceImageArgumentModel.fromMap(Map<String, dynamic> map) {
    return FaceImageArgumentModel(
      capturedImage: map['capturedImage'] as XFile,
    );
  }

  String toJson() => json.encode(toMap());

  factory FaceImageArgumentModel.fromJson(String source) =>
      FaceImageArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FaceImageArgumentModel(capturedImage: $capturedImage)';

  @override
  bool operator ==(covariant FaceImageArgumentModel other) {
    if (identical(this, other)) return true;

    return other.capturedImage == capturedImage;
  }

  @override
  int get hashCode => capturedImage.hashCode;
}
