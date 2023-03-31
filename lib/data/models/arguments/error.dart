// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class ErrorArgumentModel {
  final String iconPath;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onTap;
  ErrorArgumentModel({
    required this.iconPath,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onTap,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'iconPath': iconPath,
      'title': title,
      'message': message,
      'buttonText': buttonText,
      'onTap': onTap,
    };
  }

  factory ErrorArgumentModel.fromMap(Map<String, dynamic> map) {
    return ErrorArgumentModel(
      iconPath: map['iconPath'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      buttonText: map['buttonText'] as String,
      onTap: map['onTap'] as VoidCallback,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorArgumentModel.fromJson(String source) =>
      ErrorArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
