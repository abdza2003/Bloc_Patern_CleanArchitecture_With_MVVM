import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
  final username = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  final formKey = GlobalKey<FormState>();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ADD_CHILD_PAGE_TITLE".tr(context)),
        ),
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
            return const LoadingWidget();
          } else {
            return Column(
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(1.h),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: primaryColor,
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage:  image==null?null:Image.file(File(image!.path))
                                        .image,

                                  radius: 58,
                                  child:  IconButton(
                                          onPressed: () async {
                                            var image1 =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            setState(() {
                                              image = image1;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add_a_photo_outlined,
                                            size: 20.sp,
                                            color: image==null?primaryColor:Colors.transparent,
                                          ))
                                      ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 4.h, right: 4.h, bottom: 3.h, top: 1.h),
                          child: TextFormField(
                            validator: (value) => value!.isEmpty
                                ? "REQUIRED_FIELD".tr(context)
                                : null,
                            cursorColor: primaryColor,
                            controller: name,
                            decoration: InputDecoration(
                              filled: true,
                              //<-- SEE HERE
                              fillColor: const Color(0xffE8E5F6),
                              prefixIcon: Icon(
                                Icons.person,
                                color: primaryColor,
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
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              // errorText: login.userErrorText,
                              hintText: "ADD_CHILD_NAME_HINT".tr(context),
                              //hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 4.h,
                            right: 4.h,
                            bottom: 3.h,
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
                              fillColor: const Color(0xffE8E5F6),
                              prefixIcon: Icon(
                                Icons.lock_open,
                                color: primaryColor,
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
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              // errorText: login.userErrorText,
                              hintText: "ADD_CHILD_PASS_HINT".tr(context),
                              //hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 4.h,
                            right: 4.h,
                            bottom: 3.h,
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
                              fillColor: const Color(0xffE8E5F6),
                              prefixIcon: Icon(
                                Icons.email,
                                color: primaryColor,
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
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              // errorText: login.userErrorText,
                              hintText: "ADD_CHILD_EMAIL_HINT".tr(context),
                              //hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 4.h,
                            right: 4.h,
                            bottom: 3.h,
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
                              fillColor: const Color(0xffE8E5F6),
                              prefixIcon: Icon(
                                Icons.account_box_rounded,
                                color: primaryColor,
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
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              // errorText: login.userErrorText,
                              hintText: "ADD_CHILD_USERNAME_HINT".tr(context),
                              //hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 4.h,
                            right: 4.h,
                            bottom: 3.h,
                          ),
                          child: TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (mobile) =>
                                mobile!.isNotEmpty && mobile.length != 10
                                    ? "ADD_CHILD_PAGE_WRONG_NUMBER".tr(context)
                                    : null,
                            cursorColor: primaryColor,
                            controller: mobile,
                            decoration: InputDecoration(
                              filled: true,
                              //<-- SEE HERE
                              fillColor: const Color(0xffE8E5F6),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: primaryColor,
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
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              // errorText: login.userErrorText,
                              hintText: "ADD_CHILD_MOBILE_HINT".tr(context),
                              //hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                        ),
                        //  Padding(
                        //    padding:  EdgeInsets.only(left:8.w ,right: 8.w),
                        //    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       Text("ADD_CHILD_CHOOSE_IMAGE_NOTE".tr(context)),
                        //       image == null
                        //           ? IconButton(
                        //               icon: const Icon(Icons.add_a_photo),
                        //               onPressed: () async {
                        //                 var image1 = await _picker.pickImage(
                        //                     source: ImageSource.gallery);
                        //                 setState(() {
                        //                   image = image1;
                        //                 });
                        //               },)
                        //              // label: Text("ADD_CHILD_CHOOSE_IMAGE_BTN".tr(context)))
                        //           : ClipRRect(
                        //               borderRadius: BorderRadius.circular(10.0),
                        //               child: Image(
                        //                 image: Image.file(File(image!.path)).image,
                        //                 width: 20.w,
                        //                 height: 17.h,
                        //               )),
                        //     ],
                        // ),
                        //  ),
                        //SizedBox(height:1.h),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(28.w, 5.h)),
                            onPressed: () {
                              BlocProvider.of<AccountBloc>(context).add(
                                  AddChildEvent(
                                      name.text,
                                      username.text,
                                      password.text,
                                      email.text,
                                      mobile.text,
                                      image,
                                      widget.accessToken));
                            },
                            child: Text(
                              "ADD_CHILD_SUBMIT_BTN".tr(context),
                              style: TextStyle(fontSize: 13.sp),
                            )),
                      ],
                    ))
              ],
            );
          }
        }));
  }
}
