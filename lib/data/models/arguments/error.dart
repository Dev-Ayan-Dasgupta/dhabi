// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class ErrorArgumentModel {
  final bool hasSecondaryButton;
  final String iconPath;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onTap;
  final String buttonTextSecondary;
  final VoidCallback onTapSecondary;
  ErrorArgumentModel({
    required this.hasSecondaryButton,
    required this.iconPath,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onTap,
    required this.buttonTextSecondary,
    required this.onTapSecondary,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hasSecondaryButton': hasSecondaryButton,
      'iconPath': iconPath,
      'title': title,
      'message': message,
      'buttonText': buttonText,
      'onTap': onTap,
      'buttonTextSecondary': buttonTextSecondary,
      'onTapSecondary': onTapSecondary,
    };
  }

  factory ErrorArgumentModel.fromMap(Map<String, dynamic> map) {
    return ErrorArgumentModel(
      hasSecondaryButton: map['hasSecondaryButton'] as bool,
      iconPath: map['iconPath'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      buttonText: map['buttonText'] as String,
      onTap: (map['onTap'] as VoidCallback),
      buttonTextSecondary: map['buttonTextSecondary'] as String,
      // map['buttonTextSecondary'] != null
      //     ? map['buttonTextSecondary'] as String
      //     : null,
      onTapSecondary: (map['onTapSecondary'] as VoidCallback),
      // map['onTapSecondary'] != null
      //     ? (map['onTapSecondary'] as VoidCallback)
      //     : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorArgumentModel.fromJson(String source) =>
      ErrorArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
