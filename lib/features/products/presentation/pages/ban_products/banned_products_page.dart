import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:school_cafteria/appBar.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:school_cafteria/features/products/presentation/pages/ban_products/school_products_page.dart';
import 'package:school_cafteria/scrollviewAppbar.dart';
import 'package:school_cafteria/test/app_bar_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/navigation.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/confirmation_dialog.dart';
import '../../no_product_found.dart';

class BannedProducts extends StatefulWidget {
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
  State<BannedProducts> createState() => _BannedProductsState();
}

class _BannedProductsState extends State<BannedProducts> {
  final _scrollController = ScrollController();
  double maxScroll = 0;
  double currentScroll = 0;

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    maxScroll = _scrollController.position.maxScrollExtent;
    currentScroll = _scrollController.offset;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

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
            .add(GetAllBannedProductsEvent(widget.childId, widget.accessToken));
      }
    }, buildWhen: (productsBloc, productsState) {
      if (productsState is LoadedBannedState) {
        return true;
      } else {
        return false;
      }
    }, builder: (context, state) {
      if (state is LoadingState) {
        return Scaffold(
            body: Container(
          decoration: BoxDecoration(
            color: HexColor('#51093C'),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstIn,
              ),
              image: const AssetImage(
                'assets/images/back3.png',
              ),
            ),
          ),
          child: const LoadingWidget(),
        ));
      } else if (state is LoadedBannedState) {
        return Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: HexColor('#51093C'),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstIn,
              ),
              image: const AssetImage(
                'assets/images/back3.png',
              ),
            ),
          ),
          child: Scaffold(
            //float button Location Adjust in terms of language
            floatingActionButtonLocation:
                AppLocalizations.of(context)!.locale!.languageCode != 'ar'
                    ? FloatingActionButtonLocation.endFloat
                    : FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: HexColor('#C53E5D'),
              onPressed: () {
                BlocProvider.of<ProductsBloc>(context).add(
                    GetAllSchoolProductsEvent(
                        widget.childId, widget.accessToken));
                Go.to(
                    context,
                    AddBannedProducts(
                      accessToken: widget.accessToken,
                      childId: widget.childId,
                      currency: widget.currency,
                    ));
              },
              child: const Icon(Icons.add),
            ),
            body: state.products.isEmpty
                ? const NoPageFound()
                : Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: HexColor('#51093C'),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.dstIn,
                        ),
                        image: const AssetImage(
                          'assets/images/back3.png',
                        ),
                      ),
                    ),
                    child: CustomScrollView(
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 22.2.h,
                          pinned: true,
                          centerTitle: true,
                          scrolledUnderElevation: 10,
                          backgroundColor: currentScroll < 16.h
                              ? Colors.transparent
                              : primaryColor,
                          title: currentScroll > 16.h
                              ? Text(
                                  'YES MEDRESE',
                                  style: FontManager.impact.copyWith(
                                      color: Colors.white, letterSpacing: 2),
                                )
                              : const SizedBox(),
                          flexibleSpace: scrollviewAppbar(),
                        ),
                        SliverToBoxAdapter(
                          child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                SizedBox(
                                  height: 2.h,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      new BoxShadow(
                                        // spreadRadius: 0,
                                        offset: Offset(0, 0),
                                        color: Colors.white.withOpacity(.4),
                                        blurRadius: 20.0,
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    color: Colors.white.withOpacity(0.7),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: SizedBox(
                                      height: 6.h,
                                      width: 66.w,
                                      child: Center(
                                        child: Text(
                                          "PRODUCTS_LIST".tr(context),
                                          textAlign: TextAlign.center,
                                          style: FontManager.kumbhSansBold
                                              .copyWith(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.w),
                                  child: ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          Padding(
                                              padding: EdgeInsets.all(4.sp)),
                                      // physics: const NeverScrollableScrollPhysics(),
                                      itemCount: state.products.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            border: Border.all(
                                              color: HexColor('#90579B'),
                                              width: 2,
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                color: HexColor('#EA4B6F'),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: SizedBox(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(2.w),
                                                    width: 35.w,
                                                    height: 25.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                        color:
                                                            HexColor('#C53E5D'),
                                                        width: 3,
                                                      ),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      // cacheManager: Base,
                                                      fit: BoxFit.cover,
                                                      imageUrl: Network()
                                                              .baseUrl +
                                                          state.products[index]
                                                              .image!,
                                                      imageBuilder: (context,
                                                          imageProvider) {
                                                        return Stack(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            28),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          .5.h),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 25.w,
                                                              height: 5.6.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  new BoxShadow(
                                                                    blurStyle:
                                                                        BlurStyle
                                                                            .outer,
                                                                    // spreadRadius: 0,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            0),

                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            1),
                                                                    blurRadius:
                                                                        15.0,
                                                                  ),
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        .57),
                                                              ),
                                                              child: Text(
                                                                toCurrencyString(
                                                                  '${state.products[index].price!}',
                                                                  trailingSymbol:
                                                                      widget
                                                                          .currency,
                                                                  useSymbolPadding:
                                                                      true,
                                                                ),
                                                                style: FontManager
                                                                    .kumbhSansBold
                                                                    .copyWith(
                                                                  fontSize:
                                                                      12.sp,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(7),
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Image.asset(
                                                                  'assets/launcher/logo.png'),
                                                              CircularProgressIndicator(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Container(
                                                          // color: Colors.red,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.w,
                                                                  vertical:
                                                                      1.h),
                                                          child: Opacity(
                                                            opacity: 1,
                                                            child: Stack(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top: .4
                                                                              .h),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: 25.w,
                                                                  height: 5.6.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    boxShadow: [
                                                                      new BoxShadow(
                                                                        blurStyle:
                                                                            BlurStyle.outer,
                                                                        // spreadRadius: 0,
                                                                        offset: Offset(
                                                                            0,
                                                                            0),

                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(1),
                                                                        blurRadius:
                                                                            15.0,
                                                                      ),
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            .57),
                                                                  ),
                                                                  child: Text(
                                                                    toCurrencyString(
                                                                      '${state.products[index].price!}',
                                                                      trailingSymbol:
                                                                          widget
                                                                              .currency,
                                                                      useSymbolPadding:
                                                                          true,
                                                                    ),
                                                                    style: FontManager
                                                                        .kumbhSansBold
                                                                        .copyWith(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Opacity(
                                                                  opacity: .6,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                2.h),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Lottie.asset(
                                                                            'assets/images/Desktop HD.json'),
                                                                        Text(
                                                                          'undefined image',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: FontManager
                                                                              .dubaiRegular
                                                                              .copyWith(
                                                                            fontSize:
                                                                                8.5.sp,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  /* 
                                        toCurrencyString(
                                                '${state.products[index].price!}',
                                                trailingSymbol: currency,
                                                useSymbolPadding: true,
                                              ),
                                         */
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 2.h),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 1.w,
                                                        ),
                                                        Container(
                                                          width: 29.w,
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0.w,
                                                                    1.h, 0, 0),
                                                            child: AutoSizeText(
                                                              state
                                                                  .products[
                                                                      index]
                                                                  .name!,
                                                              style: FontManager
                                                                  .kumbhSansBold
                                                                  .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.sp,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 29.w,
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0.w,
                                                                    1.h, 0, 0),
                                                            child: AutoSizeText(
                                                              state
                                                                      .products[
                                                                          index]
                                                                      .description ??
                                                                  state
                                                                      .products[
                                                                          index]
                                                                      .name!,
                                                              style: FontManager
                                                                  .kumbhSansBold
                                                                  .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 12.sp,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        .9),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.h),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 3.h),
                                                    // margin:
                                                    //     EdgeInsets.only(bottom: 12.h),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  HexColor(
                                                                      '#F7F4F4'),
                                                              fixedSize: Size
                                                                  .fromHeight(
                                                                      6.h),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              )),
                                                      onPressed: () {
                                                        confirmationDialog(
                                                            context, () {
                                                          BlocProvider.of<
                                                                      ProductsBloc>(
                                                                  context)
                                                              .add(DeleteBannedProductsEvent(
                                                                  state
                                                                      .products[
                                                                          index]
                                                                      .id!,
                                                                  widget
                                                                      .childId,
                                                                  widget
                                                                      .accessToken));
                                                          setState(() {
                                                            currentScroll = 0;
                                                          });
                                                        },
                                                            "PRODUCT_REMOVE_BAN_CONFIRMATION"
                                                                .tr(context));
                                                      },
                                                      child: Text(
                                                        "PRODUCTS_LIST_UNBLOCK"
                                                            .tr(context),
                                                        style: FontManager
                                                            .impact
                                                            .copyWith(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: HexColor(
                                                              '#C53E5D'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
