import 'package:flutter/material.dart';
import 'package:school_cafteria/core/constants/color_manager.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:sizer/sizer.dart';

class MyButtonWidget extends StatelessWidget {
  var func;
  var buttonColor;
  var buttonText;
  MyButtonWidget({this.buttonColor, this.buttonText, this.func, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          // padding: EdgeInsets.all(4.w),
          backgroundColor: HexColor('#8D6996'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
      //!
      // borderRadius: BorderRadius.circular(50),
      // customBorder: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(50),
      // ),
      // splashColor: HexColor('#F4F4F4').withOpacity(.4),
      onPressed: func,
      child: Container(
        //!
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          buttonText ?? 'LOG IN',
          style: FontManager.montserratBold.copyWith(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
