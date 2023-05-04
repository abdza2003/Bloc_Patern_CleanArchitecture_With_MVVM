import 'package:flutter/material.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:sizer/sizer.dart';
class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover)),
      height: 100.h,
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Text(
            'NO_PRODUCT_FOUND_PAGE'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
