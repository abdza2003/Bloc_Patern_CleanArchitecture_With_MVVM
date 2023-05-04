import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
    return ClipRRect(
        borderRadius: AppLocalizations.of(context)!.locale!.languageCode != 'ar' ?const BorderRadius.only(topRight: Radius.circular(50),bottomRight:Radius.circular(50) ):const BorderRadius.only(topLeft: Radius.circular(50),bottomLeft:Radius.circular(50) ),
        child:Drawer(
            backgroundColor: drawerColor,
            child: SingleChildScrollView(
              child: Column( crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildHeader(context),
                  buildMenuItems(context),
                ],
              ),
            )));
  }
  Widget buildHeader (BuildContext context)=>Container(
    padding: EdgeInsets.only(top:5.h,bottom: 3.h),
    child: Column(
      children: [
        // CircleAvatar(radius: 52,
        //   backgroundColor: Colors.white,
        //   backgroundImage:user.image!=null?NetworkImage(Network().baseUrl+user.image!):null ,
        // ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:EdgeInsets.only(right:5.w ,left:5.w ),
                child: Container(
                    height: 12.h,width: 20.w,
                    decoration:  BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft:Radius.circular(30) ,bottomRight: Radius.circular(30)),
                        image: DecorationImage(image: NetworkImage(Network().baseUrl+user.image!))
                    )
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(right:10.w ,left:10.w ),
                child: IconButton(onPressed: () async {
                  var image = await _picker.pickImage(source: ImageSource.gallery);
                  if(image!=null && context.mounted)
                    {
                      List<String> accessTokens=[];
                      for (var school in user.schools!)
                        {
                          accessTokens.add(school.accessToken!);
                        }
                     BlocProvider.of<AccountBloc>(context).add(EditPhotoEvent(image, accessTokens));
                    }
                }, icon: const Icon(Icons.edit,color: Colors.white,)),
              ),


            ]),
        SizedBox(height: 2.h,),
        Text(user.name!,style: TextStyle(fontSize: 14.sp,color: Colors.white,fontWeight: FontWeight.w600),),

      ],
    ),
  );
  Widget buildMenuItems (BuildContext context)=>Container(
    padding: EdgeInsets.all(3.h),
    child: Wrap(
      //runSpacing: 16.0,
      children: [
        ListTile(
          minLeadingWidth:10,
          title: Text("NAVIGATION_DRAWER_PHONE".tr(context),style: const TextStyle(color: Colors.white),),
          leading: Icon(Icons.phone,color:textColor),
          subtitle: Text(user.mobile!,style: const TextStyle(color: Colors.white),),
        ),ListTile(
          minLeadingWidth:10,
          title: Text("NAVIGATION_DRAWER_EMAIL".tr(context),style: const TextStyle(color: Colors.white),),
          leading: Icon(Icons.email,color:textColor),
          subtitle: Text(user.email!,style: const TextStyle(color: Colors.white),),
        ),ListTile(
          minLeadingWidth:10,
          title: Text("NAVIGATION_DRAWER_PASSWORD".tr(context),style: const TextStyle(color: Colors.white),),
          leading: Icon(Icons.password,color:textColor),
          subtitle: const Text("*********",style: TextStyle(color: Colors.white),),
          trailing: IconButton(onPressed: (){
  showDialog(
  context: context,
  builder: (BuildContext context)
  {
    return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: SizedBox(
            height: 8.h,
            child: Card(
                color: primaryColor,
                elevation: 5,
                child: Center(
                    child: Text(
                      "CHOOSE_SCHOOL".tr(context),
                      style: const TextStyle(color: Colors.white),
                    )))),
        content: SizedBox(
            height: 30.h, // Change as per your requirement
            width: 30.w,
            child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) =>
                const Divider(thickness: 1),
                itemCount: user.schools!.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                              color: primaryColor)),
                      onPressed: () =>Go.off(context, ChangePassword(accessToken: user.schools![index].accessToken!)),
                      child: Text(
                          user.schools![index].name!,
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: primaryColor)));
                })));
  });
          },icon: const Icon(Icons.edit,color: Colors.white,)
          ),),

        ListTile(
          minLeadingWidth:10,
          leading: Icon(Icons.info,size: 15.sp,color: textColor,),
          title: Text("NAVIGATION_DRAWER_ABOUT".tr(context),style: TextStyle(fontSize: 13.sp,color: Colors.grey),),
          onTap: null),
        ListTile(
          minLeadingWidth:10,
          leading: Icon(Icons.language,size: 15.sp,color: textColor,),
          title: Text("NAVIGATION_DRAWER_LANGUAGE".tr(context),style: TextStyle(fontSize: 13.sp,color: Colors.white),),
          onTap: (){
            selectLanguage(context);
          },
        ), ListTile(
          minLeadingWidth:10,
          leading: Icon(Icons.logout,size: 15.sp,color: textColor,),
          title: Text("NAVIGATION_DRAWER_LOGOUT".tr(context),style: TextStyle(fontSize: 13.sp,color: Colors.white),),
          onTap: ()async{
            BlocProvider.of<AccountBloc>(context).add(LogoutEvent());
            Go.offALL(context, const LoginPage(isAnother: false));
          },
        ),

      ],
    ),
  );
}
