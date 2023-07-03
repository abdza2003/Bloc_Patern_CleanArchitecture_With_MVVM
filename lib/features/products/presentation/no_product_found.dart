import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/test/app_bar_widget.dart';
import 'package:sizer/sizer.dart';

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 0.h),
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
          height: 100.h,
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 80.w,
                  child: Lottie.asset('assets/images/NEW sin movs.json')),
              SizedBox(
                width: 80.w,
                child: Text(
                  'NO_PRODUCT_FOUND_PAGE'.tr(context),
                  textAlign: TextAlign.center,
                  style: FontManager.kumbhSansBold.copyWith(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppbarWidget(
          offset: -42.h,
          offsetLogo: 1.h,
        ),
      ],
    );
  }
}
