// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/dimensions.dart';

class PageIndicator extends StatefulWidget {
  const PageIndicator({
    Key? key,
    required this.count,
    required this.page,
  }) : super(key: key);

  final int count;
  final int page;

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  final padding = (28 / Dimensions.designWidth);
  final borderRadius = (8 / Dimensions.designWidth);
  final space = (10 / Dimensions.designWidth);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: (6 / Dimensions.designHeight).w,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.count,
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: space.w,
                );
              },
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width:
                          (100.w - (2 * padding.w) - (widget.count * space.w)) /
                              widget.count,
                      height: (6 / Dimensions.designHeight).w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(borderRadius),
                        ),
                        color: const Color.fromRGBO(217, 217, 217, 0.5),
                      ),
                    ),
                    index < widget.page
                        ? Container(
                            width: (100.w -
                                    (2 * padding.w) -
                                    (widget.count * space.w)) /
                                widget.count,
                            height: (6 / Dimensions.designHeight).w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(borderRadius),
                              ),
                              color: const Color.fromRGBO(217, 217, 217, 1),
                            ),
                          )
                        : Container(
                            width: (100.w -
                                    (2 * padding.w) -
                                    (widget.count * space.w)) /
                                widget.count,
                            height: (6 / Dimensions.designHeight).w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(borderRadius),
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
