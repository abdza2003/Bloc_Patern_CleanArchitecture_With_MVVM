import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:lottie/lottie.dart';
import 'package:school_cafteria/appBar.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/features/products/data/models/products_model.dart';
import 'package:school_cafteria/features/products/domain/entities/selected_products_quantity.dart';
import 'package:school_cafteria/features/products/presentation/pages/day_products/school_days_xd.dart';
import 'package:school_cafteria/scrollviewAppbar.dart';
import 'package:school_cafteria/test/app_bar_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/navigation.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../data/models/selected_products_quantity_model.dart';
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
  final dynamic accessToken;
  final dynamic childId;
  final dynamic dayId;
  final dynamic currency;
  final dynamic maxPrice;
  final dynamic dayName;
  final dynamic childName;
  final dynamic isWeekly;
  final dynamic daysCount;
  final dynamic weeklyBalance;

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<ProductSearch> {
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
      child:
          BlocConsumer<ProductsBloc, ProductsState>(listener: (context, state) {
        if (state is ErrorMsgState) {
          SnackBarMessage()
              .showErrorSnackBar(message: state.message, context: context);
        } else if (state is SuccessMsgState) {
          SnackBarMessage()
              .showSuccessSnackBar(message: state.message, context: context);
          BlocProvider.of<ProductsBloc>(context)
              .add(GetSchoolDaysEvent(widget.childId, widget.accessToken));

          if (!widget.isWeekly) {
            BlocProvider.of<ProductsBloc>(context).add(GetDayProductsEvent(
                widget.childId, widget.accessToken, widget.dayId!));
            Go.back(context);
          } else {
            Go.off(
                context,
                SchoolDays2(
                  accessToken: widget.accessToken,
                  childId: widget.childId,
                  currency: widget.currency,
                  childName: widget.childName,
                ));
          }
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
                  child: const LoadingWidget()));
        } else if (state is LoadedSchoolProductsByPriceState) {
          if (state.products.isEmpty) {
            return Scaffold(body: const NoPageFound());
          } else {
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
                  floatingActionButtonLocation:
                      AppLocalizations.of(context)!.locale!.languageCode != 'ar'
                          ? FloatingActionButtonLocation.endFloat
                          : FloatingActionButtonLocation.startFloat,
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: HexColor('#C53E5D'),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (widget.isWeekly) {
                        //ordering the products in terms of market or meal
                        SelectedProductsQuantityModel selectedProductsModel =
                            SelectedProductsQuantityModel();
                        selectedProductsModel.mealsIds = [];
                        selectedProductsModel.productsIds = [];
                        for (var pr in state.products) {
                          if (pr.quantity != null && pr.quantity > 0) {
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
                            StoreWeekProductsEvent(
                                selectedProductsModel, widget.accessToken));
                      } else {
                        //ordering the products in terms of market or meal
                        SelectedProductsQuantityModel selectedProductsModel =
                            SelectedProductsQuantityModel();
                        selectedProductsModel.mealsIds = [];
                        selectedProductsModel.productsIds = [];
                        for (var pr in state.products) {
                          if (pr.quantity != null && pr.quantity > 0) {
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
                            StoreDayProductsEvent(
                                selectedProductsModel, widget.accessToken));
                      }
                    },
                  ),
                  // bottomNavigationBar: Padding(
                  //   padding: EdgeInsets.only(left: 35.w, right: 35.w),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(30.0)),
                  //         backgroundColor: Colors.white),
                  //     onPressed: () {
                  //       if (widget.isWeekly) {
                  //         //ordering the products in terms of market or meal
                  //         SelectedProductsQuantityModel selectedProductsModel =
                  //             SelectedProductsQuantityModel();
                  //         selectedProductsModel.mealsIds = [];
                  //         selectedProductsModel.productsIds = [];
                  //         for (var pr in state.products) {
                  //           if (pr.quantity != null && pr.quantity > 0) {
                  //             if (pr.isMarket == "true") {
                  //               selectedProductsModel.productsIds!.add(
                  //                   ProductSelection(
                  //                       id: pr.id!, quantity: pr.quantity!));
                  //             } else {
                  //               selectedProductsModel.mealsIds!.add(ProductSelection(
                  //                   id: pr.id!, quantity: pr.quantity!));
                  //             }
                  //           }
                  //         }
                  //         selectedProductsModel.studentId = widget.childId;
                  //         selectedProductsModel.dayId = widget.dayId;
                  //         BlocProvider.of<ProductsBloc>(context).add(
                  //             StoreWeekProductsEvent(
                  //                 selectedProductsModel, widget.accessToken));
                  //       } else {
                  //         //ordering the products in terms of market or meal
                  //         SelectedProductsQuantityModel selectedProductsModel =
                  //             SelectedProductsQuantityModel();
                  //         selectedProductsModel.mealsIds = [];
                  //         selectedProductsModel.productsIds = [];
                  //         for (var pr in state.products) {
                  //           if (pr.quantity != null && pr.quantity > 0) {
                  //             if (pr.isMarket == "true") {
                  //               selectedProductsModel.productsIds!.add(
                  //                   ProductSelection(
                  //                       id: pr.id!, quantity: pr.quantity!));
                  //             } else {
                  //               selectedProductsModel.mealsIds!.add(ProductSelection(
                  //                   id: pr.id!, quantity: pr.quantity!));
                  //             }
                  //           }
                  //         }
                  //         selectedProductsModel.studentId = widget.childId;
                  //         selectedProductsModel.dayId = widget.dayId;
                  //         BlocProvider.of<ProductsBloc>(context).add(
                  //             StoreDayProductsEvent(
                  //                 selectedProductsModel, widget.accessToken));
                  //       }
                  //     },
                  //     child: Text(
                  //       "PRODUCT_NAV_BOTTOM".tr(context),
                  //       style: TextStyle(fontSize: 15.sp, color: Colors.green),
                  //     ),
                  //   ),
                  // ),
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
                          child: Container(
                            child: state.products.isEmpty
                                ? const SizedBox()
                                : ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            new BoxShadow(
                                              // spreadRadius: 0,
                                              offset: Offset(0, 0),
                                              color:
                                                  Colors.white.withOpacity(.4),
                                              blurRadius: 20.0,
                                            ),
                                          ],
                                        ),
                                        child: Card(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2.w),
                                          color: Colors.white.withOpacity(0.7),
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
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
                                      SizedBox(height: 1.h),
                                      Padding(
                                        padding: EdgeInsets.all(4.sp),
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (context, index) => Padding(
                                                    padding:
                                                        EdgeInsets.all(4.sp)),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
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
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                      color:
                                                          HexColor('#EA4B6F'),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: SizedBox(
                                                      // height: 25.h,
                                                      child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(2.w),
                                                        width: 35.w,
                                                        height: 24.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          border: Border.all(
                                                            color: HexColor(
                                                                '#C53E5D'),
                                                            width: 3,
                                                          ),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          // cacheManager: Base,
                                                          fit: BoxFit.cover,
                                                          imageUrl: Network()
                                                                  .baseUrl +
                                                              state
                                                                  .products[
                                                                      index]
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
                                                                        BorderRadius.circular(
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
                                                              ],
                                                            );
                                                          },
                                                          placeholder:
                                                              (context, url) =>
                                                                  Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(7),
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
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
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: .4
                                                                              .h),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width:
                                                                          25.w,
                                                                      height:
                                                                          5.6.h,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        boxShadow: [
                                                                          new BoxShadow(
                                                                            blurStyle:
                                                                                BlurStyle.outer,
                                                                            // spreadRadius: 0,
                                                                            offset:
                                                                                Offset(0, 0),

                                                                            color:
                                                                                Colors.black.withOpacity(1),
                                                                            blurRadius:
                                                                                15.0,
                                                                          ),
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.circular(30),
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(.57),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        toCurrencyString(
                                                                          '${state.products[index].price!}',
                                                                          trailingSymbol:
                                                                              widget.currency,
                                                                          useSymbolPadding:
                                                                              true,
                                                                        ),
                                                                        style: FontManager
                                                                            .kumbhSansBold
                                                                            .copyWith(
                                                                          fontSize:
                                                                              12.sp,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Opacity(
                                                                      opacity:
                                                                          .6,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 2.h),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Lottie.asset('assets/images/Desktop HD.json'),
                                                                            Text(
                                                                              'undefined image',
                                                                              textAlign: TextAlign.center,
                                                                              style: FontManager.dubaiRegular.copyWith(
                                                                                fontSize: 8.5.sp,
                                                                                color: Colors.white,
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
                                                            EdgeInsets.only(
                                                                top: 1.h),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 29.w,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            1.w,
                                                                            1.h,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    AutoSizeText(
                                                                  '${state.products[index].name!}',
                                                                  style: FontManager
                                                                      .kumbhSansBold
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  softWrap:
                                                                      true,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 29.w,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            1.w,
                                                                            1.h,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    AutoSizeText(
                                                                  '${state.products[index].description ?? state.products[index].name!}',
                                                                  style: FontManager
                                                                      .kumbhSansBold
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            .9),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 2.h)
                                                          ],
                                                        ),
                                                      ),
                                                      Column(children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(1.w,
                                                                  2.h, 0, 0),
                                                          child: Card(
                                                            elevation: 10,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          2.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: HexColor(
                                                                      '#924C89'),
                                                                  width: 2,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                color: HexColor(
                                                                    '#F7F4F4'),
                                                              ),
                                                              height: 6.h,
                                                              width: 24.w,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (state.products[index].quantity !=
                                                                                null &&
                                                                            state.products[index].quantity! >
                                                                                0) {
                                                                          setState(
                                                                              () {
                                                                            state.products[index].quantity =
                                                                                state.products[index].quantity! - 1;
                                                                          });
                                                                        }
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            4.w,
                                                                        height:
                                                                            5.h,
                                                                        child:
                                                                            Divider(
                                                                          color:
                                                                              HexColor('#C53E5D'),
                                                                          thickness:
                                                                              5.2,
                                                                        ),
                                                                      )

                                                                      /*  Icon(
                                                                Icons.remove,
                                                                fill: 1,
                                                                size: 20.sp,
                                                                color: HexColor(
                                                                    '#C53E5D'),
                                                              ), */
                                                                      ),
                                                                  SizedBox(
                                                                    width: 1.w,
                                                                  ),
                                                                  Text(
                                                                    state.products[index].quantity ==
                                                                            null
                                                                        ? '0'
                                                                        : state
                                                                            .products[index]
                                                                            .quantity
                                                                            .toString(),
                                                                    style: FontManager
                                                                        .impact
                                                                        .copyWith(
                                                                      color: HexColor(
                                                                          '#924C89'),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 1.w,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (state.products[index].quantity ==
                                                                              null ||
                                                                          state.products[index].quantity! <=
                                                                              99) {
                                                                        setState(
                                                                            () {
                                                                          if (state.products[index].quantity ==
                                                                              null) {
                                                                            state.products[index].quantity =
                                                                                1;
                                                                          } else {
                                                                            state.products[index].quantity =
                                                                                state.products[index].quantity! + 1;
                                                                          }
                                                                        });
                                                                      }
                                                                    },
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          4.w,
                                                                      height:
                                                                          5.h,
                                                                      child:
                                                                          ImageIcon(
                                                                        AssetImage(
                                                                          'assets/images/plus-symbol-button.png',
                                                                        ),
                                                                        size: 15
                                                                            .sp,
                                                                        color: HexColor(
                                                                            '#70972C'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ]),
                                                    ],
                                                  )),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          }
        } else {
          return const SizedBox();
        }
      }),
    );
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
