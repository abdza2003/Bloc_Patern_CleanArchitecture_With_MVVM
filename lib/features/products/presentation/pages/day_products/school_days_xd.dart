import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:school_cafteria/appBar.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/features/products/presentation/pages/booked_products/booked_day_products.dart';
import 'package:school_cafteria/scrollviewAppbar.dart';
import 'package:school_cafteria/test/app_bar_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:school_cafteria/features/balance/presentation/bloc/balance_bloc.dart'
    as bb;
import '../../../../../core/navigation.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/products_bloc.dart';
import 'day_products.dart';

class SchoolDays2 extends StatefulWidget {
  SchoolDays2(
      {Key? key,
      required this.accessToken,
      required this.currency,
      required this.childName,
      required this.childId})
      : super(key: key);

  final String accessToken;
  final String currency;
  final String childName;
  final int childId;

  @override
  State<SchoolDays2> createState() => _SchoolDays2State();
}

class _SchoolDays2State extends State<SchoolDays2> {
  final weeklyBalance = TextEditingController();

  final formKey1 = GlobalKey<FormState>();

  final _scrollController = ScrollController();
  double maxScroll = 0;
  double currentScroll = 0;

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    maxScroll = _scrollController.position.maxScrollExtent;
    currentScroll = _scrollController.offset;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<bb.BalanceBloc, bb.BalanceState>(
        listener: (context, state) {
          if (state is bb.SuccessMsgState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
            BlocProvider.of<ProductsBloc>(context)
                .add(GetSchoolDaysEvent(widget.childId, widget.accessToken));
          }
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            body: BlocBuilder<ProductsBloc, ProductsState>(
                buildWhen: (productsBloc, productsState) {
              if (productsState is LoadedSchoolDaysState) {
                return true;
              } else {
                return false;
              }
            }, builder: (
              context,
              state,
            ) {
              if (state is LoadedSchoolDaysState) {
                return Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: HexColor('#51093C'),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.dstIn,
                      ),
                      image: const AssetImage(
                        'assets/images/back3.png',
                      ),
                    ),
                  ),
                  child: CustomScrollView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 22.2.h,
                        pinned: true,
                        centerTitle: true,
                        scrolledUnderElevation: 10,
                        backgroundColor: currentScroll < 16.h
                            ? Colors.transparent
                            : primaryColor,
                        title: currentScroll > 16.h
                            ? Text(
                                'YES MEDRESE',
                                style: FontManager.impact.copyWith(
                                    color: Colors.white, letterSpacing: 2),
                              )
                            : const SizedBox(),
                        flexibleSpace: scrollviewAppbar(),
                      ),
                      SliverToBoxAdapter(
                          child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Card(
                            margin: EdgeInsets.symmetric(horizontal: 2.w),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            color: Colors.white.withOpacity(0.7),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "SCHOOL_DAYS_WEEK_BALANCE".tr(context) +
                                        toCurrencyString(
                                            state.weekDays.weeklyBalance
                                                .toString(),
                                            useSymbolPadding: true,
                                            trailingSymbol: widget.currency),
                                    style: FontManager.kumbhSansBold.copyWith(
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor('#EA4B6F'),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: HexColor('#924C89'),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      enterWeeklyBalance(
                                          context,
                                          widget.childName,
                                          widget.childId,
                                          widget.accessToken,
                                          widget.currency,
                                          state.weekDays.weeklyBalance);
                                    },
                                    child: Text(
                                      "PRODUCTS_ADD".tr(context),
                                      style:
                                          FontManager.kumbhSansBold.copyWith(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(3.h),
                            child: Center(
                                child: Text(
                              "SCHOOL_DAYS_WEEK_PRODUCTS".tr(context) +
                                  toCurrencyString(
                                      state.weekDays.weeklyProductsPrice
                                          .toString(),
                                      useSymbolPadding: true,
                                      trailingSymbol: widget.currency),
                              style: FontManager.kumbhSansBold.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: Colors.white),
                            )),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.weekDays.days!.length,
                              itemBuilder: (context, index) {
                                if (index % 2 == 0) {
                                  return _getRight(
                                      state.weekDays.days![index].dayName!,
                                      state.weekDays.days![index].productsPrice,
                                      state
                                          .weekDays.days![index].productsCount!,
                                      state.weekDays.days![index].mealsCount!,
                                      state.weekDays.days![index].dayId!,
                                      context);
                                } else {
                                  return _getLeft(
                                      state.weekDays.days![index].dayName!,
                                      state.weekDays.days![index].productsPrice,
                                      state
                                          .weekDays.days![index].productsCount!,
                                      state.weekDays.days![index].mealsCount!,
                                      state.weekDays.days![index].dayId!,
                                      context);
                                }
                              }),
                        ],
                      ))
                    ],
                  ),
                );
              } else {
                return Scaffold(
                    body: Container(
                  decoration: BoxDecoration(
                    color: HexColor('#51093C'),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.dstIn,
                      ),
                      image: const AssetImage(
                        'assets/images/back3.png',
                      ),
                    ),
                  ),
                  child: const LoadingWidget(),
                ));
              }
            })));
  }

  void enterWeeklyBalance(BuildContext context, String childName, int childId,
      String accessToken, String currency, cWeeklyBalance) {
    showDialog<bool>(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              weeklyBalance.text = cWeeklyBalance.toString();
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  ElevatedButton(
                      child: Text("DIALOG_CONFIRMATION_BUTTON1".tr(context),
                          style: TextStyle(fontSize: 14.sp)),
                      onPressed: () async {
                        if (formKey1.currentState!.validate()) {
                          BlocProvider.of<bb.BalanceBloc>(context).add(
                              bb.StoreWeeklyBalanceEvent(
                                  double.parse(weeklyBalance.text),
                                  childId,
                                  accessToken));
                          Go.back(context);
                        }
                      }),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("DIALOG_BUTTON_CANCEL".tr(context),
                          style: TextStyle(fontSize: 14.sp)))
                ],
                title: Text(
                  "SET_WEEKLY_BALANCE".tr(context) + childName,
                  style: TextStyle(fontSize: 11.sp),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: formKey1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40.w,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^-?\d*\.?\d*)'))
                            ],
                            validator: (mobile) => mobile!.isEmpty
                                ? "REQUIRED_FIELD".tr(context)
                                : null,
                            controller: weeklyBalance,
                            decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              hintText:
                                  'DIALOG_SEARCH_PRICE_TEXT_HINT'.tr(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  //Right Alignment
  Widget _getRight(String dayName, dynamic totalPrice, int marketCount,
      int restaurantCount, int dayId, BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: 35.h,
          width: 60.w,
          child: Stack(
            children: [
              Positioned(
                  left: 25.w,
                  top: 24.2.h,
                  child: SizedBox(
                      width: 30.w,
                      height: 10.h,
                      child: Card(
                          // margin: EdgeInsets.all(10),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          color: Colors.white.withOpacity(0.57),
                          child: Container(
                              // color: Colors.red,
                              padding: EdgeInsets.only(bottom: 1.h),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                dayName,
                                style: FontManager.dubaiBold.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor('#C53E5D'),
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0.0, 3.0),
                                        blurRadius: 5.0,
                                        color: HexColor('#EF738F'),
                                      ),
                                    ]),
                              ))))),
              Positioned(
                  top: 2.h,
                  left: 15.w,
                  child: SizedBox(
                    width: 36.w,
                    height: 27.h,
                    child: Card(
                      elevation: 20,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "MARKET_GROUP_VIEW".tr(context) + '  ',
                                style: FontManager.poppinsBold
                                    .copyWith(fontSize: 12.sp),
                              ),
                              Text(
                                marketCount.toString(),
                                style: FontManager.kumbhSansBold
                                    .copyWith(fontSize: 10.sp),
                              )
                            ],
                          ),
                          SizedBox(height: .6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: const DottedLine(
                              dashColor: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "RESTAURANT_GROUP_VIEW".tr(context),
                                style: FontManager.poppinsBold
                                    .copyWith(fontSize: 10.sp),
                              ),
                              Text(
                                restaurantCount.toString(),
                                style: FontManager.kumbhSansBold
                                    .copyWith(fontSize: 10.sp),
                              )
                            ],
                          ),
                          SizedBox(height: .6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: const DottedLine(
                              dashColor: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Card(
                            color: const Color(0xffDCB9C4),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: SizedBox(
                              width: 25.w,
                              height: 6.h,
                              child: Center(
                                  child: Text(
                                toCurrencyString(totalPrice.toString(),
                                    trailingSymbol: widget.currency,
                                    useSymbolPadding: true),
                                style: FontManager.impact.copyWith(
                                  fontSize: 13.sp,
                                  color: HexColor('#C53E5D'),
                                ),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Positioned(
                top: 0.h,
                right: 14.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        BlocProvider.of<ProductsBloc>(context).add(
                            GetBookedProductsEvent(
                                widget.childId, widget.accessToken, dayId));
                        Go.to(
                            context,
                            BookedDayProducts(
                              accessToken: widget.accessToken,
                              childId: widget.childId,
                              dayId: dayId,
                              currency: widget.currency,
                              dayName: dayName,
                              childName: widget.childName,
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(7.sp),
                        //height: 5.h,width: ,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.8),
                            spreadRadius: 1,
                            blurRadius: 0,
                            offset: const Offset(
                                0, 4), // changes position of shadow
                          ),
                        ], color: Colors.white, shape: BoxShape.circle),
                        child: ImageIcon(
                          const AssetImage("assets/images/cutlery.png"),
                          color: HexColor('#E15A70'),
                          size: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    InkWell(
                      onTap: () {
                        BlocProvider.of<ProductsBloc>(context).add(
                            GetDayProductsEvent(
                                widget.childId, widget.accessToken, dayId));
                        Go.to(
                            context,
                            DayProducts(
                              accessToken: widget.accessToken,
                              childId: widget.childId,
                              dayId: dayId,
                              currency: widget.currency,
                              dayName: dayName,
                              childName: widget.childName,
                            ));
                      },
                      child: Container(
                          padding: EdgeInsets.all(7.sp),
                          //height: 5.h,width: ,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.8),
                              spreadRadius: 1,
                              blurRadius: 0,
                              offset: const Offset(
                                  0, 4), // changes position of shadow
                            ),
                          ], color: Colors.white, shape: BoxShape.circle),
                          child: ImageIcon(
                            const AssetImage("assets/images/grocery-store.png"),
                            color: HexColor('#5D8DFF'),
                            size: 14.sp,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  // Left Alignment
  Widget _getLeft(String dayName, dynamic totalPrice, int marketCount,
      int restaurantCount, int dayId, BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 35.h,
          width: 60.w,
          child: Stack(
            children: [
              Positioned(
                left: 5.w,
                top: 24.2.h,
                child: SizedBox(
                  width: 30.w,
                  height: 10.h,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: Colors.white.withOpacity(0.57),
                    child: Container(
                      padding: EdgeInsets.only(bottom: 1.h),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        dayName,
                        style: FontManager.dubaiBold.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: HexColor('#C53E5D'),
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 3.0),
                                blurRadius: 5.0,
                                color: HexColor('#EF738F'),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 2.h,
                  right: 15.w,
                  child: SizedBox(
                    width: 36.w,
                    height: 27.h,
                    child: Card(
                      elevation: 20,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "MARKET_GROUP_VIEW".tr(context) + '  ',
                                style: FontManager.poppinsBold
                                    .copyWith(fontSize: 12.sp),
                              ),
                              Text(
                                marketCount.toString(),
                                style: FontManager.kumbhSansBold
                                    .copyWith(fontSize: 10.sp),
                              )
                            ],
                          ),
                          SizedBox(height: .6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: const DottedLine(
                              dashColor: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "RESTAURANT_GROUP_VIEW".tr(context),
                                style: FontManager.poppinsBold
                                    .copyWith(fontSize: 10.sp),
                              ),
                              Text(
                                restaurantCount.toString(),
                                style: FontManager.kumbhSansBold
                                    .copyWith(fontSize: 10.sp),
                              )
                            ],
                          ),
                          SizedBox(height: .6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: const DottedLine(
                              dashColor: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Card(
                            color: const Color(0xffDCB9C4),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: SizedBox(
                              width: 25.w,
                              height: 6.h,
                              child: Center(
                                  child: Text(
                                toCurrencyString(totalPrice.toString(),
                                    trailingSymbol: widget.currency,
                                    useSymbolPadding: true),
                                style: FontManager.impact.copyWith(
                                  fontSize: 13.sp,
                                  color: HexColor('#C53E5D'),
                                ),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Positioned(
                top: 0.h,
                left: 15.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        BlocProvider.of<ProductsBloc>(context).add(
                            GetBookedProductsEvent(
                                widget.childId, widget.accessToken, dayId));
                        Go.to(
                            context,
                            BookedDayProducts(
                              accessToken: widget.accessToken,
                              childId: widget.childId,
                              dayId: dayId,
                              currency: widget.currency,
                              dayName: dayName,
                              childName: widget.childName,
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(7.sp),
                        //height: 5.h,width: ,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.8),
                            spreadRadius: 1,
                            blurRadius: 0,
                            offset: const Offset(
                                0, 4), // changes position of shadow
                          ),
                        ], color: Colors.white, shape: BoxShape.circle),
                        child: ImageIcon(
                          const AssetImage("assets/images/cutlery.png"),
                          color: HexColor('#E15A70'),
                          size: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    InkWell(
                      onTap: () {
                        BlocProvider.of<ProductsBloc>(context).add(
                            GetDayProductsEvent(
                                widget.childId, widget.accessToken, dayId));
                        Go.to(
                            context,
                            DayProducts(
                              accessToken: widget.accessToken,
                              childId: widget.childId,
                              dayId: dayId,
                              currency: widget.currency,
                              dayName: dayName,
                              childName: widget.childName,
                            ));
                      },
                      child: Container(
                          padding: EdgeInsets.all(7.sp),
                          //height: 5.h,width: ,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.8),
                              spreadRadius: 1,
                              blurRadius: 0,
                              offset: const Offset(
                                  0, 4), // changes position of shadow
                            ),
                          ], color: Colors.white, shape: BoxShape.circle),
                          child: ImageIcon(
                            const AssetImage("assets/images/grocery-store.png"),
                            color: HexColor('#5D8DFF'),
                            size: 14.sp,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
