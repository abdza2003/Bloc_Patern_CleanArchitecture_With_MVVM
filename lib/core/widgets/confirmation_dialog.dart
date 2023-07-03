import 'package:flutter/material.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:sizer/sizer.dart';

void confirmationDialog(
    BuildContext context, Function function, String content) {
  showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.only(top: 3.h, bottom: 5.h),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomRight: Radius.zero)),
              backgroundColor: HexColor('#51093C'),
              actionsAlignment: MainAxisAlignment.center,
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text("DIALOG_BUTTON_YES".tr(context).toUpperCase(),
                        style: TextStyle(fontSize: 13.sp)),
                    onPressed: () async {
                      function();
                      Go.back(context);
                    }),
                SizedBox(width: 3.w),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                        "DIALOG_BUTTON_CANCEL".tr(context).toUpperCase(),
                        style: TextStyle(fontSize: 13.sp)))
              ],
              title: Text(
                "DIALOG_BUTTON_HOLD".tr(context),
                style: FontManager.montserratBold.copyWith(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.start,
              ),
              content: Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text(
                  content,
                  style: FontManager.kumbhSansRegular.copyWith(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }));
}
