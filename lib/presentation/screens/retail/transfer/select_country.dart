// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/search_box.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<CountryTileModel> countries = [];
  List<CountryTileModel> filteredCountries = [];

  bool isShowAll = true;

  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  void populateCountries() {
    countries.clear();
    for (var country in transferCapabilities) {
      countries.add(
        CountryTileModel(
          flagImgUrl: country["countryFlagBase64"],
          country: country,
          currencies: [],
          isBank: country["isBank"],
          isWallet: country["isWallet"],
          currencyCode: country["currencyCode"],
          countryShortCode: country["countryShortCode"],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: (22 / Dimensions.designWidth).w,
              top: (20 / Dimensions.designWidth).w,
            ),
            child: Text(
              labels[166]["labelText"],
              style: TextStyles.primary.copyWith(
                color: const Color.fromRGBO(65, 65, 65, 0.5),
                fontSize: (16 / Dimensions.designWidth).w,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labels[185]["labelText"],
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            CustomSearchBox(
              hintText: labels[174]["labelText"],
              controller: _searchController,
              onChanged: onSearchChanged,
            ),
            const SizeBox(height: 20),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      CountryTileModel item = isShowAll
                          ? countries[index]
                          : filteredCountries[index];
                      return CountryTile(
                        onTap: () {
                          beneficiaryCountryCode = item.countryShortCode;
                          Navigator.pushNamed(
                            context,
                            Routes.recipientReceiveMode,
                            arguments: SendMoneyArgumentModel(
                              isBetweenAccounts:
                                  sendMoneyArgument.isBetweenAccounts,
                              isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                              isRemittance: sendMoneyArgument.isRemittance,
                            ).toMap(),
                          );
                        },
                        flagImgUrl: item.flagImgUrl,
                        country: item.country,
                        currencies: item.currencies,
                        currencyCode: item.currencyCode,
                      );
                    },
                    itemCount:
                        isShowAll ? countries.length : filteredCountries.length,
                  ),
                );
              },
            ),
            const SizeBox(height: 20),
          ],
        ),
      ),
    );
  }

  void onSearchChanged(String p0) {
    final ShowButtonBloc countryListBloc = context.read<ShowButtonBloc>();
    {
      searchCountry(countries, p0);
      if (p0.isEmpty) {
        isShowAll = true;
      } else {
        isShowAll = false;
      }
      countryListBloc.add(ShowButtonEvent(show: isShowAll));
    }
  }

  void searchCountry(List<CountryTileModel> countries, String matcher) {
    filteredCountries.clear();
    for (CountryTileModel country in countries) {
      if (country.country.toLowerCase().contains(matcher.toLowerCase())) {
        filteredCountries.add(country);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
