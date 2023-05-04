import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:intl/intl.dart';
import 'package:school_cafteria/appBar.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:school_cafteria/features/products/presentation/pages/booked_products/school_dated_product_page.dart';
import 'package:school_cafteria/features/products/presentation/pages/day_products/products_search_by_price.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/navigation.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/confirmation_dialog.dart';

class BookedDayProducts extends StatelessWidget {
  BookedDayProducts(
      {Key? key,
      required this.accessToken,
      required this.childId,
      required this.currency,
      required this.dayId,
      required this.dayName,
      required this.childName})
      : super(key: key);
  final String accessToken;
  final String childName;
  final int childId;
  final int dayId;
  final String currency;
  final String dayName;
  final maxPrice = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: getAppBar(),
        // float button location in terms of language
        floatingActionButtonLocation:
            AppLocalizations.of(context)!.locale!.languageCode != 'ar'
                ? FloatingActionButtonLocation.endFloat
                : FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<ProductsBloc>(context).add(GetDatedProductsEvent(accessToken,dayId));
            Go.to(context, SchoolDatedProduct(accessToken: accessToken, childId: childId, currency: currency, dayId: dayId, dayName: dayName, childName: childName));
          },
          child: const Icon(Icons.add),
        ),
        body: BlocConsumer<ProductsBloc, ProductsState>(
            listener: (context, state) {
          if (state is ErrorMsgState) {
            SnackBarMessage()
                .showErrorSnackBar(message: state.message, context: context);
          } else if (state is SuccessMsgState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
            BlocProvider.of<ProductsBloc>(context)
                .add(GetBookedProductsEvent(childId, accessToken, dayId));

          }
        }, buildWhen: (productsBloc, productsState) {
          if (productsState is LoadedBookedProductsState) {
            return true;
          } else {
            return false;
          }
        }, builder: (
          context,
          state,
        ) {
          if (state is LoadingState) {
            return Scaffold(body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.repeat,
                        image: AssetImage('assets/images/bg.png'))),
                child: const  LoadingWidget()));
          } else if (state is LoadedBookedProductsState) {
            return Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            repeat: ImageRepeat.repeat,
                            image: AssetImage('assets/images/bg.png'))),
                    child: ListView(children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Center(
                        child: Card(
                          color: Colors.white.withOpacity(0.7),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: SizedBox(
                            height: 5.h,
                            width: 66.w,
                            child: Center(
                                child: Text("PRODUCTS_LIST".tr(context),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700))),
                          ),
                        ),
                      ),
                       ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.products.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: 7.h + 20.w,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                              padding: EdgeInsets.all(0.4.h),
                                              child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    minWidth: 35.w,
                                                    maxWidth: 35.w,
                                                    maxHeight: 20.h,
                                                    minHeight: 20.h,
                                                  ),
                                                  child: state.products[index]
                                                              .image ==
                                                          null
                                                      ? Image.asset(
                                                          'assets/launcher/logo.png',
                                                          scale: 15.0,
                                                        )
                                                      : Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white70,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0),
                                                              border: Border.all(
                                                                  color:
                                                                      primaryColor)),
                                                          height: 12.h + 13.w,
                                                          child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(25.0),
                                                              child: Image(
                                                                fit: BoxFit.cover,
                                                                image: NetworkImage(Network().baseUrl + state.products[index].image!),
                                                                width: 35.w,
                                                              )),
                                                        )
                                              )),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.37,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  1.w, 1.h, 0, 0),
                                              child: Row(
                                                children: [
                                                  AutoSizeText(
                                                    state.products[index].name!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.sp,
                                                    ),
                                                  ),
                                                  state.products[index]
                                                                  .quantity ==
                                                              0 ||
                                                          state.products[index]
                                                                  .quantity ==
                                                              null
                                                      ? const SizedBox()
                                                      : Text(
                                                          "X ${state.products[index].quantity}")
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.37,
                                            height: 9.h,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  1.w, 1.h, 0, 0),
                                              child: AutoSizeText(
                                                "${state.products[index]
                                                        .description ??
                                                    state.products[index].name!}\n${DateFormat('dd/MM/yyyy').format(DateTime.parse(state.products[index].restaurantDatedProduct!.availableDate!))}",
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 1.h, 0, 0),
                                            child: Text(
                                              toCurrencyString(
                                                  state.products[index].price!,
                                                  trailingSymbol: currency,
                                                  useSymbolPadding: true),
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.w, 2.h, 0, 0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    )),
                                                onPressed: () {
                                                  confirmationDialog(context,(){BlocProvider.of<ProductsBloc>(
                                                      context)
                                                      .add(
                                                      DeleteDayProductEvent(
                                                          state
                                                              .products[
                                                          index]
                                                              .id!,
                                                          childId,
                                                          accessToken,
                                                          dayId));},"PRODUCT_REMOVE_DAY_CONFIRMATION".tr(context));

                                                },
                                                child: Text(
                                                  "PRODUCTS_LIST_DELETE".tr(context),
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15.sp),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              })
                    ]));
          } else {
            return const SizedBox();
          }
        }));
  }

  void enterDetailsDialog(BuildContext context) {
    showDialog<bool>(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  ElevatedButton(
                      child: Text("DIALOG_BUTTON_SEARCH".tr(context),
                          style: TextStyle(fontSize: 14.sp)),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<ProductsBloc>(context).add(
                              GetSchoolProductsByPriceEvent(childId,
                                  accessToken, double.parse(maxPrice.text)));
                          Go.off(
                              context,
                              ProductSearch(
                                accessToken: accessToken,
                                childId: childId,
                                currency: currency,
                                maxPrice: maxPrice.text,
                                dayId: dayId,
                                dayName: dayName,
                                isWeekly: false,
                                daysCount: null,
                                weeklyBalance: null,
                                childName: childName,
                              ));
                        }
                      }),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("DIALOG_BUTTON_CANCEL".tr(context),
                          style: TextStyle(fontSize: 14.sp)))
                ],
                title: Text(
                  "DIALOG_SEARCH_PRICE_TITLE".tr(context),
                  style: TextStyle(fontSize: 13.sp),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40.w,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^-?\d*\.?\d*)'))
                            ],
                            validator: (mobile) => mobile!.isEmpty
                                ? "REQUIRED_FIELD".tr(context)
                                : null,
                            controller: maxPrice,
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
}
