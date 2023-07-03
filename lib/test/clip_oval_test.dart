import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:sizer/sizer.dart';

class ClipOvalTest extends StatelessWidget {
  const ClipOvalTest({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: HexColor('#51093C'),
      appBar: PreferredSize(
        preferredSize: Size(0, 25.h),
        child: Stack(
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
                        start: Offset(0, 7.1.h) // 60,
                        ,
                        top: Offset(100.w / 2.33, 22.h), //180
                        end: Offset(100.w, 7.1.h), // 60
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
                width: 40.w,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: 100.h,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'data',
              style: TextStyle(
                fontSize: 40,
                color: Colors.red,
              ),
            ),
            // SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
