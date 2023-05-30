import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RetailExploreScreen extends StatefulWidget {
  const RetailExploreScreen({Key? key}) : super(key: key);

  @override
  State<RetailExploreScreen> createState() => _RetailExploreScreenState();
}

class _RetailExploreScreenState extends State<RetailExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarAvatar(
          imgUrl: "",
          name: customerName ?? "",
        ),
        title: SvgPicture.asset(ImageConstants.dhabiText),
        actions: const [AppBarAction()],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            const SizeBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: (5 / Dimensions.designWidth).w),
                    width: 100.w,
                    height: (163 / Dimensions.designHeight).h,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.errorSuccessScreen);
                      },
                      child: Image.asset(
                        ImageConstants.banner2,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}