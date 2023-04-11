// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/search_box.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({Key? key}) : super(key: key);

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<CountryTileModel> countries = [
    CountryTileModel(
      flagImgUrl:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Brazilian_flag_icon_round.svg/512px-Brazilian_flag_icon_round.svg.png",
      country: "Brazil",
      currencies: ["BRL", "USD"],
    ),
    CountryTileModel(
      flagImgUrl:
          "https://media.istockphoto.com/id/690489086/vector/italian-flag.jpg?s=612x612&w=0&k=20&c=kWZWChm94M--bl4uZgmY-tt-OuJQUvt1ujDp0OWSDp8=",
      country: "Italy",
      currencies: ["EUR"],
    ),
    CountryTileModel(
      flagImgUrl:
          "https://www.citypng.com/public/uploads/preview/glossy-round-circular-spain-flag-icon-png-11653937043mmfg0iyrs9.png",
      country: "Spain",
      currencies: ["EUR"],
    ),
    CountryTileModel(
      flagImgUrl:
          "https://img.freepik.com/premium-vector/turkey-flag-round-flat-circle-icons_559729-124.jpg?w=2000",
      country: "Turkey",
      currencies: ["TRY"],
    ),
    CountryTileModel(
      flagImgUrl:
          "https://img.freepik.com/free-vector/round-flag-india_23-2147813736.jpg?w=2000",
      country: "India",
      currencies: ["INR"],
    ),
    CountryTileModel(
      flagImgUrl:
          "https://pixlok.com/wp-content/uploads/2021/02/Pakistan-Flag-Round-Image-Stock-Photos-Vector.jpg",
      country: "Pakistan",
      currencies: ["PKR", "USD"],
    ),
    CountryTileModel(
      flagImgUrl: "https://cdn-icons-png.flaticon.com/512/197/197374.png",
      country: "England",
      currencies: ["GBP", "USD"],
    ),
    CountryTileModel(
      flagImgUrl:
          "https://media.istockphoto.com/id/1179961461/it/vettoriale/illustrazione-vettoriale-icona-bandiera-cina-icona-piatta-rotonda.jpg?s=612x612&w=0&k=20&c=IBGFK_Wp6ZmHFm4Qj2HcBwNn-9qDbYJF8H6vjUOcMAg=",
      country: "China",
      currencies: ["REM"],
    ),
    CountryTileModel(
      flagImgUrl: "https://cdn-icons-png.flaticon.com/512/197/197467.png",
      country: "Palenstine",
      currencies: ["PLS"],
    ),
  ];
  List<CountryTileModel> filteredCountries = [];

  bool isShowAll = true;

  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc countryListBloc = context.read<ShowButtonBloc>();
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
              "Cancel",
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
              Text(
                "Where would you like to send money?",
                style: TextStyles.primaryBold.copyWith(
                  color: AppColors.primary,
                  fontSize: (28 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 20),
              CustomSearchBox(
                hintText: "Search",
                controller: _searchController,
                onChanged: (p0) {
                  searchCountry(countries, p0);
                  if (p0.isEmpty) {
                    isShowAll = true;
                  } else {
                    isShowAll = false;
                  }
                  countryListBloc.add(ShowButtonEvent(show: isShowAll));
                },
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
                            Navigator.pushNamed(
                                context, Routes.recipientReceiveMode);
                          },
                          flagImgUrl: item.flagImgUrl,
                          country: item.country,
                          currencies: item.currencies,
                        );
                      },
                      itemCount: isShowAll
                          ? countries.length
                          : filteredCountries.length,
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
