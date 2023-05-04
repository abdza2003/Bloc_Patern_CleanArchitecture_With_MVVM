import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_cafteria/appBar.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/navigation.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/account/account_bloc.dart';

class AddChild extends StatefulWidget {
  const AddChild({Key? key, required this.accessToken}) : super(key: key);
  final String accessToken;

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<AddChild> {
  final name = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  final classRoom = TextEditingController();
  final division = TextEditingController();
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
          } else if (state is SuccessMsgState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
            Go.back(context);
          }
        }, builder: (context, state) {
          if (state is LoadingState) {
            return Scaffold(
                body: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            repeat: ImageRepeat.repeat,
                            image: AssetImage('assets/images/bg.png'))),
                    child: const LoadingWidget()));
          } else {
            return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/bg.png'))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                        key: formKey,
                        child: SizedBox(
                          height: 100.h,
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 4.h,
                                    right: 4.h,
                                    bottom: 2.h,
                                    top: 1.h),
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: name,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.person,
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
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText:
                                          "ADD_CHILD_NAME_HINT".tr(context),
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
                                  obscureText: true,
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: password,
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
                                          "ADD_CHILD_PASS_HINT".tr(context),
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
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: email,
                                  decoration: InputDecoration(
                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor:
                                          oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.email,
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
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText:
                                          "ADD_CHILD_EMAIL_HINT".tr(context),
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
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: username,
                                  decoration: InputDecoration(
                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor:
                                          oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.account_box_rounded,
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
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText:
                                          "ADD_CHILD_USERNAME_HINT".tr(context),
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
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (mobile) =>
                                      mobile!.isNotEmpty && mobile.length != 10
                                          ? "ADD_CHILD_PAGE_WRONG_NUMBER"
                                              .tr(context)
                                          : null,
                                  cursorColor: primaryColor,
                                  controller: mobile,
                                  decoration: InputDecoration(
                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor:
                                          oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.phone,
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
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText:
                                          "ADD_CHILD_MOBILE_HINT".tr(context),
                                      hintStyle:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 4.h,
                                    right: 4.h,
                                    bottom: 2.h,
                                    top: 0.h),
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: classRoom,
                                  decoration: InputDecoration(
                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor:
                                          oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.flight_class_rounded,
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
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText: "ADD_CHILD_CLASSROOM_HINT"
                                          .tr(context),
                                      hintStyle:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 4.h,
                                    right: 4.h,
                                    bottom: 2.h,
                                    top: 0.h),
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: division,
                                  decoration: InputDecoration(
                                      filled: true,
                                      //<-- SEE HERE
                                      fillColor:
                                          oldPrimaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.people,
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
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: textColor, width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText:
                                          "ADD_CHILD_DIVISION_HINT".tr(context),
                                      hintStyle:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.h, right: 5.h),
                                child: ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<AccountBloc>(context).add(
                                          AddChildEvent(
                                              name.text,
                                              username.text,
                                              password.text,
                                              email.text,
                                              mobile.text,
                                              classRoom.text,
                                              division.text,
                                              widget.accessToken));
                                    },
                                    child: Text(
                                      "ADD_CHILD_SUBMIT_BTN".tr(context),
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
