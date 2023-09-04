import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/constants/color_manager.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/account/presentation/bloc/account/account_bloc.dart';
import 'package:school_cafteria/features/account/presentation/pages/account/policy_files.dart';
import 'package:school_cafteria/features/account/presentation/widget/animation_button.dart';
import 'package:sizer/sizer.dart';
import '../../../../../bottom.dart';
import '../../../../../core/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/util/snackbar_message.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_btn/loading_btn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.isAnother}) : super(key: key);
  final bool isAnother;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final ValueNotifier<bool> showMyAccounts = ValueNotifier(false);

class _LoginPageState extends State<LoginPage> {
  late Box myBox;
  bool isAnimted = false;

  bool isLoading = false;
  bool isError = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBox = Hive.box('myAccounts');
  }

  // bool showMyAccounts = false;
  @override
  Widget build(BuildContext context) {
    final usernameOrEmail = TextEditingController();
    final password = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final ScrollController _horizontal = ScrollController(),
        _vertical = ScrollController();
    return Scaffold(
      body: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is LoadingState) {
            print('================loading');
            setState(() {
              isLoading = true;
            });
          } else if (state is ErrorMsgState) {
            setState(() {
              isLoading = false;
            });
            SnackBarMessage()
                .showErrorSnackBar(message: state.message, context: context);
          } else if (state is LoggedInState) {
            setState(() {
              isLoading = false;
              isError = true;
            });
            print('===================#########==========${state.user.roleId}');
            Go.offALL(context, BottomNav(user: state.user));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SizedBox(
              width: 100.w,
              height: 100.h,
              child: Container(
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
                  color: ColorManager.primary,
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'policy_file'.tr(context).split(',')[0] + ", ",
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: 100.w,
                                    height: 100.h,
                                    margin: EdgeInsets.all(30.sp),
                                    padding: EdgeInsets.all(10.sp),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          Text(
                                            Platform.localeName.split('_')[0] ==
                                                    'ar'
                                                ? policyAr
                                                : Platform.localeName
                                                            .split('_')[0] ==
                                                        'tr'
                                                    ? policyTr
                                                    : policyEn,
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              'policy_file'.tr(context).split(',')[1],
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        widget.isAnother
                            ? Text(
                                "NOTE_SECOND_LOGIN".tr(context),
                                style: FontManager.montserratBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 26,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : const SizedBox(),
                        widget.isAnother
                            ? const SizedBox()
                            : Text(
                                "PLEASE LOG IN",
                                style: FontManager.montserratBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 26,
                                ),
                                textAlign: TextAlign.center,
                              ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 4.h,
                                            right: 4.h,
                                            bottom: 2.h,
                                          ),
                                          child: TextFormField(
                                            onTap: () {
                                              // setState(() {});
                                              if (usernameOrEmail
                                                  .text.isEmpty) {
                                                showMyAccounts.value =
                                                    !showMyAccounts.value;
                                              } else {
                                                showMyAccounts.value = false;
                                              }
                                            },
                                            onChanged: (value) {
                                              showMyAccounts.value = false;
                                            },
                                            style: const TextStyle(
                                                color: Colors.white),
                                            validator: (value) => value!.isEmpty
                                                ? "EMPTY_USER".tr(context)
                                                : null,
                                            cursorColor: Colors.white,
                                            controller: usernameOrEmail,
                                            decoration: InputDecoration(
                                              filled: true,
                                              errorStyle: TextStyle(
                                                  color: Colors.white),
                                              hintStyle: const TextStyle(
                                                  color: Colors.white),
                                              //<-- SEE HERE
                                              fillColor: HexColor('#A7869D')
                                                  .withOpacity(.8),
                                              prefixIcon: const Icon(
                                                Icons.email,
                                                color: Colors.white,
                                              ),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40.0)),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40.0)),
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40.0)),
                                              ),
                                              // errorText: login.userErrorText,
                                              hintText:
                                                  "LOGIN_USER_HINT".tr(context),
                                              //hintStyle: TextStyle(color: Colors.white)
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                              left: 4.h,
                                              right: 4.h,
                                              bottom: 0.h,
                                            ),
                                            child: TextFormField(
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              obscureText: true,
                                              validator: (value) => value!
                                                      .isEmpty
                                                  ? "EMPTY_PASSWORD".tr(context)
                                                  : null,
                                              cursorColor: Colors.white,
                                              controller: password,
                                              decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                    color: Colors.white),
                                                filled: true,
                                                hintStyle: const TextStyle(
                                                    color: Colors.white),
                                                //<-- SEE HERE
                                                fillColor: HexColor('#A7869D')
                                                    .withOpacity(.8),
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: Colors.white,
                                                ),
                                                border:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 1.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    40.0))),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              40.0)),
                                                ),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              40.0)),
                                                ),
                                                // errorText: login.userErrorText,
                                                hintText: "LOGIN_PASSWORD_HINT"
                                                    .tr(context),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                      ],
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: showMyAccounts,
                                      builder: (context, value, child) {
                                        return Visibility(
                                          visible: showMyAccounts.value,
                                          child: Positioned(
                                            top: 5.h,
                                            left: 18.w,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Container(
                                                width: 65.w,
                                                height: myBox.length == 0
                                                    ? 0
                                                    : myBox.length > 2
                                                        ? 15.h
                                                        : 10.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: HexColor('#F7F4F4'),
                                                ),
                                                child: Scrollbar(
                                                  radius: Radius.circular(8),
                                                  controller: _vertical,
                                                  thumbVisibility: true,
                                                  trackVisibility: true,
                                                  child: SingleChildScrollView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      controller: _vertical,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: List.generate(
                                                          myBox.length,
                                                          (index) => Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        0,
                                                                    vertical:
                                                                        0.sp),
                                                            child:
                                                                ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15)),
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      elevation:
                                                                          0,
                                                                      backgroundColor:
                                                                          HexColor(
                                                                              '#F7F4F4'),
                                                                      fixedSize:
                                                                          Size(
                                                                        100.w,
                                                                        40,
                                                                      )),
                                                              onPressed: () {
                                                                showMyAccounts
                                                                        .value =
                                                                    false;
                                                                usernameOrEmail
                                                                    .text = myBox
                                                                        .getAt(
                                                                            index)
                                                                        .toString()
                                                                        .split('|')[
                                                                    0];
                                                                password.text = myBox
                                                                    .getAt(
                                                                        index)
                                                                    .toString()
                                                                    .split(
                                                                        '|')[1];
                                                              },
                                                              child: Text(
                                                                myBox
                                                                    .getAt(
                                                                        index)
                                                                    .toString()
                                                                    .split(
                                                                        '|')[0],
                                                                style: FontManager
                                                                    .chewyRegular
                                                                    .copyWith(
                                                                  fontSize:
                                                                      12.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                LoadingBtn(
                                  height: 7.h,
                                  width: 85.w,
                                  borderRadius: 40,
                                  color: HexColor('#8D6996'),
                                  animate: true,
                                  // roundLoadingShape: true,
                                  loader: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: HexColor('#8D6996'),
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
                                              milliseconds: password.text == ''
                                                  ? 0
                                                  : usernameOrEmail.text == ''
                                                      ? 0
                                                      : 450), () {
                                        if (formKey.currentState!.validate()) {
                                          if (widget.isAnother) {
                                            BlocProvider.of<AccountBloc>(
                                                    context)
                                                .add(SecondLoginEvent(
                                                    usernameOrEmail.text,
                                                    password.text,
                                                    usernameOrEmail.text
                                                        .isValidEmail()));
                                          } else {
                                            BlocProvider.of<AccountBloc>(
                                                    context)
                                                .add(LoginEvent(
                                                    usernameOrEmail.text,
                                                    password.text,
                                                    usernameOrEmail.text
                                                        .isValidEmail()));
                                          }

                                          // if (isError) {
                                          //   var result = myBox.values.any(
                                          //       (element) =>
                                          //           element
                                          //               .toString()
                                          //               .split('|')[0] ==
                                          //           usernameOrEmail.text);
                                          //   if (result == false) {
                                          //     myBox.add(
                                          //         '${usernameOrEmail.text}|${password.text}');
                                          //   }
                                          //   print(
                                          //       '====================${result} ========== ${usernameOrEmail.text}');
                                          // }
                                        }
                                      }).then((value) {
                                        stopLoading();
                                      });
                                    }
                                  },
                                  child: Text(
                                    "LOGIN_BUTTON".tr(context),
                                    style: FontManager.montserratBold.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                // AnimationButtonWidget(
                                //   buttonText: "LOGIN_BUTTON".tr(context),
                                //   isLoading: isLoading,
                                //   isAnimted: isAnimted,
                                //   func: () async {
                                //     if (formKey.currentState!.validate()) {
                                //       if (widget.isAnother) {
                                //         BlocProvider.of<AccountBloc>(context).add(
                                //             SecondLoginEvent(
                                //                 usernameOrEmail.text,
                                //                 password.text,
                                //                 usernameOrEmail.text
                                //                     .isValidEmail()));
                                //       } else {
                                //         BlocProvider.of<AccountBloc>(context).add(
                                //             LoginEvent(
                                //                 usernameOrEmail.text,
                                //                 password.text,
                                //                 usernameOrEmail.text
                                //                     .isValidEmail()));
                                //       }
                                //     }
                                //   },
                                // ),
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //       backgroundColor: primaryColor,
                                //       shape: const RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.all(Radius.circular(30)),
                                //       ),
                                //       minimumSize: Size(80.w, 7.h)),
                                //   onPressed: () {
                                //     if (formKey.currentState!.validate()) {
                                //       if (isAnother) {
                                //         BlocProvider.of<AccountBloc>(context).add(
                                //             SecondLoginEvent(
                                //                 usernameOrEmail.text,
                                //                 password.text,
                                //                 usernameOrEmail.text
                                //                     .isValidEmail()));
                                //       } else {
                                //         BlocProvider.of<AccountBloc>(context).add(
                                //             LoginEvent(
                                //                 usernameOrEmail.text,
                                //                 password.text,
                                //                 usernameOrEmail.text
                                //                     .isValidEmail()));
                                //       }
                                //     }
                                //   },
                                //   child: Text(
                                //     "LOGIN_BUTTON".tr(context),
                                //     style: FontManager.montserratBold.copyWith(
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
                              ],
                            )),
                        SizedBox(
                          height: 2.h,
                        ),
                        widget.isAnother
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.all(4.h),
                                child: Text(
                                  "NOTE_LOGIN_PAGE".tr(context),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.white),
                                )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
