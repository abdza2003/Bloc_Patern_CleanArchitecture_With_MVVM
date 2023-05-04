import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_cafteria/appBar.dart';
import 'package:school_cafteria/app_localizations.dart';
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
        appBar: getAppBar(),
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
          if (state is LoadingState) {
            return Scaffold(body: Container(
                decoration: const BoxDecoration(
                image: DecorationImage(
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeat,
                image: AssetImage('assets/images/bg.png'))),
          child: const LoadingWidget()));
          } else {
            return Container(
              decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover,image: AssetImage('assets/images/bg.png'))),
              child: SingleChildScrollView(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                        key: formKey,
                        child: SizedBox(
                          height: 100.h,
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 4.h, right: 4.h, bottom: 2.h, top: 1.h),
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller:oldPassword,
                                  decoration: InputDecoration(

                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor: oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.lock_clock,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.red, width: 1.5),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent, width: 1.5),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                      ),
                                      enabledBorder:  const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:textColor, width: 1.5),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText: "CHANGE_PASSWORD_OLD".tr(context),
                                      hintStyle: const TextStyle(color: Colors.white)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 4.h,
                                  right: 4.h,
                                  bottom: 2.h,
                                ),
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: newPassword,
                                  decoration: InputDecoration(
                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor: oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.lock_open,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.red, width: 1.5),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent, width: 1.5),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                      ),
                                      enabledBorder:  const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText: "CHANGE_PASSWORD_NEW".tr(context),
                                      hintStyle: const TextStyle(color: Colors.white)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 4.h,
                                  right: 4.h,
                                  bottom: 2.h,
                                ),
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: confirmPassword,
                                  decoration: InputDecoration(
                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor: oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.red, width: 1.5),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent, width: 1.5),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                      ),
                                      enabledBorder:  const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText: "CHANGE_PASSWORD_CONFIRM".tr(context),
                                      hintStyle: const TextStyle(color: Colors.white)
                                  ),
                                ),
                              ),
                              
                              Padding(
                                padding: EdgeInsets.only(left:5.h ,right: 5.h),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if(formKey.currentState!.validate())
                                        {
                                          BlocProvider.of<AccountBloc>(context).add(ChangePasswordEvent(oldPassword.text, newPassword.text, confirmPassword.text, widget.accessToken));
                                        }
                                    },
                                    child: Text(
                                      "CHANGE_PASSWORD_BUTTON".tr(context),
                                      style: TextStyle(fontSize: 13.sp),
                                    )),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            );
          }
        }));
  }
}
