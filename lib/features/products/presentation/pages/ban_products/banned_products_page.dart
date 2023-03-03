import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:school_cafteria/features/products/presentation/pages/ban_products/school_products_page.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/navigation.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/util/snackbar_message.dart';

class BannedProducts extends StatelessWidget {
  const BannedProducts(
      {Key? key,
      required this.accessToken,
      required this.childId,
      required this.currency})
      : super(key: key);
  final String accessToken;
  final int childId;
  final String currency;

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
        BlocProvider.of<ProductsBloc>(context)
            .add(GetAllBannedProductsEvent(childId, accessToken));
      }
    },buildWhen: (productsBloc, productsState) {
      if(productsState is LoadedBannedState )
      {
        return true;
      }
      else {
        return false;
      }
    }, builder: (context, state) {
      if (state is LoadingState) {
        return const Scaffold(body: LoadingWidget());
      } else if (state is LoadedBannedState) {
        return Scaffold(
          appBar: AppBar(
            title: Text("BANNED_PRODUCTS_TITLE".tr(context)),
          ),
          floatingActionButtonLocation: AppLocalizations.of(context)!.locale!.languageCode!='ar'?FloatingActionButtonLocation.endFloat:FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<ProductsBloc>(context)
                  .add(GetAllSchoolProductsEvent(childId, accessToken));
              Go.to(
                  context,
                  AddBannedProducts(
                    accessToken: accessToken,
                    childId: childId,
                    currency: currency,
                  ));
            },
            child: const Icon(Icons.add),
          ),
          body: state.products.isEmpty
              ?  Center(
                  child: Text("BANNED_PRODUCTS_NOT_FOUND".tr(context)),
                )
              : ListView.builder(
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
                                          image: NetworkImage(
                                              Network().baseUrl +
                                                  state.products[index].image!),
                                          fit: BoxFit.fill,
                                        )),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(width: 1.w,),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.41,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0.w, 1.h, 0, 0),
                                    child: AutoSizeText(
                                      state.products[index].name!,
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
                                        EdgeInsets.fromLTRB(0.w, 1.h, 0, 0),
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
                                SizedBox(width: 1.w,),
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
                                SizedBox(width: 2.w,),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0.w, 2.h, 0, 0),
                                    child: InkWell(
                                        onTap: () {
                                          BlocProvider.of<ProductsBloc>(context)
                                              .add(DeleteBannedProductsEvent(
                                                  state.products[index].id!,
                                                  childId,
                                                  accessToken));
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
                  }),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
