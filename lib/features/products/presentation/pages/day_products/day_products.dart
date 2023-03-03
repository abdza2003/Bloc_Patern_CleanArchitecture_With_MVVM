import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:school_cafteria/features/products/presentation/no_product_found.dart';
import 'package:school_cafteria/features/products/presentation/pages/day_products/products_search_by_price.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/navigation.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/util/snackbar_message.dart';

class DayProducts extends StatelessWidget {
  DayProducts(
      {Key? key,
      required this.accessToken,
      required this.childId,
      required this.currency,
      required this.dayId,
      required this.dayName, required this.childName})
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
        appBar: AppBar(
          title: Text(dayName + "DAY_PRODUCTS_TITLE".tr(context)),
        ),
        floatingActionButtonLocation: AppLocalizations.of(context)!.locale!.languageCode!='ar'?FloatingActionButtonLocation.endFloat:FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            enterDetailsDialog(context);
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
                .add(GetDayProductsEvent(childId, accessToken, dayId));
            BlocProvider.of<ProductsBloc>(context)
                .add(GetSchoolDaysEvent(childId, accessToken));
          }
        }, buildWhen: (productsBloc, productsState) {
          if (productsState is LoadedDayProductsState) {
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
          } else if (state is LoadedDayProductsState) {
            return state.products.isEmpty
                ? Center(
              child: Text("NO_PRODUCT_FOUND".tr(context)),
            )
                :
                    ListView.builder(
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 18.h,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              color: Colors.white70,
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        child: state.products[index].image == null
                                            ? Image.asset(
                                                'assets/launcher/logo.png',
                                                scale: 15.0,
                                              )
                                            : Image(
                                                image: NetworkImage(Network()
                                                        .baseUrl +
                                                    state.products[index].image!),
                                                fit: BoxFit.fill,
                                              )),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width * 0.41,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(1.w, 1.h, 0, 0),
                                          child: Row(
                                            children: [
                                              AutoSizeText(
                                                state.products[index].name!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                          state.products[index].quantity==0?SizedBox():Text("X ${state.products[index].quantity}")
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width * 0.41,
                                        height: 9.h,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(1.w, 1.h, 0, 0),
                                          child: AutoSizeText(
                                            state.products[index].description ??
                                                state.products[index].name!,
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
                                        padding: EdgeInsets.fromLTRB(0, 1.h, 0, 0),
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
                                          padding:
                                              EdgeInsets.fromLTRB(2.w, 2.h, 0, 0),
                                          child: InkWell(
                                              onTap: () {
                                                BlocProvider.of<ProductsBloc>(
                                                        context)
                                                    .add(DeleteDayProductEvent(
                                                        state.products[index].id!,
                                                        childId,
                                                        accessToken,
                                                        dayId));
                                              },
                                              child: Icon(
                                                Icons.delete_rounded,
                                                size: 25.sp,
                                                color: Colors.red,
                                              ))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });

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
                actionsAlignment:MainAxisAlignment.center,
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
                              FilteringTextInputFormatter.allow(RegExp(r'(^-?\d*\.?\d*)'))
                            ],
                            validator: (mobile) => mobile!.isEmpty
                                ? "REQUIRED_FIELD".tr(context)
                                : null,
                            controller: maxPrice,
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
