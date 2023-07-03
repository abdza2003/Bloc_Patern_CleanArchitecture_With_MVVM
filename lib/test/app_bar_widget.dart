import 'package:flutter/material.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:sizer/sizer.dart';

class AppbarWidget extends StatelessWidget {
  double? offset;
  double? offsetLogo;
  AppbarWidget({this.offset, this.offsetLogo, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      // margin: EdgeInsets.only(bottom: 100),
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Stack(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(
                        -10, offset != null ? offset! + 1.h : (-55.h + 1.h)),
                    child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(216 / 360),
                      child: ClipOval(
                        clipper: MyCustomClipper(),
                        child: Container(
                          // width: 500,
                          height: 62.h,
                          decoration: BoxDecoration(
                            color: HexColor('#C53E5D'), //#C53E5D
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, offset ?? -55.h),
                    child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(222 / 360),
                      child: ClipOval(
                        clipper: MyCustomClipper(),
                        child: Container(
                          height: 60.h,
                          width: 600,
                          color: HexColor('#FFFFFF').withOpacity(1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(-15.w, offsetLogo ?? -12.h),
            child: Image.asset(
              'assets/images/medrese.png',
              filterQuality: FilterQuality.high,
              width: 40.w,
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
