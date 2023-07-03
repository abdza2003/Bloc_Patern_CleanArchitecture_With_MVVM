import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:lottie/lottie.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/features/account/domain/entities/child.dart';
import 'package:school_cafteria/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/network/api.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/loading_widget.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage(
      {Key? key, required this.studentIds, required this.children})
      : super(key: key);
  final List<int> studentIds;
  final List<Child> children;
  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fromDateController.text = ""; //set the initial value of text field
    toDateController.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BalanceBloc, BalanceState>(listener: (context, state) {
      if (state is ErrorMsgState) {
        SnackBarMessage()
            .showErrorSnackBar(message: state.message, context: context);
      } else if (state is SuccessCancelMsgState) {
        SnackBarMessage()
            .showSuccessSnackBar(message: state.message, context: context);
        if (fromDateController.text.isNotEmpty) {
          BlocProvider.of<BalanceBloc>(context).add(GetPaymentsEvent(
              widget.studentIds,
              fromDateController.text,
              toDateController.text));
        } else {
          BlocProvider.of<BalanceBloc>(context)
              .add(GetPaymentsEvent(widget.studentIds, null, null));
        }
      }
    }, buildWhen: (balanceBloc, balanceState) {
      if (balanceState is LoadedPaymentsState) {
        return true;
      } else {
        return false;
      }
    }, builder: (
      context,
      state,
    ) {
      if (state is LoadingState) {
        return const LoadingWidget();
      } else if (state is LoadedPaymentsState) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    offset: Offset(0, 0),
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 20.0,
                  ),
                ],
              ),
              child: Card(
                color: Colors.white.withOpacity(0.57),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  width: 100.w,
                  height: 7.h,
                  child: Form(
                    key: formKey,
                    child: Row(
                      children: [
                        SizedBox(
                            width: 40.w,
                            child: Center(
                              child: TextFormField(
                                validator: (value) => value!.isEmpty
                                    ? "REQUIRED_FIELD".tr(context)
                                    : null,
                                readOnly: true,
                                controller: fromDateController,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          DateTime.now(), //get today's date
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2028));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    setState(() {
                                      fromDateController.text = formattedDate;
                                    });
                                  } else {
                                    if (kDebugMode) {
                                      print("Date is not selected");
                                    }
                                  }
                                },
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText:
                                      "PAYMENTS_PAGE_CHOOSE_DATE1".tr(context),
                                  hintStyle: FontManager.segoeRegular.copyWith(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            )),
                        const VerticalDivider(
                          width: 5,
                          color: Colors.black,
                        ),
                        SizedBox(
                            width: 40.w,
                            child: Center(
                              child: TextFormField(
                                validator: (value) => value!.isEmpty
                                    ? "REQUIRED_FIELD".tr(context)
                                    : null,
                                readOnly: true,
                                controller: toDateController,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          DateTime.now(), //get today's date
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2028));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    setState(() {
                                      toDateController.text = formattedDate;
                                    });
                                  } else {
                                    if (kDebugMode) {
                                      print("Date is not selected");
                                    }
                                  }
                                },
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText:
                                      "PAYMENTS_PAGE_CHOOSE_DATE2".tr(context),
                                  hintStyle: FontManager.segoeRegular.copyWith(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            )),
                        IconButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<BalanceBloc>(context).add(
                                    GetPaymentsEvent(
                                        widget.studentIds,
                                        fromDateController.text,
                                        toDateController.text));
                              }
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Center(
              child: Text(
                "PAYMENTS_PAGE_TOTAL_SPENT".tr(context).toUpperCase() +
                    '${state.payments.totalSpent}',
                style: FontManager.kumbhSansBold.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 100.w,
              child: state.payments.userBalances!.isEmpty
                  ? const SizedBox()
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.payments.userBalances!.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: EdgeInsets.all(5.sp),
                          child: SizedBox(
                              height: 25.h,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  border: Border.all(
                                    color: HexColor('#90579B'),
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                      color: HexColor('#EA4B6F'),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(3.w),
                                        width: 35.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            color: HexColor('#8E579C'),
                                            width: 3,
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          // cacheManager: Base,
                                          fit: BoxFit.cover,
                                          imageUrl: Network().baseUrl +
                                              state
                                                  .payments
                                                  .userBalances![index]
                                                  .child!
                                                  .image!,
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(26),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                          placeholder: (context, url) => Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(7),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/launcher/logo.png'),
                                                  CircularProgressIndicator(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) {
                                            return Container(
                                              padding: EdgeInsets.all(5.w),
                                              child: Opacity(
                                                opacity: .6,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Lottie.asset(
                                                        'assets/images/Desktop HD.json'),
                                                    Text(
                                                      'undefined image',
                                                      style: FontManager
                                                          .dubaiRegular
                                                          .copyWith(
                                                        fontSize: 7.5.sp,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 45.w,
                                              child: Text(
                                                '${state.payments.userBalances![index].typeName!}',
                                                textAlign: TextAlign.end,
                                                style: FontManager.kumbhSansBold
                                                    .copyWith(
                                                  fontSize: 13.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: .8.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                new BoxShadow(
                                                  // spreadRadius: 0,
                                                  offset: Offset(0, 0),
                                                  color: Colors.white
                                                      .withOpacity(.3),
                                                  blurRadius: 10.0,
                                                ),
                                              ],
                                            ),
                                            child: Card(
                                                margin: EdgeInsets.zero,
                                                color: Colors.white
                                                    .withOpacity(.56),
                                                // elevation: 20,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: SizedBox(
                                                  width: 50.w,
                                                  height: 7.h,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0,
                                                                bottom: 10.0),
                                                        child: Text(
                                                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(state.payments.userBalances![index].createdAt!))}',
                                                          style: FontManager
                                                              .kumbhSansBold
                                                              .copyWith(
                                                            fontSize: 11.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        toCurrencyString(
                                                          '${state.payments.userBalances![index].balanceValue!}',
                                                          trailingSymbol: state
                                                              .payments
                                                              .userBalances![
                                                                  index]
                                                              .child!
                                                              .school!
                                                              .currencyName!,
                                                          useSymbolPadding:
                                                              true,
                                                        ),
                                                        style: FontManager
                                                            .impact
                                                            .copyWith(
                                                                fontSize: 14.sp,
                                                                color: HexColor(
                                                                    '#70972C')),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          Container(
                                              alignment: Alignment.centerRight,
                                              // color: Colors.red,
                                              width: 50.w,
                                              child: Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 0.w,
                                                  ),
                                                  Text(
                                                    "PAYMENTS_PAGE_STATUS"
                                                            .tr(context) +
                                                        '${state.payments.userBalances![index].statusName!}',
                                                    style: FontManager
                                                        .kumbhSansBold
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 11.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                  _getWidget(
                                                      state
                                                          .payments
                                                          .userBalances![index]
                                                          .status!,
                                                      '${state.payments.userBalances![index].id!}',
                                                      '${state.payments.userBalances![index].child!.id!}')
                                                ],
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }),
            ),
          ],
        );

        /*  ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.white.withOpacity(0.4),
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                child: Card(
                  color: Colors.white.withOpacity(0.57),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: 100.w,
                    height: 7.h,
                    child: Form(
                      key: formKey,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 40.w,
                              child: Center(
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  readOnly: true,
                                  controller: fromDateController,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            DateTime.now(), //get today's date
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2028));

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                      setState(() {
                                        fromDateController.text = formattedDate;
                                      });
                                    } else {
                                      if (kDebugMode) {
                                        print("Date is not selected");
                                      }
                                    }
                                  },
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "PAYMENTS_PAGE_CHOOSE_DATE1"
                                        .tr(context),
                                    hintStyle:
                                        FontManager.segoeRegular.copyWith(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              )),
                          const VerticalDivider(
                            width: 5,
                            color: Colors.black,
                          ),
                          SizedBox(
                              width: 40.w,
                              child: Center(
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  readOnly: true,
                                  controller: toDateController,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            DateTime.now(), //get today's date
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2028));

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                      setState(() {
                                        toDateController.text = formattedDate;
                                      });
                                    } else {
                                      if (kDebugMode) {
                                        print("Date is not selected");
                                      }
                                    }
                                  },
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "PAYMENTS_PAGE_CHOOSE_DATE2"
                                        .tr(context),
                                    hintStyle:
                                        FontManager.segoeRegular.copyWith(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              )),
                          IconButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<BalanceBloc>(context).add(
                                      GetPaymentsEvent(
                                          widget.studentIds,
                                          fromDateController.text,
                                          toDateController.text));
                                }
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Center(
                child: Text(
                  "PAYMENTS_PAGE_TOTAL_SPENT".tr(context).toUpperCase() +
                      '${state.payments.totalSpent}',
                  style: FontManager.kumbhSansBold.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                  height: 55.h,
                  child: state.payments.userBalances!.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.payments.userBalances!.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                                height: 10.h + 23.w,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(3.w),
                                      width: 30.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: HexColor('#8E579C'),
                                          width: 3,
                                        ),
                                      ),
                                      child: CachedNetworkImage(
                                        // cacheManager: Base,
                                        fit: BoxFit.cover,
                                        imageUrl: Network().baseUrl +
                                            state.payments.userBalances![index]
                                                .child!.image!,
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                        placeholder: (context, url) => Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                    'assets/launcher/logo.png'),
                                                CircularProgressIndicator(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            padding: EdgeInsets.all(5.w),
                                            child: Opacity(
                                              opacity: .6,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Lottie.asset(
                                                      'assets/images/Desktop HD.json'),
                                                  Text(
                                                    'undefined image',
                                                    style: FontManager
                                                        .dubaiRegular
                                                        .copyWith(
                                                      fontSize: 7.5.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 57.w,
                                            child: Text(
                                              '${state.payments.userBalances![index].typeName!}',
                                              textAlign: TextAlign.end,
                                              style: FontManager.kumbhSansBold
                                                  .copyWith(
                                                fontSize: 13.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: .8.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              new BoxShadow(
                                                // spreadRadius: 0,
                                                offset: Offset(0, 0),
                                                color: Colors.white
                                                    .withOpacity(.3),
                                                blurRadius: 10.0,
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                              margin: EdgeInsets.zero,
                                              color:
                                                  Colors.white.withOpacity(.56),
                                              // elevation: 20,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              child: SizedBox(
                                                width: 57.w,
                                                height: 7.h,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              bottom: 10.0),
                                                      child: Text(
                                                        '${DateFormat('dd/MM/yyyy').format(DateTime.parse(state.payments.userBalances![index].createdAt!))}',
                                                        style: FontManager
                                                            .kumbhSansBold
                                                            .copyWith(
                                                          fontSize: 11.sp,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      toCurrencyString(
                                                        '${state.payments.userBalances![index].balanceValue!}',
                                                        trailingSymbol: state
                                                            .payments
                                                            .userBalances![
                                                                index]
                                                            .child!
                                                            .school!
                                                            .currencyName!,
                                                        useSymbolPadding: true,
                                                      ),
                                                      style: FontManager.impact
                                                          .copyWith(
                                                              fontSize: 14.sp,
                                                              color: HexColor(
                                                                  '#70972C')),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Container(
                                            alignment: Alignment.centerRight,
                                            // color: Colors.red,
                                            width: 57.w,
                                            child: Row(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 0.w,
                                                ),
                                                Text(
                                                  "PAYMENTS_PAGE_STATUS"
                                                          .tr(context) +
                                                      '${state.payments.userBalances![index].statusName!}',
                                                  style: FontManager
                                                      .kumbhSansBold
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                _getWidget(
                                                    state
                                                        .payments
                                                        .userBalances![index]
                                                        .status!,
                                                    '${state.payments.userBalances![index].id!}',
                                                    '${state.payments.userBalances![index].child!.id!}')
                                              ],
                                            )),
                                      ],
                                    )
                                  ],
                                ));
                          }))
            ]); */
      } else {
        return const LoadingWidget();
      }
    });
  }

  Widget _getWidget(var status, var requestId, var childId) {
    if (status == "1") {
      return InkWell(
        onTap: () {
          String accessToken = widget.children
              .where((element) => element.id == childId)
              .first
              .accessTokenParent!;
          confirmationDialog(context, () {
            BlocProvider.of<BalanceBloc>(context)
                .add(CancelBalanceEvent(requestId, accessToken));
          }, "PAYMENTS_PAGE_CONFIRMATION_CANCEL".tr(context));
        },
        child: Row(
          children: [
            Text("DIALOG_BUTTON_CANCEL".tr(context),
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700)),
            const Icon(
              Icons.cancel,
              color: Colors.red,
            ),
          ],
        ),
      );
    } else if (status == "3") {
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  }
}
