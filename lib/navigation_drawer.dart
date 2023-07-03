import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/features/account/presentation/pages/account/change_password.dart';
import 'package:sizer/sizer.dart';

import 'app_localizations.dart';
import 'bottom.dart';
import 'core/app_theme.dart';
import 'core/navigation.dart';
import 'core/network/api.dart';
import 'features/account/domain/entities/user.dart';
import 'features/account/presentation/bloc/account/account_bloc.dart';
import 'features/account/presentation/pages/Account/loginpage.dart';

class NavigationDrawerProfile extends StatelessWidget {
  NavigationDrawerProfile({Key? key, required this.user}) : super(key: key);
  final User user;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: ClipRRect(
          borderRadius:
              AppLocalizations.of(context)!.locale!.languageCode != 'ar'
                  ? const BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50)),
          child: Drawer(
              backgroundColor: HexColor('#23284E').withOpacity(.9),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(context),
                    buildMenuItems(context),
                  ],
                ),
              ))),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(top: 5.h, bottom: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5.w, left: 5.w),
                    child: Container(
                      height: 10.h,
                      width: 20.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: CachedNetworkImage(
                        // cacheManager: Base,
                        fit: BoxFit.cover,
                        imageUrl: Network().baseUrl + user.image!,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(26),
                                bottomLeft: Radius.circular(26),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        placeholder: (context, url) => Center(
                          child: Padding(
                            padding: EdgeInsets.all(7),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset('assets/launcher/logo.png'),
                                const CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          return Container(
                            padding: EdgeInsets.all(5.w),
                            child: Opacity(
                              opacity: 1,
                              child: Lottie.asset(
                                'assets/images/Home.json',
                                width: 30.w,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10.w,
                      left: 10.w,
                    ),
                    child: GestureDetector(
                        onTap: () async {
                          var image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null && context.mounted) {
                            List<String> accessTokens = [];
                            for (var school in user.schools!) {
                              accessTokens.add(school.accessToken!);
                            }
                            BlocProvider.of<AccountBloc>(context)
                                .add(EditPhotoEvent(image, accessTokens));
                          }
                        },
                        child: CircleAvatar(
                          radius: 10.sp,
                          backgroundColor: HexColor('#EA4B6F'),
                          child: SvgPicture.asset(
                            'assets/images/edit-circle.svg',
                            color: Colors.white,
                            width: 15.sp,
                          ),
                        )),
                  ),
                ]),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(right: 5.w, left: 7.w),
              child: Text(user.name!.toString().toUpperCase(),
                  style: FontManager.montserratBold.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                  )),
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.all(3.h),
        child: Wrap(
          //runSpacing: 16.0,
          children: [
            ListTile(
              minLeadingWidth: 0,
              title: Text(
                "NAVIGATION_DRAWER_PHONE".tr(context),
                style: FontManager.montserratRegular.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
              leading: Icon(
                Icons.phone_outlined,
                color: HexColor('#C3C3C3'),
              ),
              subtitle: Text(
                user.mobile!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              minLeadingWidth: 10,
              title: Text(
                "NAVIGATION_DRAWER_EMAIL".tr(context),
                style: FontManager.montserratRegular.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
              leading: Icon(Icons.alternate_email_outlined,
                  color: HexColor('#C3C3C3')),
              subtitle: Text(
                user.email!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              minLeadingWidth: 10,
              title: Text(
                "NAVIGATION_DRAWER_PASSWORD".tr(context),
                style: FontManager.montserratRegular.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
              leading: Icon(Icons.password, color: HexColor('#C3C3C3')),
              subtitle: const Text(
                "*********",
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: HexColor('#8D6996'),
                              titlePadding: EdgeInsets.zero,
                              title: SizedBox(
                                  height: 8.h,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      margin: const EdgeInsets.all(0),
                                      shadowColor: HexColor('#8D6996'),
                                      color: HexColor('#8D6996'),
                                      elevation: 20,
                                      child: Center(
                                          child: Text(
                                        "CHOOSE_SCHOOL".tr(context),
                                        style:
                                            FontManager.kumbhSansBold.copyWith(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      )))),
                              content: SizedBox(
                                  height:
                                      25.h, // Change as per your requirement
                                  width: 30.w,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          const Divider(thickness: 1),
                                      itemCount: user.schools!.length,
                                      itemBuilder: (context, index) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(
                                              color: primaryColor,
                                            ),
                                          ),
                                          onPressed: () => Go.off(
                                              context,
                                              ChangePassword(
                                                  accessToken: user
                                                      .schools![index]
                                                      .accessToken!)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.sp),
                                            child: Text(
                                              user.schools![index].name!,
                                              style: FontManager.kumbhSansBold
                                                  .copyWith(
                                                fontSize: 16.sp,
                                                color: HexColor('#777575'),
                                              ),
                                            ),
                                          ),
                                        );
                                      })));
                        });
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  )),
            ),
            ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.language,
                size: 15.sp,
                color: HexColor('#C3C3C3'),
              ),
              minVerticalPadding: 0,
              title: Text(
                "NAVIGATION_DRAWER_LANGUAGE".tr(context),
                style: FontManager.montserratRegular.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
              onTap: () {
                selectLanguage(context);
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            Column(
              children: [
                Text(
                  "NAVIGATION_DRAWER_ABOUT".tr(context),
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                ),
                SizedBox(
                  height: 5.h,
                ),
                GestureDetector(
                  child: Text("NAVIGATION_DRAWER_LOGOUT".tr(context),
                      style: FontManager.montserratRegular.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      )),
                  onTap: () async {
                    BlocProvider.of<AccountBloc>(context).add(LogoutEvent());
                    Go.offALL(context, const LoginPage(isAnother: false));
                  },
                ),
              ],
            ),
          ],
        ),
      );
}
