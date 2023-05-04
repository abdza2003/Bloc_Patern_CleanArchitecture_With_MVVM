import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(10.h+10.w),
          child: AppBar(
              flexibleSpace:  Padding(
                padding:  EdgeInsets.only(top:5.h ,right: 38.w),
                child: Container(
                  height: 8.h+7.w,
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/launcher/logo.png'))),),
              ),
              elevation: 20,
              bottomOpacity: 0,
              backgroundColor: Colors.white.withOpacity(0.7),
              shadowColor: const Color(0xffFF5DB9),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(1100, 500),
                    bottomLeft: Radius.elliptical(550, 350)
                ),
              )),
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
                child: Column(
                  children: [
                    Form(
                        key: formKey,
                        child: SizedBox(
                          height: 100.h,
                          child: ListView(
                            children: [
                              // Padding(
                              //     padding: EdgeInsets.all(1.h),
                              //     child: CircleAvatar(
                              //       radius: 60,
                              //       backgroundColor: primaryColor,
                              //       child: CircleAvatar(
                              //           backgroundColor: Colors.white,
                              //           backgroundImage:  image==null?null:Image.file(File(image!.path))
                              //                 .image,
                              //
                              //           radius: 58,
                              //           child:  IconButton(
                              //                   onPressed: () async {
                              //                     var image1 =
                              //                         await _picker.pickImage(
                              //                             source:
                              //                                 ImageSource.gallery);
                              //                     setState(() {
                              //                       image = image1;
                              //                     });
                              //                   },
                              //                   icon: Icon(
                              //                     Icons.add_a_photo_outlined,
                              //                     size: 20.sp,
                              //                     color: image==null?primaryColor:Colors.transparent,
                              //                   ))
                              //               ),
                              //     )),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 4.h, right: 4.h, bottom: 2.h, top: 1.h),
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: name,
                                  decoration: InputDecoration(
                                    filled: true,
                                    //<-- SEE HERE
                                    fillColor: oldPrimaryColor.withOpacity(0.4),
                                    prefixIcon: const Icon(
                                      Icons.person,
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
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:textColor, width: 1.5),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(40.0)),
                                    ),
                                    // errorText: login.userErrorText,
                                    hintText: "ADD_CHILD_NAME_HINT".tr(context),
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
                                  controller: password,
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
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: textColor, width: 1.5),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(40.0)),
                                    ),
                                    // errorText: login.userErrorText,
                                    hintText: "ADD_CHILD_PASS_HINT".tr(context),
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
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: email,
                                  decoration: InputDecoration(
                                    filled: true,
                                    //<-- SEE HERE
                                    fillColor: oldPrimaryColor.withOpacity(0.4),
                                    prefixIcon: const Icon(
                                      Icons.email,
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
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: textColor, width: 1.5),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(40.0)),
                                    ),
                                    // errorText: login.userErrorText,
                                    hintText: "ADD_CHILD_EMAIL_HINT".tr(context),
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
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: username,
                                  decoration: InputDecoration(
                                    filled: true,
                                    //<-- SEE HERE
                                    fillColor: oldPrimaryColor.withOpacity(0.4),
                                    prefixIcon: const Icon(
                                      Icons.account_box_rounded,
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
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: textColor, width: 1.5),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(40.0)),
                                    ),
                                    // errorText: login.userErrorText,
                                    hintText: "ADD_CHILD_USERNAME_HINT".tr(context),
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
                                    fillColor: oldPrimaryColor.withOpacity(0.4),
                                    prefixIcon: const Icon(
                                      Icons.phone,
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
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: textColor, width: 1.5),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(40.0)),
                                    ),
                                    // errorText: login.userErrorText,
                                    hintText: "ADD_CHILD_MOBILE_HINT".tr(context),
                                    hintStyle: const TextStyle(color: Colors.white)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 4.h, right: 4.h, bottom: 2.h, top: 0.h),
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: classRoom,
                                  decoration: InputDecoration(
                                    filled: true,
                                    //<-- SEE HERE
                                    fillColor: oldPrimaryColor.withOpacity(0.4),
                                    prefixIcon: const Icon(
                                      Icons.flight_class_rounded,
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
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: textColor, width: 1.5),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(40.0)),
                                    ),
                                    // errorText: login.userErrorText,
                                    hintText: "ADD_CHILD_CLASSROOM_HINT".tr(context),
                                    hintStyle: const TextStyle(color: Colors.white)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 4.h, right: 4.h, bottom: 2.h, top: 0.h),
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "REQUIRED_FIELD".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: division,
                                  decoration: InputDecoration(
                                    filled: true,
                                    //<-- SEE HERE
                                    fillColor: oldPrimaryColor.withOpacity(0.4),
                                    prefixIcon: const Icon(
                                      Icons.people,
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
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: textColor, width: 1.5),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(40.0)),
                                    ),
                                    // errorText: login.userErrorText,
                                    hintText: "ADD_CHILD_DIVISION_HINT".tr(context),
                                    hintStyle: const TextStyle(color: Colors.white)
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
                              Padding(
                                padding: EdgeInsets.only(left:5.h ,right: 5.h),
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
