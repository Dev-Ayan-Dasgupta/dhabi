// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:uuid/uuid.dart';

class CustomCircleAvatarMemory extends StatelessWidget {
  const CustomCircleAvatarMemory({
    Key? key,
    this.width,
    this.height,
    required this.bytes,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: ((109 / 2) / Dimensions.designWidth).w,
      backgroundImage:
          CachedMemoryImageProvider(const Uuid().v4(), bytes: bytes),
      // MemoryImage(bytes),
    );
  }
}
