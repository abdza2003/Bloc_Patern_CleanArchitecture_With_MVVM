import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:school_cafteria/appBar.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/test/app_bar_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/navigation.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/account/account_bloc.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, required this.accessToken}) : super(key: key);
  final String accessToken;

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<ChangePassword> {
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body:
            BlocConsumer<AccountBloc, AccountState>(listener: (context, state) {
          if (state is ErrorMsgState) {
            SnackBarMessage()
                .showErrorSnackBar(message: state.message, context: context);
          } else if (state is SuccessChangePasswordState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
            Go.back(context);
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25.h),
                /* 
                  Container(
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
          child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: _selectedWidget()),
                  const AppbarWidget(),
                ],
          ),
        ),
                   */
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
                child: ListView(
                  physics: NeverScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                        key: formKey,
                        child: SizedBox(
                          height: 60.h,
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 4.h,
                                    right: 4.h,
                                    bottom: 2.h,
                                    top: 1.h),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: true,
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: oldPassword,
                                  decoration: InputDecoration(
                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor:
                                          oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.lock_clock,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      errorStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText:
                                          "CHANGE_PASSWORD_OLD".tr(context),
                                      hintStyle:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 4.h,
                                  right: 4.h,
                                  bottom: 2.h,
                                ),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: true,
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: newPassword,
                                  decoration: InputDecoration(
                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor:
                                          oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.lock_open,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      errorStyle:
                                          TextStyle(color: Colors.white),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText:
                                          "CHANGE_PASSWORD_NEW".tr(context),
                                      hintStyle:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 4.h,
                                  right: 4.h,
                                  bottom: 2.h,
                                ),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: true,
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: confirmPassword,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    //<-- SEE HERE
                                    fillColor: oldPrimaryColor.withOpacity(0.4),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          40.0,
                                        ),
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: textColor, width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    // errorText: login.userErrorText,
                                    hintText:
                                        "CHANGE_PASSWORD_CONFIRM".tr(context),
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: LoadingBtn(
                                  height: 7.h,
                                  width: 85.w,
                                  borderRadius: 40,
                                  color: HexColor('#8D6996'),
                                  animate: true,
                                  // roundLoadingShape: true,
                                  loader: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.transparent,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: (startLoading, stopLoading,
                                      btnState) async {
                                    if (btnState == ButtonState.idle) {
                                      startLoading();

                                      await Future.delayed(
                                          Duration(
                                              milliseconds: formKey
                                                      .currentState!
                                                      .validate()
                                                  ? 400
                                                  : 0),
                                          () {});
                                      if (formKey.currentState!.validate()) {
                                        BlocProvider.of<AccountBloc>(context)
                                            .add(
                                          ChangePasswordEvent(
                                            oldPassword.text,
                                            newPassword.text,
                                            confirmPassword.text,
                                            widget.accessToken,
                                          ),
                                        );
                                      }
                                      stopLoading();
                                    }
                                  },
                                  child: Text(
                                    "CHANGE_PASSWORD_BUTTON".tr(context),
                                    style: FontManager.montserratBold.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              /*  Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.h, right: 5.h),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(0, 6.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (formKey.currentState!
                                            .validate()) {
                                          BlocProvider.of<AccountBloc>(
                                                  context)
                                              .add(
                                            ChangePasswordEvent(
                                              oldPassword.text,
                                              newPassword.text,
                                              confirmPassword.text,
                                              widget.accessToken,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "CHANGE_PASSWORD_BUTTON".tr(context),
                                        style: FontManager.montserratBold
                                            .copyWith(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                        ),
                                      )),
                                ), */
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              AppbarWidget(
                offset: -42.h,
                offsetLogo: 1.h,
              ),
            ],
          );
        }));
  }
}
