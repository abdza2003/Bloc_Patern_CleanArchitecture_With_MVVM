import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/features/products/data/models/products_model.dart';
import 'package:school_cafteria/features/products/domain/entities/selected_products_quantity.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/navigation.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../data/models/selected_products_quantity_model.dart';
import '../../bloc/products_bloc.dart';
import '../../no_product_found.dart';

class SchoolDatedProduct extends StatefulWidget {
  const SchoolDatedProduct(
      {Key? key,
      required this.accessToken,
      required this.childId,
      required this.currency,
      required this.dayId,
      required this.dayName,
      required this.childName})
      : super(key: key);
  final String accessToken;
  final int childId;
  final int? dayId;
  final String currency;
  //final String? maxPrice;
  final String? dayName;
  final String childName;
  //final bool isWeekly;
  //final int? daysCount;
  //final dynamic weeklyBalance;

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<SchoolDatedProduct> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
      if (state is ErrorMsgState) {
        SnackBarMessage()
            .showErrorSnackBar(message: state.message, context: context);
      } else if (state is SuccessMsgStateStoredBookedProducts) {
        // Fluttertoast.showToast(
        //     msg: state.message,
        //     toastLength: Toast.LENGTH_LONG,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white);
         SnackBarMessage()
             .showSuccessSnackBar(message: state.message, context: context);
          BlocProvider.of<ProductsBloc>(context).add(GetBookedProductsEvent(
              widget.childId, widget.accessToken, widget.dayId!));
        Go.back(context);
      }
    }, builder: (context, state) {
      if (state is LoadingState) {
        return Scaffold(body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeat,
                    image: AssetImage('assets/images/bg.png'))),
            child: const LoadingWidget()));
      } else if (state is LoadedDatedProductsState) {
        if (state.products.isEmpty) {
          return  Scaffold(
            extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(10.h+10.w),
                child: AppBar(
                    flexibleSpace:  Padding(
                      padding:  EdgeInsets.only(top:5.h ,right: 38.w),
                      child: Container(
                        height: 8.h+7.w,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/launcher/logo.png'))),),
                    ),
                    elevation: 20,
                    bottomOpacity: 0,
                    backgroundColor: Colors.white.withOpacity(0.7),
                    shadowColor: Color(0xffFF5DB9),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.elliptical(1100, 500),
                          bottomLeft: Radius.elliptical(550, 350)),
                    )),
              ),
              body: NoPageFound());
        } else {
          return Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(10.h+10.w),
                child: AppBar(
                    flexibleSpace:  Padding(
                      padding:  EdgeInsets.only(top:5.h ,right: 38.w),
                      child: Container(
                        height: 8.h+7.w,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/launcher/logo.png'))),),
                    ),
                    elevation: 20,
                    bottomOpacity: 0,
                    backgroundColor: Colors.white.withOpacity(0.7),
                    shadowColor: Color(0xffFF5DB9),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.elliptical(1100, 500),
                          bottomLeft: Radius.elliptical(550, 350)),
                    )),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(left: 35.w, right: 35.w),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          backgroundColor: Colors.white),
                  onPressed: () {
                        SelectedProductsQuantityModel selectedProductsModel =
                            SelectedProductsQuantityModel();
                        selectedProductsModel.mealsIds = [];
                        selectedProductsModel.productsIds = [];
                        for (var pr in state.products) {
                          if (pr.quantity!=null && pr.quantity > 0) {
                            if (pr.isMarket == "true") {
                              selectedProductsModel.productsIds!.add(
                                  ProductSelection(
                                      id: pr.id!, quantity: pr.quantity!));
                            } else {
                              selectedProductsModel.mealsIds!.add(
                                  ProductSelection(
                                      id: pr.id!, quantity: pr.quantity!));
                            }
                          }
                        }
                        selectedProductsModel.studentId = widget.childId;
                        selectedProductsModel.dayId = widget.dayId;
                        BlocProvider.of<ProductsBloc>(context).add(
                            StoreDayBookedProductsEvent(
                                selectedProductsModel, widget.accessToken));
                      },
                  child: Text(
                    "PRODUCT_NAV_BOTTOM".tr(context),
                    style: TextStyle(fontSize: 15.sp, color: Colors.green),
                  ),
                ),
              ),
              body: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/bg.png'),
                          fit: BoxFit.cover)),
                  child: state.products.isEmpty
                      ? const SizedBox()
                      : ListView(children: [
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
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.products.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                      height: 18.h,
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
                                                    ))),
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
                                                  child: AutoSizeText(
                                                    state.products[index].name!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.sp,
                                                    ),
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
                                                        state.products[index]
                                                            .name!}\n${DateFormat('dd/MM/yyyy').format(DateTime.parse(state.products[index].restaurantDatedProduct!.availableDate!))}",
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 1.h, 0, 0),
                                              child: Text(
                                                toCurrencyString(
                                                    state
                                                        .products[index].price!,
                                                    trailingSymbol:
                                                        widget.currency,
                                                    useSymbolPadding: true),
                                                style: TextStyle(
                                                    fontSize: 11.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  1.w, 2.h, 0, 0),
                                              child: Container(
                                                color: Colors.white,
                                                height: 4.5.h,
                                                width: 21.w,
                                                child: state.products[index].isAvailableToBook==false?  ElevatedButton(onPressed: null, child: Text("DATED_BOOKED_NOT_AVAILABLE".tr(context))):Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: primaryColor)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (state
                                                                      .products[
                                                                          index]
                                                                      .quantity !=
                                                                  null &&
                                                              state
                                                                      .products[
                                                                          index]
                                                                      .quantity! >
                                                                  0) {
                                                            setState(() {
                                                              state
                                                                  .products[
                                                                      index]
                                                                  .quantity = state
                                                                      .products[
                                                                          index]
                                                                      .quantity! -
                                                                  1;
                                                            });
                                                          }
                                                        },
                                                        child: const Icon(
                                                            Icons.remove),
                                                      ),
                                                      SizedBox(
                                                        width: 1.w,
                                                      ),
                                                      Text(state.products[index]
                                                          .quantity==null?'0':state.products[index]
                                                          .quantity
                                                          .toString()),
                                                      SizedBox(
                                                        width: 1.w,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          if (state
                                                                      .products[
                                                                          index]
                                                                      .quantity ==
                                                                  null ||
                                                              state
                                                                      .products[
                                                                          index]
                                                                      .quantity! <=
                                                                  99) {
                                                            setState(() {
                                                              if (state
                                                                      .products[
                                                                          index]
                                                                      .quantity ==
                                                                  null) {
                                                                state
                                                                    .products[
                                                                        index]
                                                                    .quantity = 1;
                                                              } else {
                                                                state
                                                                    .products[
                                                                        index]
                                                                    .quantity = state
                                                                        .products[
                                                                            index]
                                                                        .quantity! +
                                                                    1;
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: const Icon(
                                                            Icons.add),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]),
                                        ],
                                      ));
                                }),
                        ])));
        }
      } else {
        return const SizedBox();
      }
    });
  }

  void showConfirmDialog1(BuildContext context, List<ProductModel> prs,
      String price, bool isWeekly) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("DIALOG_CONFIRMATION_TITLE".tr(context)),
          content: Text(
            "${"DIALOG_CONFIRMATION_CONTENT".tr(context)}$price,Do you accept to exceed the price",
            style: TextStyle(fontSize: 15.sp),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('DIALOG_CONFIRMATION_BUTTON1'.tr(context)),
              onPressed: () {
                SelectedProductsQuantityModel selectedProductsModel =
                    SelectedProductsQuantityModel();
                selectedProductsModel.mealsIds = [];
                selectedProductsModel.productsIds = [];
                for (var pr in prs) {
                  if (pr.quantity! > 0) {
                    if (pr.isMarket == "true") {
                      selectedProductsModel.productsIds!.add(
                          ProductSelection(id: pr.id!, quantity: pr.quantity!));
                    } else {
                      selectedProductsModel.mealsIds!.add(
                          ProductSelection(id: pr.id!, quantity: pr.quantity!));
                    }
                  }
                }
                selectedProductsModel.studentId = widget.childId;
                selectedProductsModel.dayId = widget.dayId;
                Navigator.of(context).pop(true);
                if (isWeekly) {
                  BlocProvider.of<ProductsBloc>(context).add(
                      StoreWeekProductsEvent(
                          selectedProductsModel, widget.accessToken));
                } else {
                  BlocProvider.of<ProductsBloc>(context).add(
                      StoreDayProductsEvent(
                          selectedProductsModel, widget.accessToken));
                }
              },
            ),
            ElevatedButton(
              child: Text('DIALOG_BUTTON_CANCEL'.tr(context)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
