import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:school_cafteria/scrollviewAppbar.dart';
import 'package:school_cafteria/test/app_bar_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/network/api.dart';

class HistoryProductsPage extends StatefulWidget {
  const HistoryProductsPage(
      {Key? key,
      required this.currency,
      required this.childImage,
      required this.date,
      required this.invoiceNum})
      : super(key: key);
  final String currency;
  final String childImage;
  final String date;
  final String invoiceNum;

  @override
  State<HistoryProductsPage> createState() => _HistoryProductsPageState();
}

class _HistoryProductsPageState extends State<HistoryProductsPage> {
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
    return BlocBuilder<ProductsBloc, ProductsState>(
        buildWhen: (productsBloc, productsState) {
      if (productsState is LoadedHistoryProductsState) {
        return true;
      } else {
        return false;
      }
    }, builder: (context, state) {
      if (state is LoadedHistoryProductsState) {
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
            body: Container(
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
                            'MEDRESE',
                            style: FontManager.impact.copyWith(
                                color: Colors.white, letterSpacing: 2),
                          )
                        : const SizedBox(),
                    flexibleSpace: scrollviewAppbar(),
                  ),
                  SliverToBoxAdapter(
                    child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
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
                                height: 7.h,
                                width: 80.w,
                                child: Center(
                                    child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "INVOICE_PRODUCTS_NUMBER".tr(context) +
                                            '   ${widget.invoiceNum}',
                                        style:
                                            FontManager.segoeRegular.copyWith(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.date,
                                        style:
                                            FontManager.segoeRegular.copyWith(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: state.historyProduct.isNotEmpty,
                            replacement: Container(
                              height: 60.h,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                      'assets/images/NEW sin movs.json',
                                      width: 70.w),
                                  Text(
                                    'Empty List',
                                    style: FontManager.kumbhSansBold.copyWith(
                                        fontSize: 15.sp, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(5.sp),
                              child: ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      Padding(padding: EdgeInsets.all(4.sp)),
                                  itemCount: state.historyProduct.length,
                                  itemBuilder: (context, index) {
                                    return Container(
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
                                        /* 
                            state.historyProduct[index]
                                                      .product!.image
                             */
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
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color: HexColor('#C53E5D'),
                                                    width: 3,
                                                  ),
                                                ),
                                                child: CachedNetworkImage(
                                                  // cacheManager: Base,
                                                  fit: BoxFit.cover,
                                                  imageUrl: Network().baseUrl +
                                                      state
                                                          .historyProduct[index]
                                                          .product!
                                                          .image,
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        28),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: .5.h),
                                                          alignment:
                                                              Alignment.center,
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
                                                                offset: Offset(
                                                                    0, 0),

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
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    .57),
                                                          ),
                                                          child: Text(
                                                            toCurrencyString(
                                                              '${state.historyProduct[index].price!}',
                                                              trailingSymbol:
                                                                  widget
                                                                      .currency,
                                                              useSymbolPadding:
                                                                  true,
                                                            ),
                                                            style: FontManager
                                                                .kumbhSansBold
                                                                .copyWith(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(7),
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Image.asset(
                                                              'assets/launcher/logo.png'),
                                                          CircularProgressIndicator(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Container(
                                                      // color: Colors.red,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w,
                                                              vertical: 1.h),
                                                      child: Opacity(
                                                        opacity: 1,
                                                        child: Stack(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top:
                                                                          .4.h),
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
                                                                  '${state.historyProduct[index].price!}',
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
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 2
                                                                            .h),
                                                                child: Column(
                                                                  children: [
                                                                    Lottie.asset(
                                                                        'assets/images/Desktop HD.json'),
                                                                    Text(
                                                                      'undefined image',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: FontManager
                                                                          .dubaiRegular
                                                                          .copyWith(
                                                                        fontSize:
                                                                            8.5.sp,
                                                                        color: Colors
                                                                            .white,
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
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 49.w,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0.w, 1.h, 0, 0),
                                                        child: AutoSizeText(
                                                          '${state.historyProduct[index].product!.name!}',
                                                          style: FontManager
                                                              .kumbhSansBold
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 12.sp,
                                                            color: Colors.white
                                                                .withOpacity(1),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 49.w,
                                                      // height: 9.h,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0.w, 1.h, 0, 0),
                                                        child: AutoSizeText(
                                                          state
                                                                  .historyProduct[
                                                                      index]
                                                                  .product!
                                                                  .description ??
                                                              state
                                                                  .historyProduct[
                                                                      index]
                                                                  .product!
                                                                  .name!,
                                                          style: FontManager
                                                              .kumbhSansBold
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 12.sp,
                                                            color: Colors.white
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
        );
      } else {
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
      }
    });
  }
}
