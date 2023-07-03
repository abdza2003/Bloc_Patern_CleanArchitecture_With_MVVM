import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as date;
import 'package:lottie/lottie.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:school_cafteria/features/products/presentation/pages/history/invoice_products.dart';
import 'package:school_cafteria/loadin_fade.dart';
import 'package:school_cafteria/scrollviewAppbar.dart';
import 'package:school_cafteria/test/app_bar_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/network/api.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage(
      {Key? key,
      required this.childImage,
      required this.accessToken,
      required this.childId,
      required this.currencyName})
      : super(key: key);
  final String childImage;
  final String accessToken;
  final int childId;
  final String currencyName;
  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
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
    fromDateController.text = ""; //set the initial value of text field
    toDateController.text = ""; //set the initial value of text field
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
        buildWhen: (productsBloc, productsState) {
      if (productsState is LoadedInvoicesState) {
        return true;
      } else {
        return false;
      }
    }, builder: (context, state) {
      if (state is LoadedInvoicesState) {
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
              body: Stack(
            children: [
              Container(
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
                  // physics: const BouncingScrollPhysics(),
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
                        child: state.invoices.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'assets/images/NEW sin movs.json',
                                      height: 40.h,
                                    ),
                                    Text(
                                      "INVOICE_NO_HISTORY".tr(context),
                                      style: FontManager.kumbhSansBold.copyWith(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Container(
                                    // padding: EdgeInsets.symmetric(horizontal: ),
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: SizedBox(
                                        width: 100.w,
                                        height: 4.h + 5.w,
                                        child: Form(
                                          key: formKey,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  width: 40.w,
                                                  child: Center(
                                                    child: TextFormField(
                                                      style: FontManager
                                                          .kumbhSansBold
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.sp),
                                                      validator: (value) =>
                                                          value!.isEmpty
                                                              ? "REQUIRED_FIELD"
                                                                  .tr(context)
                                                              : null,
                                                      readOnly: true,
                                                      controller:
                                                          fromDateController,
                                                      onTap: () async {
                                                        DateTime? pickedDate =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(), //get today's date
                                                                firstDate: DateTime(
                                                                    2000), //DateTime.now()
                                                                lastDate:
                                                                    DateTime(
                                                                        2101));

                                                        if (pickedDate !=
                                                            null) {
                                                          String formattedDate =
                                                              date.DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      pickedDate);
                                                          setState(() {
                                                            fromDateController
                                                                    .text =
                                                                formattedDate; //
                                                          });
                                                        } else {
                                                          if (kDebugMode) {
                                                            print(
                                                                "Date is not selected");
                                                          }
                                                        }
                                                      },
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "PAYMENTS_PAGE_CHOOSE_DATE1"
                                                                .tr(context),
                                                        hintStyle: FontManager
                                                            .kumbhSansBold
                                                            .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                      ),
                                                    ),
                                                  )),
                                              const VerticalDivider(
                                                thickness: .9,
                                                width: 5,
                                                color: Colors.black,
                                              ),
                                              Container(
                                                  width: 40.w,
                                                  child: Center(
                                                    child: TextFormField(
                                                      style: FontManager
                                                          .kumbhSansBold
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.sp),
                                                      validator: (value) =>
                                                          value!.isEmpty
                                                              ? "REQUIRED_FIELD"
                                                                  .tr(context)
                                                              : null,
                                                      readOnly: true,
                                                      controller:
                                                          toDateController,
                                                      onTap: () async {
                                                        DateTime? pickedDate =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(), //get today's date
                                                                firstDate: DateTime(
                                                                    2000), //DateTime.now()
                                                                lastDate:
                                                                    DateTime(
                                                                        2101));

                                                        if (pickedDate !=
                                                            null) {
                                                          String formattedDate =
                                                              date.DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      pickedDate);

                                                          setState(() {
                                                            toDateController
                                                                    .text =
                                                                formattedDate;
                                                          });
                                                        } else {
                                                          if (kDebugMode) {
                                                            print(
                                                                "Date is not selected");
                                                          }
                                                        }
                                                      },
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "PAYMENTS_PAGE_CHOOSE_DATE2"
                                                                .tr(context),
                                                        hintStyle: FontManager
                                                            .kumbhSansBold
                                                            .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                      ),
                                                    ),
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      BlocProvider.of<
                                                                  ProductsBloc>(
                                                              context)
                                                          .add(GetInvoicesEvent(
                                                              widget.childId,
                                                              widget
                                                                  .accessToken,
                                                              fromDateController
                                                                  .text,
                                                              toDateController
                                                                  .text));
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.search,
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  SizedBox(
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: state.invoices.length,
                                          itemBuilder: (context, index) {
                                            return SizedBox(
                                              height: 10.h,
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "INVOICE_DATE"
                                                            .tr(context),
                                                        style: FontManager
                                                            .kumbhSansBold
                                                            .copyWith(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    ProductsBloc>(
                                                                context)
                                                            .add(GetHistoryProductsEvent(
                                                                state
                                                                    .invoices[index] // count
                                                                    .id!,
                                                                widget.accessToken));
                                                        Go.to(
                                                            context,
                                                            HistoryProductsPage(
                                                                currency: widget
                                                                    .currencyName,
                                                                childImage: widget
                                                                    .childImage,
                                                                date: date.DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(DateTime.parse(state
                                                                        .invoices[index] // count
                                                                        .date!)),
                                                                invoiceNum: state
                                                                    .invoices[index] // count
                                                                    .referenceCode!));
                                                      },
                                                      child: Card(
                                                          elevation: 10,
                                                          color: Colors.white
                                                              .withOpacity(.9),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              30,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              date.DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(DateTime
                                                                      .parse(state
                                                                          .invoices[index] // count
                                                                          .date!)),
                                                              style: FontManager
                                                                  .impact
                                                                  .copyWith(
                                                                color: HexColor(
                                                                    '#972C41'),
                                                                fontSize: 14.sp,
                                                              ),
                                                            ),
                                                          )),
                                                    )
                                                  ]),
                                            );
                                          }))
                                ],
                              ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 10.h,
                left: 61.w,
                child: Container(
                  width: 30.w,
                  height: (currentScroll < 15.h && currentScroll >= 0)
                      ? (15.h - currentScroll)
                      : 0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: HexColor('#8E579C'),
                      width: 1.w,
                    ),
                    // image: DecorationImage(
                    //   image: NetworkImage(
                    //     Network().baseUrl + widget.childImage,
                    //   ),
                    // ),
                  ),
                  child: CachedNetworkImage(
                    // cacheManager: Base,
                    fit: BoxFit.cover,
                    imageUrl: Network().baseUrl + widget.childImage,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => LoadingFadeWidget(
                      height: 10,
                      width: 10,
                      radius: 20,
                    ),
                    errorWidget: (context, url, error) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(.4),
                        ),
                        padding: EdgeInsets.all(5.w),
                        child: Opacity(
                          opacity: .6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/images/Desktop HD.json'),
                              Text(
                                'undefined image',
                                style: FontManager.dubaiRegular.copyWith(
                                  fontSize: 6.5.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
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
          ),
        );
      }
    });
  }
}
