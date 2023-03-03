import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:school_cafteria/core/widgets/fade_animation.dart';
import 'package:school_cafteria/features/account/presentation/pages/account/loginpage.dart';
import 'package:school_cafteria/features/account/presentation/pages/homepage.dart';
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
        // if(token) {
        //   int idUser=prefs.getInt('idUser')!;
        //   String fullName=prefs.getString('fullName')!;
        //   String role=prefs.getString('role')!;
        //   String image=prefs.getString('image')!;
        //   String? categoryName=prefs.getString('categoryName');
        //   int locationId=prefs.getInt('locationId')!;
        //   bool? certified=prefs.getBool('certification');
        // Go.offALL(context,HomePage(idUser: idUser,fullName: fullName,role: role,locationId: locationId, image: image,categoryName: categoryName, certified: certified,));
        // }
        // else {
        //   Go.offALL(context,Login());
        // }
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
            Go.offALL(context, HomePage(user: state.user));
          }
          else if (state is LoggedOutState )
          {
            Go.offALL(context, const LoginPage(isAnother: false));
          }
        },
        child :Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[ FadeAnimation(2.5,Center(
              child:  Image(image: const AssetImage('assets/launcher/logo.png'),width:35.w ,height:40.h ,),
            )),])
    ));
  }
}