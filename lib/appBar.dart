import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

PreferredSize getAppBar () {
  return PreferredSize(
    preferredSize: Size.fromHeight(10.h + 10.w),
    child: AppBar(
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 5.h, right: 38.w),
          child: Container(
            height: 8.h + 7.w,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/launcher/logo.png'))),
          ),
        ),
        elevation: 20,
        bottomOpacity: 0,
        backgroundColor: Colors.white.withOpacity(0.7),
        shadowColor: const Color(0xffFF5DB9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.elliptical(1100, 500),
              bottomLeft: Radius.elliptical(550, 350)),
        )),
  );
}