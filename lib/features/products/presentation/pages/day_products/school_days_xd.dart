import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:school_cafteria/appBar.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/features/products/presentation/pages/booked_products/booked_day_products.dart';
import 'package:sizer/sizer.dart';
import 'package:school_cafteria/features/balance/presentation/bloc/balance_bloc.dart'
    as bb;
import '../../../../../core/navigation.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/products_bloc.dart';
import 'day_products.dart';

class SchoolDays2 extends StatelessWidget {
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

  final weeklyBalance = TextEditingController();
  final formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<bb.BalanceBloc, bb.BalanceState>(
        listener: (context, state) {
          if (state is bb.SuccessMsgState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
            BlocProvider.of<ProductsBloc>(context)
                .add(GetSchoolDaysEvent(childId, accessToken));
          }
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: getAppBar(),
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
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/images/bg.png",
                          ),
                          fit: BoxFit.cover)),
                  child: ListView(
                    children: [
                      Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        color: Colors.white.withOpacity(0.7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "SCHOOL_DAYS_WEEK_BALANCE".tr(context) +
                                  toCurrencyString(
                                      state.weekDays.weeklyBalance.toString(),
                                      useSymbolPadding: true,
                                      trailingSymbol: currency),
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: textColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: const RoundedRectangleBorder(
                                      side: BorderSide(color: secondaryColor2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                ),
                                onPressed: () {
                                  enterWeeklyBalance(
                                      context,
                                      childName,
                                      childId,
                                      accessToken,
                                      currency,
                                      state.weekDays.weeklyBalance);
                                },
                                child: Text("PRODUCTS_ADD".tr(context)))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.h),
                        child: Center(
                            child: Text(
                          "SCHOOL_DAYS_WEEK_PRODUCTS".tr(context) +
                              toCurrencyString(
                                  state.weekDays.weeklyProductsPrice.toString(),
                                  useSymbolPadding: true,
                                  trailingSymbol: currency),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: const Color(0xff701782)),
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
                                    state.weekDays.days![index].productsCount!,
                                    state.weekDays.days![index].mealsCount!,
                                    state.weekDays.days![index].dayId!,
                                    context);
                              } else {
                               return _getLeft(
                                    state.weekDays.days![index].dayName!,
                                    state.weekDays.days![index].productsPrice,
                                    state.weekDays.days![index].productsCount!,
                                    state.weekDays.days![index].mealsCount!,
                                    state.weekDays.days![index].dayId!,
                                    context);
                              }
                            }),
                    ],
                  ),
                );
              } else {
                return Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            repeat: ImageRepeat.repeat,
                            image: AssetImage('assets/images/bg.png'))),
                    child: const LoadingWidget());
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
                      child: Text("DIALOG_CONFIRMATION_BUTTON1".tr(context), style: TextStyle(fontSize: 14.sp)),
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
                  "SET_WEEKLY_BALANCE".tr(context)+ childName,
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
          height: 36.h,
          width: 60.w,
          child: Stack(
            children: [
              Positioned(
                  left: 25.w,
                  top: 27.h,
                  child: SizedBox(
                      width: 30.w,
                      height: 10.h,
                      child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          color: Colors.white.withOpacity(0.7),
                          child: Center(
                              child: Text(
                            dayName,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: primaryColor),
                          ))))),
              Positioned(
                  top: 6.h,
                  left: 15.w,
                  child: SizedBox(
                    width: 36.w,
                    height: 25.h,
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
                              Text("MARKET_GROUP_VIEW".tr(context)),
                              Text(marketCount.toString())
                            ],
                          ),
                          const DottedLine(
                            dashColor: Colors.red,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("RESTAURANT_GROUP_VIEW".tr(context)),
                              Text(restaurantCount.toString())
                            ],
                          ),
                          const DottedLine(
                            dashColor: Colors.red,
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
                                    trailingSymbol: currency,
                                    useSymbolPadding: true),
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Positioned(
                  top: 4.h,
                  left: 38.w,
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<ProductsBloc>(context).add(
                          GetDayProductsEvent(childId, accessToken, dayId));
                      Go.to(
                          context,
                          DayProducts(
                            accessToken: accessToken,
                            childId: childId,
                            dayId: dayId,
                            currency: currency,
                            dayName: dayName,
                            childName: childName,
                          ));
                    },
                    child: Container(
                      //height: 5.h,width: ,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 0,
                          offset: const Offset(0, 4), // changes position of shadow
                        ),
                      ], color: Colors.white, shape: BoxShape.circle),
                      child:  ImageIcon(
                        const AssetImage("assets/images/market.png"),
                        color: Colors.blue,
                        size:22.sp,
                      ),
                    ),
                  )),
              Positioned(
                  top: 4.h,
                  left: 22.w,
                  child:  InkWell(
                      onTap: () {
                        BlocProvider.of<ProductsBloc>(context).add(
                            GetBookedProductsEvent(childId, accessToken, dayId));
                        Go.to(
                            context,
                            BookedDayProducts(
                              accessToken: accessToken,
                              childId: childId,
                              dayId: dayId,
                              currency: currency,
                              dayName: dayName,
                              childName: childName,
                            ));
                      },
                      child:Container(
                    //height: 5.h,width: ,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.8),
                        spreadRadius: 1,
                        blurRadius: 0,
                        offset: const Offset(0, 4), // changes position of shadow
                      ),
                    ], color: Colors.white, shape: BoxShape.circle),
                    child: ImageIcon(
                      const AssetImage("assets/images/rest.png"),
                      color: Colors.pinkAccent,
                      size:22.sp,

                    ),
                  )),
              )],
          ),
        ));
  }

  // Left Alignment
  Widget _getLeft(String dayName, dynamic totalPrice, int marketCount,
      int restaurantCount, int dayId, BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 36.h,
          width: 60.w,
          child: Stack(
            children: [
              Positioned(
                  left: 5.w,
                  top: 27.h,
                  child: SizedBox(
                      width: 30.w,
                      height: 10.h,
                      child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          color: Colors.white.withOpacity(0.7),
                          child: Center(
                              child: Text(
                            dayName,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: primaryColor),
                          ))))),
              Positioned(
                  top: 6.h,
                  right: 15.w,
                  child: SizedBox(
                    width: 36.w,
                    height: 25.h,
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
                              Text("MARKET_GROUP_VIEW".tr(context)),
                              Text(marketCount.toString())
                            ],
                          ),
                          const DottedLine(
                            dashColor: Colors.red,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("RESTAURANT_GROUP_VIEW".tr(context)),
                              Text(restaurantCount.toString())
                            ],
                          ),
                          const DottedLine(
                            dashColor: Colors.red,
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
                                    trailingSymbol: currency,
                                    useSymbolPadding: true),
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Positioned(
                  top: 4.h,
                  left: 32.w,
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<ProductsBloc>(context).add(
                          GetDayProductsEvent(childId, accessToken, dayId));
                      Go.to(
                          context,
                          DayProducts(
                            accessToken: accessToken,
                            childId: childId,
                            dayId: dayId,
                            currency: currency,
                            dayName: dayName,
                            childName: childName,
                          ));
                    },
                    child: Container(
                        //height: 5.h,width: ,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.8),
                            spreadRadius: 1,
                            blurRadius: 0,
                            offset: const Offset(0, 4), // changes position of shadow
                          ),
                        ], color: Colors.white, shape: BoxShape.circle),
                        child:  ImageIcon(
                          const AssetImage("assets/images/market.png"),
                          color: Colors.blue,
                          size:22.sp,

                        )),
                  )),
              Positioned(
                  top: 4.h,
                  left:16.w,
                  child: InkWell(
                      onTap: () {
                        BlocProvider.of<ProductsBloc>(context).add(
                            GetBookedProductsEvent(childId, accessToken, dayId));
                        Go.to(
                            context,
                            BookedDayProducts(
                              accessToken: accessToken,
                              childId: childId,
                              dayId: dayId,
                              currency: currency,
                              dayName: dayName,
                              childName: childName,
                            ));
                      },
                      child: Container(
                    //height: 5.h,width: ,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.8),
                        spreadRadius: 1,
                        blurRadius: 0,
                        offset: const Offset(0, 4), // changes position of shadow
                      ),
                    ], color: Colors.white, shape: BoxShape.circle),
                    child:  ImageIcon(
                      const AssetImage("assets/images/rest.png"),
                      color: Colors.pinkAccent,
                      size:22.sp,
                    ),
                  )),
              )],
          ),
        ));
  }
}
