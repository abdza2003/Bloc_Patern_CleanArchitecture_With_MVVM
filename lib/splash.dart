import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_cafteria/bottom.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/core/widgets/fade_animation.dart';
import 'package:school_cafteria/features/account/presentation/pages/account/loginpage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'features/account/presentation/bloc/account/account_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    Timer(const Duration(seconds: 3), () {
      BlocProvider.of<AccountBloc>(context).add(CheckLoginEvent());
    });
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is LoggedInState) {
          Go.offALL(context, BottomNav(user: state.user));
        } else if (state is LoggedOutState) {
          Go.offALL(context, const LoginPage(isAnother: false));
        }
      },
      child: Scaffold(
        body: Container(
          width: 100.w,
          height: 100.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
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
            color: HexColor(
              '#51093C',
            ),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, 2.h),
                            child: RotationTransition(
                              turns: const AlwaysStoppedAnimation(35 / 360),
                              child: ClipOval(
                                clipper: MyCustomClipper(),
                                child: Container(
                                  // width: 500,
                                  height: 62.h,
                                  decoration: BoxDecoration(
                                    color: HexColor('#C53E5D'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          RotationTransition(
                            turns: const AlwaysStoppedAnimation(40 / 360),
                            child: ClipOval(
                              clipper: MyCustomClipper(),
                              child: Container(
                                height: 62.h,
                                color: HexColor('#FFFFFF').withOpacity(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/medrese.png',
                            filterQuality: FilterQuality.high,
                            width: 70.w,
                          ),
                          Text(
                            'YOUR FUTURE IS IN YOUR HANDS',
                            style: FontManager.chewyRegular.copyWith(
                              color: HexColor('#662483').withOpacity(.7),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(.3),
                    child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(40 / 360),
                      child: ClipOval(
                        clipper: MyCustomClipper(),
                        child: Container(
                          height: 62.h,
                          color: HexColor('#FFFFFF').withOpacity(.85),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
