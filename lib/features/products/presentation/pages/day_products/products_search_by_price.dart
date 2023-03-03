import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/features/products/data/models/products_model.dart';
import 'package:school_cafteria/features/products/data/models/selected_products_model.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/navigation.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/products_bloc.dart';
import '../../no_product_found.dart';
class ProductSearch extends StatefulWidget {
  const ProductSearch(
      {Key? key,
      required this.accessToken,
      required this.childId,
      required this.currency,
      required this.maxPrice,
      required this.dayId,
      required this.dayName,
      required this.isWeekly,
      required this.daysCount,
      this.weeklyBalance,
      required this.childName})
      : super(key: key);
  final String accessToken;
  final int childId;
  final int? dayId;
  final String currency;
  final String? maxPrice;
  final String? dayName;
  final String childName;
  final bool isWeekly;
  final int? daysCount;
  final dynamic weeklyBalance;

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<ProductSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
      if (state is ErrorMsgState) {
        SnackBarMessage()
            .showErrorSnackBar(message: state.message, context: context);
      } else if (state is SuccessMsgState) {
        Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.green,
            textColor: Colors.white);
        // SnackBarMessage()
        //     .showSuccessSnackBar(message: state.message, context: context);
        BlocProvider.of<ProductsBloc>(context)
            .add(GetSchoolDaysEvent(widget.childId, widget.accessToken));

        if (widget.dayId != null) {
          BlocProvider.of<ProductsBloc>(context).add(GetDayProductsEvent(
              widget.childId, widget.accessToken, widget.dayId!));
        }
        Go.back(context);
        //Go.off(context, DayProducts(accessToken: widget.accessToken,childId: widget.childId,currency: widget.currency, dayId: widget.dayId, dayName: widget.dayName,));
      }
    }, builder: (context, state) {
      if (state is LoadingState) {
        return const Scaffold(body: LoadingWidget());
      } else if (state is LoadedSchoolProductsByPriceState) {
        if (state.products.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.isWeekly
                  ? "Select Products for Entier Week"
                  : "PRODUCTS_BY_PRICE_TITLE_NOT_FOUND".tr(context) +
                      toCurrencyString(widget.maxPrice!,
                          trailingSymbol: widget.currency,
                          useSymbolPadding: true)),
            ),
            body: const NoPageFound(),
          );
        } else {
          return Scaffold(
              resizeToAvoidBottomInset:false,
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: ElevatedButton(
                onPressed: () {
                  if (widget.isWeekly) {
                    double max = 0;
                    for (var pr in state.products) {
                      if (pr.selected) {
                        max = double.parse(pr.price!) + max;
                      }
                    }
                    if (max * widget.daysCount! >
                        double.parse(widget.weeklyBalance)) {
                      showConfirmDialog(
                          context,
                          state.products,
                          (max * widget.daysCount!).toString(),
                          widget.isWeekly);
                    } else {
                      SelectedProductsModel selectedProductsModel =
                          SelectedProductsModel();
                      selectedProductsModel.mealsId = [];
                      selectedProductsModel.productsId = [];
                      for (var pr in state.products) {
                        if (pr.selected) {
                          if (pr.isMarket == "true") {
                            selectedProductsModel.productsId!.add(pr.id!);
                          } else {
                            selectedProductsModel.mealsId!.add(pr.id!);
                          }
                        }
                      }
                      selectedProductsModel.id = widget.childId;
                      selectedProductsModel.dayId = widget.dayId;
                      BlocProvider.of<ProductsBloc>(context).add(
                          StoreWeekProductsEvent(
                              selectedProductsModel, widget.accessToken));
                    }
                  } else {
                    double max = 0;
                    for (var pr in state.products) {
                      if (pr.selected) {
                        max = double.parse(pr.price!) + max;
                      }
                    }
                    if (max > double.parse(widget.maxPrice!)) {
                      showConfirmDialog(context, state.products, max.toString(),
                          widget.isWeekly);
                    } else {
                      SelectedProductsModel selectedProductsModel =
                          SelectedProductsModel();
                      selectedProductsModel.mealsId = [];
                      selectedProductsModel.productsId = [];
                      for (var pr in state.products) {
                        if (pr.selected) {
                          if (pr.isMarket == "true") {
                            selectedProductsModel.productsId!.add(pr.id!);
                          } else {
                            selectedProductsModel.mealsId!.add(pr.id!);
                          }
                        }
                      }
                      selectedProductsModel.id = widget.childId;
                      selectedProductsModel.dayId = widget.dayId;
                      BlocProvider.of<ProductsBloc>(context).add(
                          StoreDayProductsEvent(
                              selectedProductsModel, widget.accessToken));
                    }
                  }
                },
                child: Text("PRODUCT_NAV_BOTTOM".tr(context)),
              ),
            ),
            appBar: AppBar(
              title: Text(widget.isWeekly
                  ? "Select Products for Entier Week"
                  : "PRODUCTS_BY_PRICE_TITLE".tr(context) +
                      toCurrencyString(widget.maxPrice!,
                          trailingSymbol: widget.currency,
                          useSymbolPadding: true)),
            ),
            body: state.products.isEmpty
                ? const SizedBox()
                : Column(
                  children: [
                    Expanded(
                      flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Padding(
                            padding: EdgeInsets.only(left: 10.w,right:10.w ),
                            child: TextFormField(
                              onChanged: (String search){

                              },
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide()
                                ),
                                focusedBorder: OutlineInputBorder(),
                                hintText: "Search by Name",
                              ),

                            ),
                          ),
                        )),
                    Expanded(
                      flex: 10,
                      child: GroupedListView<ProductModel, String>(
                          elements: state.products,
                          groupBy: (product) => product.isMarket,
                          // itemComparator: (item1, item2) => item1.isMarket==item2.isMarket, // optional
                          useStickyGroupSeparators: true,
                          // optional
                          groupSeparatorBuilder: (String isMarket) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    isMarket == "true"
                                        ? Icon(
                                            Icons.home_filled,
                                            color: primaryColor,
                                          )
                                        : Icon(
                                            Icons.restaurant,
                                            color: primaryColor,
                                          ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      //isMarket,
                                      isMarket == "true"
                                          ? "MARKET_GROUP_VIEW".tr(context)
                                          : "RESTAURANT_GROUP_VIEW".tr(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                          itemBuilder: (context, Product product) {
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
                                              child: product.image == null
                                                  ? Image.asset(
                                                      'assets/launcher/logo.png',
                                                      scale: 15.0,
                                                    )
                                                  : Image(
                                                      image: NetworkImage(
                                                          Network().baseUrl +
                                                              product.image!),
                                                      fit: BoxFit.fill,
                                                    )),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(context).size.width *
                                                      0.41,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    1.w, 1.h, 0, 0),
                                                child: AutoSizeText(
                                                  product.name!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(context).size.width *
                                                      0.41,
                                              height: 9.h,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    1.w, 1.h, 0, 0),
                                                child: AutoSizeText(
                                                  product.description ??
                                                      product.name!,
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
                                            padding:
                                                EdgeInsets.fromLTRB(0, 1.h, 0, 0),
                                            child: Text(
                                              toCurrencyString(product.price!,
                                                  trailingSymbol: widget.currency,
                                                  useSymbolPadding: true),
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.fromLTRB(1.w, 2.h, 0, 0),
                                              child: SizedBox(
                                                  height: 5.h,
                                                  width: 19.w,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color:primaryColor )),
                            child:Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    if(product.quantity!=null && product.quantity!>0)
                                      {
                                        setState(() {
                                          product.quantity=product.quantity!-1;
                                        });

                                      }
                                  },
                                  child: const Icon(Icons.remove),),
                                SizedBox(width: 1.w,),
                                Text(product.quantity.toString()),
                                SizedBox(width: 1.w,),
                                InkWell(
                                  onTap: (){
                                    if(product.quantity==null || product.quantity!<=99)
                                    {
                                      setState(() {
                                        if(product.quantity==null)
                                          {
                                            product.quantity=1;
                                          }
                                        else {
                                          product.quantity=product.quantity!+1;
                                        }
                                      });

                                    }
                                  },
                                  child: const Icon(Icons.add),),

                              ],
                            ) ,
                                                    ),
                                                  ),
                             )
                                        ]),
                                      ],
                                    )));
                            // return ListTile(
                            //   minLeadingWidth: 25.w,
                            //   title:Text(state.schoolProducts.restaurant![index].name!,style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold),) ,
                            //   leading:state.schoolProducts.restaurant![index].image==null?Image.asset('assets/launcher/logo.png',scale: 15.0,):Image(image: NetworkImage(Network().baseUrl+state.schoolProducts.restaurant![index].image!),fit: BoxFit.fill,) ,
                            //   trailing:const Icon(Icons.delete_rounded) ,
                            //   subtitle:Text(state.schoolProducts.restaurant![index].price!) ,
                            // );
                          }),
                    ),
                  ],
                ),
          );
        }
      } else {
        return const SizedBox();
      }
    });
  }

  void showConfirmDialog(BuildContext context, List<ProductModel> prs,
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
                SelectedProductsModel selectedProductsModel =
                    SelectedProductsModel();
                selectedProductsModel.mealsId = [];
                selectedProductsModel.productsId = [];
                for (var pr in prs) {
                  if (pr.selected) {
                    if (pr.isMarket == "true") {
                      selectedProductsModel.productsId!.add(pr.id!);
                    } else {
                      selectedProductsModel.mealsId!.add(pr.id!);
                    }
                  }
                }
                selectedProductsModel.id = widget.childId;
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
