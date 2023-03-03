import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:school_cafteria/features/products/presentation/pages/day_products/day_products.dart';
import 'package:school_cafteria/features/products/presentation/pages/day_products/products_search_by_price.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/products_bloc.dart';
import 'package:school_cafteria/features/balance/presentation/bloc/balance_bloc.dart'
as bb;

class SchoolDays extends StatelessWidget {
   SchoolDays(
      {Key? key,
      required this.accessToken,
      required this.childId,
      required this.currency, required this.childName})
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
      SnackBarMessage().showSuccessSnackBar(
          message: state.message, context: context);
      BlocProvider.of<
          ProductsBloc>(
          context)
          .add(GetSchoolDaysEvent(
          childId,
          accessToken));
      }},
  child: Scaffold(
      resizeToAvoidBottomInset:false,
        appBar: AppBar(
          title: Text("SCHOOL_DAYS_APPBAR".tr(context)),
        ),
        body: BlocBuilder<ProductsBloc, ProductsState>(
            buildWhen: (productsBloc, productsState) {
              if(productsState is LoadedSchoolDaysState)
                {
                  return true;
                }
              else {
                return false;
              }
            },
            builder: (
              context,
              state,
            ) {
              if (state is LoadingState) {
                return const LoadingWidget();
              } else if (state is LoadedSchoolDaysState) {
                return Column(
                  children: [
                  Expanded(
                    flex: 1,
                  // height: 15.h,
                  // width: 100.w
                     child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30)),
                        ),
                        elevation: 3,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 5.h,
                                  width: 65.w,
                                  color: pc2,
                                  child: Text(
                                    "Summary",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 65.w,
                              height: 11.h,
                              child:  Padding(
                                padding: EdgeInsets.only(top: 2.h,left:1.h ,right:1.h ,bottom:1.h ),
                                child: Column(
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Weekly Balance: ",style: TextStyle(fontSize: 11.sp),),
                                        Text(toCurrencyString(state.weekDays.weeklyBalance.toString(),useSymbolPadding: true,trailingSymbol: currency),style: TextStyle(fontSize: 11.sp,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Weekly Proudcts Price " ,style: TextStyle(fontSize: 10.sp)),
                                        Text(toCurrencyString(state.weekDays.weeklyProductsPrice.toString(),useSymbolPadding: true,trailingSymbol: currency),style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold,color:double.parse(state.weekDays.weeklyBalance!)<state.weekDays.weeklyProductsPrice?Colors.red:Colors.black )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(30.w, 8.h),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),

                              onPressed: (){
                                BlocProvider.of<ProductsBloc>(context).add(
                                    GetSchoolProductsByPriceEvent(childId,
                                        accessToken, null));
                                Go.to(
                                    context,
                                    ProductSearch(
                                      accessToken: accessToken,
                                      childId: childId,
                                      currency: currency,
                                      maxPrice: null,
                                      dayId: null,
                                      dayName: null,
                                      isWeekly: true,
                                      daysCount: state.weekDays.days!.length,
                                      weeklyBalance:state.weekDays.weeklyBalance,
                                      childName: childName,
                                    ));
                              }, child: Text("Set Products for the week",textAlign: TextAlign.center,style: TextStyle(fontSize: 10.sp),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:Colors.white,
                                  fixedSize: Size(30.w, 8.h),
                                shape:  RoundedRectangleBorder(
                                  side: BorderSide(color: primaryColor),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),

                              onPressed: (){
                                enterWeeklyBalance(context,childName,childId,accessToken,currency,state.weekDays.weeklyBalance);

                              }, child: Text("Set Weekly Balance",textAlign: TextAlign.center,style: TextStyle(fontSize: 10.sp,color: primaryColor),)),
                        ),
                      ],
                    ),


                  ],
                ),
                ),  Expanded(
                  //     height:70.h ,
                  // width: 100.w,
                flex:4,
                  child: ListView.builder(
                      itemCount: state.weekDays.days!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: SizedBox(
                              height: 17.h,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<ProductsBloc>(context).add(
                                      GetDayProductsEvent(childId, accessToken,
                                          state.weekDays.days![index].dayId!));
                                  Go.to(
                                      context,
                                      DayProducts(
                                        accessToken: accessToken,
                                        childId: childId,
                                        dayId: state.weekDays.days![index].dayId!,
                                        currency: currency,
                                        dayName: state.weekDays.days![index].dayName!,
                                        childName: childName,
                                      ));
                                },
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30)),
                                  ),
                                  color: Colors.white70,
                                  elevation: 10,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 5.h,
                                            width: 98.w,
                                            color: pc2,
                                            child: Text(
                                              state.weekDays.days![index].dayName!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ListTile(
                                        title: Text(
                                            "SCHOOL_DAYS_TOTAL_MONEY".tr(context)+toCurrencyString(state.weekDays.days![index].productsPrice.toString(), trailingSymbol: currency, useSymbolPadding: true)),
                                        subtitle: Text(
                                            "SCHOOL_DAYS_TOTAL_PRODUCT".tr(context)+ state.weekDays.days![index].productsCount.toString()),
                                        leading: Icon(
                                          Icons.wallet_rounded,
                                          color: pc2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }),
                )
                  ]);
              } else {
                return const SizedBox();
              }
            })),
);
  }
  void enterWeeklyBalance(BuildContext context, String childName, int childId,
      String accessToken, String currency,cWeeklyBalance) {
    showDialog<bool>(
        context: context,
        builder: (_) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              weeklyBalance.text=cWeeklyBalance.toString();
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  ElevatedButton(
                      child: Text("Confirm", style: TextStyle(fontSize: 14.sp)),
                      onPressed: ()  async {
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
                  "Set Weekly Balance to $childName",
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
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              border: UnderlineInputBorder(
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
}
