import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/network/api.dart';

class HistoryProductsPage extends StatelessWidget {
  const HistoryProductsPage(
      {Key? key,
        required this.currency,
        required this.childImage, required this.date, required this.invoiceNum
      })
      : super(key: key);
  final String currency;
  final String childImage;
  final String date;
  final String invoiceNum;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
        buildWhen: (productsBloc, productsState) {
      if (productsState is LoadedHistoryProductsState) {
        return true;
      } else {
        return false;
      }
    }, builder: (context, state) {
      if (state is LoadedHistoryProductsState) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(10.h + 10.w),
            child: AppBar(
                flexibleSpace: Padding(
                  padding: EdgeInsets.only(top: 5.h, right: 0.w),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,textDirection: TextDirection.ltr,
                    children: [

                      Container(
                        height: 7.h + 7.w,
                        width: 42.w,
                        decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage(
                                'assets/launcher/logo.png'))),),
                      SizedBox(
                        //height: 15.h,
                        width: 30.w,
                        child: Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child:Image(
                                  image:NetworkImage(Network().baseUrl +childImage,scale: 1.5))),
                        ),
                      ),
                    ],
                  ),
                ),
                elevation: 20,
                bottomOpacity: 0,
                backgroundColor: Colors.white.withOpacity(0.7),
                shadowColor: const Color(0xffFF5DB9),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.elliptical(1100, 500),
                      bottomLeft: Radius.elliptical(550, 350)
                  ),
                )),
          ),
          body: Container(
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
                    width: 80.w,
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("INVOICE_PRODUCTS_NUMBER".tr(context)+ invoiceNum,
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700)),
                                    Text(date,
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700)),

                            ],
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
                child: ListView.builder(
                    itemCount: state.historyProduct.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 7.h + 20.w,
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
                                    child: state.historyProduct[index]
                                        .product!.image ==
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
                                            image: NetworkImage(Network().baseUrl + state.historyProduct[index]
                                                .product!.image!),
                                            width: 35.w,
                                          )),
                                    ))),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 1.w,
                                ),
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width *
                                      0.37,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.w, 1.h, 0, 0),
                                    child: AutoSizeText(
                                      state.historyProduct[index]
                                          .product!.name!,
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
                                      0.37,
                                  height: 9.h,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.w, 1.h, 0, 0),
                                    child: AutoSizeText(
                                      state.historyProduct[index]
                                          .product!.description ??
                                          state.historyProduct[index]
                                              .product!.name!,
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
                                SizedBox(
                                  width: 1.w,
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(0, 1.h, 0, 0),
                                  child: Text(
                                    toCurrencyString(
                                        state.historyProduct[index]
                                            .product!.price!,
                                        trailingSymbol: currency,
                                        useSymbolPadding: true),
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ]),
          ),
        );
      } else {
        return Scaffold(body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeat,
                    image: AssetImage('assets/images/bg.png'))),
            child: const LoadingWidget()));
      }
    });
  }
}
