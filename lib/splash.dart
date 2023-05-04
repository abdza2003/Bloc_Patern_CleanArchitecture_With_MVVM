import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_cafteria/bottom.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:school_cafteria/core/widgets/fade_animation.dart';
import 'package:school_cafteria/features/account/presentation/pages/account/loginpage.dart';
import 'package:sizer/sizer.dart';
import 'features/account/presentation/bloc/account/account_bloc.dart';


class Splash  extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);




  @override
  SplashState  createState() => SplashState ();
}


class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {

      Timer(const Duration(seconds: 3), ()
      {
        BlocProvider.of<AccountBloc>(context).add(CheckLoginEvent());
      });
  }
  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();


  @override
  Widget build(BuildContext context) {

    return BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if(state is LoggedInState)
          {
            Go.offALL(context,BottomNav(user: state.user));
          }
          else if (state is LoggedOutState )
          {
            Go.offALL(context, const LoginPage(isAnother: false));
          }
        },
        child :Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/splash.png'),fit: BoxFit.cover)
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[ 
                FadeAnimation(2.5,Center(
                child:  Image(image: const AssetImage('assets/launcher/logo.png'),width:45.w ,height:20.h ,),
              )),
    FadeAnimation(2.8,Center(
    child:Text('YOUR FUTURE IS IN YOUR HANDS',style: TextStyle(color: primaryColor,fontSize: 15.sp),textAlign: TextAlign.center,)))

              ]),
        )
    ));
  }
}