// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/search_box.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SelectRecipientScreen extends StatefulWidget {
  const SelectRecipientScreen({Key? key}) : super(key: key);

  @override
  State<SelectRecipientScreen> createState() => _SelectRecipientScreenState();
}

class _SelectRecipientScreenState extends State<SelectRecipientScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RecipientModel> recipients = [
    RecipientModel(
      isWithinDhabi: true,
      flagImgUrl:
          "https://t4.ftcdn.net/jpg/05/22/35/01/240_F_522350125_mPLuK4cNT6RNN6bvpuKZpLGjqbJr5EiL.jpg",
      name: "Autaz Siddiqui",
      accountNumber: "11015346101",
      currency: "USD",
    ),
    RecipientModel(
      isWithinDhabi: true,
      flagImgUrl:
          "https://t4.ftcdn.net/jpg/05/22/35/01/240_F_522350125_mPLuK4cNT6RNN6bvpuKZpLGjqbJr5EiL.jpg",
      name: "Mohammed Akhram",
      accountNumber: "11015346131",
      currency: "USD",
    ),
    RecipientModel(
      isWithinDhabi: false,
      flagImgUrl:
          "https://t4.ftcdn.net/jpg/05/22/35/01/240_F_522350125_mPLuK4cNT6RNN6bvpuKZpLGjqbJr5EiL.jpg",
      name: "Ayan Dasgupta",
      accountNumber: "11015346101",
      currency: "USD",
    ),
    RecipientModel(
      isWithinDhabi: true,
      flagImgUrl:
          "https://t4.ftcdn.net/jpg/05/22/35/01/240_F_522350125_mPLuK4cNT6RNN6bvpuKZpLGjqbJr5EiL.jpg",
      name: "Samit Ray",
      accountNumber: "11015346101",
      currency: "USD",
    ),
    RecipientModel(
      isWithinDhabi: false,
      flagImgUrl:
          "https://t4.ftcdn.net/jpg/05/22/35/01/240_F_522350125_mPLuK4cNT6RNN6bvpuKZpLGjqbJr5EiL.jpg",
      name: "Subhendu Adhikary",
      accountNumber: "11015346101",
      currency: "USD",
    ),
    RecipientModel(
      isWithinDhabi: true,
      flagImgUrl:
          "https://t4.ftcdn.net/jpg/05/22/35/01/240_F_522350125_mPLuK4cNT6RNN6bvpuKZpLGjqbJr5EiL.jpg",
      name: "Tirtha Ray",
      accountNumber: "11015346101",
      currency: "USD",
    ),
    RecipientModel(
      isWithinDhabi: true,
      flagImgUrl:
          "https://t4.ftcdn.net/jpg/05/22/35/01/240_F_522350125_mPLuK4cNT6RNN6bvpuKZpLGjqbJr5EiL.jpg",
      name: "Walaa Ibrahim",
      accountNumber: "11015346101",
      currency: "USD",
    ),
  ];
  List<RecipientModel> filteredRecipients = [];

  bool isShowAll = true;

  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc recipientListBloc = context.read<ShowButtonBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (22 / Dimensions.designWidth).w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  const SizeBox(height: 10),
              Text(
                "Select Recipient",
                style: TextStyles.primaryBold.copyWith(
                  color: AppColors.primary,
                  fontSize: (28 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 10),
              Text(
                "Select a recipient you sent to previously or enter new reciepient details",
                style: TextStyles.primaryMedium.copyWith(
                  color: const Color.fromRGBO(129, 129, 129, 0.7),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 10),
              CustomSearchBox(
                hintText: "Search",
                controller: _searchController,
                onChanged: (p0) {
                  searchRecipient(recipients, p0);
                  if (p0.isEmpty) {
                    isShowAll = true;
                  } else {
                    isShowAll = false;
                  }
                  recipientListBloc.add(ShowButtonEvent(show: isShowAll));
                },
              ),
              const SizeBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.recipientDetails);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: (22 / Dimensions.designWidth).w,
                    vertical: (18 / Dimensions.designWidth).w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        (10 / Dimensions.designWidth).w,
                      ),
                    ),
                    boxShadow: [BoxShadows.primary],
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstants.addCircle,
                        width: (20 / Dimensions.designWidth).w,
                        height: (20 / Dimensions.designWidth).w,
                      ),
                      const SizeBox(width: 15),
                      Text(
                        "New Recipients",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0XFF252525),
                          fontSize: (16 / Dimensions.designWidth).w,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        ImageConstants.arrowForwardIos,
                        width: (9.81 / Dimensions.designWidth).w,
                        height: (16.67 / Dimensions.designWidth).w,
                      )
                    ],
                  ),
                ),
              ),
              const SizeBox(height: 30),
              Text(
                "MY RECIPIENTS",
                style: TextStyles.primaryBold.copyWith(
                  color: const Color(0XFF818181),
                  fontSize: (12 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 10),
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: (context, state) {
                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        RecipientModel item = isShowAll
                            ? recipients[index]
                            : filteredRecipients[index];
                        return RecipientsTile(
                          isWithinDhabi: item.isWithinDhabi,
                          onTap: () {},
                          flagImgUrl: item.flagImgUrl,
                          name: item.name,
                          accountNumber: item.accountNumber,
                          currency: item.currency,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Color(0XFFDDDDDD),
                          height: 1,
                        );
                      },
                      itemCount: isShowAll
                          ? recipients.length
                          : filteredRecipients.length,
                    ),
                  );
                },
              ),
              const SizeBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void searchRecipient(List<RecipientModel> recipients, String matcher) {
    filteredRecipients.clear();
    for (RecipientModel recipient in recipients) {
      if (recipient.name.toLowerCase().contains(matcher.toLowerCase())) {
        filteredRecipients.add(recipient);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class RecipientModel {
  final bool isWithinDhabi;
  final String flagImgUrl;
  final String name;
  final String accountNumber;
  final String currency;
  RecipientModel({
    required this.isWithinDhabi,
    required this.flagImgUrl,
    required this.name,
    required this.accountNumber,
    required this.currency,
  });
}
