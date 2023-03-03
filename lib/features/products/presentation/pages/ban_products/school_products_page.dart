import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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

class AddBannedProducts extends StatefulWidget {
  const AddBannedProducts({Key? key, required this.accessToken,required this.childId,required this.currency})
      : super(key: key);
  final String accessToken;
  final int childId;
  final String currency;

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<AddBannedProducts> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
      if (state is ErrorMsgState) {
        SnackBarMessage()
            .showErrorSnackBar(message: state.message, context: context);
      } else if (state is SuccessMsgState) {
        SnackBarMessage()
            .showSuccessSnackBar(message: state.message, context: context);
        BlocProvider.of<ProductsBloc>(context).add(GetAllBannedProductsEvent(widget.childId,widget.accessToken));
        Go.back(context);
      }
    }, builder: (context, state) {
      if (state is LoadingState) {
        return const Scaffold(body: LoadingWidget());
      } else if (state is LoadedProductsSchoolState) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: ElevatedButton(
              onPressed: () {
                SelectedProductsModel selectedProductsModel=SelectedProductsModel();
                selectedProductsModel.mealsId=[];
                selectedProductsModel.productsId=[];
                for (var pr in state.products) {
                  if (pr.selected) {
                    if (pr.isMarket == "true") {
                      selectedProductsModel.productsId!.add(pr.id!);
                    }
                    else
                      {
                        selectedProductsModel.mealsId!.add(pr.id!);
                      }
                  }
                }
                selectedProductsModel.id=widget.childId;
                BlocProvider.of<ProductsBloc>(context).add(StoreBannedProductsEvent(selectedProductsModel, widget.accessToken));
              },
              child: Text("PRODUCT_NAV_BOTTOM".tr(context)),
            ),
          ),
          appBar: AppBar(
            title: Text("SELECT_BANNED_PRODUCTS_TITLE".tr(context)),
          ),
          body: state.products.isEmpty
              ? const SizedBox()
              : GroupedListView<ProductModel, String>(
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
                              isMarket == "true" ? "MARKET_GROUP_VIEW".tr(context) : "RESTAURANT_GROUP_VIEW".tr(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.w400),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.41,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(1.w, 1.h, 0, 0),
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
                                  MediaQuery.of(context).size.width * 0.41,
                                  height: 9.h,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(1.w, 1.h, 0, 0),
                                    child: AutoSizeText(
                                      product.description ?? product.name!,
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
                                        EdgeInsets.fromLTRB(2.w, 2.h, 0, 0),
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            product.selected =
                                                !product.selected;
                                          });
                                        },
                                        child: product.selected
                                            ? Icon(
                                                Icons.check_box_outlined,
                                                size: 25.sp,
                                              )
                                            : Icon(
                                                Icons
                                                    .check_box_outline_blank_sharp,
                                                size: 25.sp,
                                              ))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                    // return ListTile(
                    //   minLeadingWidth: 25.w,
                    //   title:Text(state.schoolProducts.restaurant![index].name!,style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold),) ,
                    //   leading:state.schoolProducts.restaurant![index].image==null?Image.asset('assets/launcher/logo.png',scale: 15.0,):Image(image: NetworkImage(Network().baseUrl+state.schoolProducts.restaurant![index].image!),fit: BoxFit.fill,) ,
                    //   trailing:const Icon(Icons.delete_rounded) ,
                    //   subtitle:Text(state.schoolProducts.restaurant![index].price!) ,
                    // );
                  }),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
