import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:sizer/sizer.dart';

scrollviewAppbar() {
  return FlexibleSpaceBar(
    background: Stack(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: ProsteBezierCurve(
                    position: ClipPosition.bottom,
                    list: [
                      BezierCurveSection(
                        start: Offset(0, 12.h), // 100
                        top: Offset(100.w / 2.43, 24.6.h), // 200
                        end: Offset(100.w, 6.2.h),
                      ),
                    ],
                  ),
                  child: Container(
                    height: 25.h,
                    color: HexColor('#C53E5D'),
                  ),
                ),
                ClipPath(
                  clipper: ProsteBezierCurve(
                    position: ClipPosition.bottom,
                    list: [
                      BezierCurveSection(
                        start: Offset(0, 7.1.h) // 0, 7.1.h
                        ,
                        top: Offset(100.w / 2.33, 22.h), //100.w / 2.33, 22.h
                        end: Offset(100.w, 7.1.h), //100.w, 7.1.h
                      ),
                    ],
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Container(
                      height: 25.h,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 19.w,
              child: Image.asset(
                'assets/images/medrese.png',
                filterQuality: FilterQuality.high,
                width: 36.w,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
