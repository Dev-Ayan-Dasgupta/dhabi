// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class FinalFaceImageScreen extends StatefulWidget {
  const FinalFaceImageScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<FinalFaceImageScreen> createState() => _FinalFaceImageScreenState();
}

class _FinalFaceImageScreenState extends State<FinalFaceImageScreen> {
  XFile? image;

  late FaceImageArgumentModel faceImageArgument;

  @override
  void initState() {
    super.initState();
    faceImageArgument = FaceImageArgumentModel.fromMap(
      widget.argument as dynamic ?? {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            width: 100.w,
            height: 100.h,
            child: Image.file(
              File(faceImageArgument.capturedImage.path),
              fit: BoxFit.fill,
            ),
          ),
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcOut,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin:
                        EdgeInsets.only(top: (50 / Dimensions.designWidth).w),
                    height: (500 / Dimensions.designWidth).w,
                    width: (350 / Dimensions.designWidth).w,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.elliptical((200 / Dimensions.designWidth).w,
                            (300 / Dimensions.designWidth).w),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizeBox(height: 600),
              Text(
                "Move Closer",
                style: TextStyles.primary.copyWith(
                  color: AppColors.black25,
                  fontSize: (24 / Dimensions.designWidth).w,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizeBox(height: 7),
              SizedBox(
                width: (300 / Dimensions.designWidth).w,
                child: Text(
                  "Keep your face positioned in the\ncenter of the screen",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.black63,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
