import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/util/snackbar_message.dart';
import 'package:school_cafteria/features/account/presentation/pages/homepage.dart';
import 'package:school_cafteria/features/account/presentation/pages/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'bottom_nav_bar.dart';
import 'core/app_theme.dart';
import 'core/navigation.dart';
import 'features/account/domain/entities/user.dart';
import 'features/account/presentation/bloc/account/account_bloc.dart';
import 'features/account/presentation/pages/Account/loginpage.dart';
import 'features/account/presentation/pages/add_child_page.dart';
import 'features/balance/presentation/bloc/balance_bloc.dart';
import 'features/balance/presentation/pages/payments_page.dart';
import 'main.dart';
import 'navigation_drawer.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
class BottomNav extends StatefulWidget {
   const BottomNav({Key? key,required this.user}) : super(key: key);
   final User user;
   @override
   BottomNavState createState() => BottomNavState();
}
class BottomNavState extends State<BottomNav> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int count = 0;

  Future<void> initFirebase() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (mounted) {
      BlocProvider.of<AccountBloc>(context).add(RegisterTokenEvent(fcmToken!));
    }
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // FirebaseMessaging.onMessage.listen((RemoteMessage message){
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //     'high_importance_channel', // id
    //     'High Importance Notifications', // title
    //     importance: Importance.max,
    //   );
    //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //   FlutterLocalNotificationsPlugin();
    //   flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    //       AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //            // icon: notification.android.imageUr,
    //             // other properties...
    //           ),
    //         ));
    //   }
    // });
  }

  @override
  void initState() {
    List<String> accessTokens = [];
    for (var school in widget.user.schools!) {
      accessTokens.add(school.accessToken!);
    }
    BlocProvider.of<AccountBloc>(context).add(
        GetNotificationEvent(accessTokens));
    initFirebase();
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
  }

  int _selectedIndex = 0;

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _selectedWidget() {
    if (_selectedIndex == 0) {
      return HomePage(user: widget.user);
    }
    else if (_selectedIndex == 1) {
      _scaffoldKey.currentState!.openDrawer();
      return HomePage(user: widget.user);
    }
    else if (_selectedIndex == 2) {
      List<String> accessTokens = [];
      for (var school in widget.user.schools!) {
        accessTokens.add(school.accessToken!);
      }
      return NotificationPage(accessTokens: accessTokens);
    }
    else if (_selectedIndex == 3) {
      List<int> studentIds = [];
      for (var child in widget.user.childern!) {
        studentIds.add(child.id!);
      }
      BlocProvider.of<BalanceBloc>(context).add(
          GetPaymentsEvent(studentIds, null, null));
      return PaymentsPage(
        studentIds: studentIds, children: widget.user.childern!,);
    }
    else {
      return Scaffold(body: Container(decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover)),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is LoadedNotification) {
          count=0;
          if (state.notifications.isNotEmpty) {
            for (var notification in state.notifications) {
              if (notification.status == "0") {
                count++;
              }
            }
          }
        }
        else if(state is SuccessEditPhotoState)
          {
            SnackBarMessage().showSuccessSnackBar(message: state.message, context: context);
            setState(() {
              widget.user.image=state.image;
            });
          }
      },
        builder: (context, state) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              extendBodyBehindAppBar: true,
              drawer: NavigationDrawerProfile(user: widget.user,),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(10.h + 10.w),
                child: AppBar(
                    flexibleSpace: Padding(
                      padding: EdgeInsets.only(top: 5.h, right: 38.w),
                      child: Container(
                        height: 8.h + 7.w,
                        decoration: const BoxDecoration(image: DecorationImage(
                            image: AssetImage('assets/launcher/logo.png'))),),
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
              //   // leadingWidth: 30.w,
              //   // leading:
              //   // Row(
              //   //   children: [
              //   //     // IconButton(
              //   //     //   icon: const Icon(Icons.logout),
              //   //     //   onPressed: () {
              //   //     //     BlocProvider.of<AccountBloc>(context).add(LogoutEvent());
              //   //     //     Go.offALL(context, const LoginPage(isAnother: false));
              //   //     //   },),
              //   //     SizedBox(width: 3.w,),
              //   //     SizedBox(
              //   //       width: 27.w,
              //   //       height: 10.h,
              //   //       child: DropdownButtonHideUnderline(
              //   //         child: DropdownButton(
              //   //             dropdownColor:Colors.white,
              //   //             hint:Text("Language",style: TextStyle(color: Colors.white),) ,
              //   //             items: [DropdownMenuItem(
              //   //               value: "en",
              //   //               child: Row(
              //   //                 children: [
              //   //                   SizedBox(
              //   //                       width: 20.w,
              //   //                       child: Text(
              //   //                         textAlign: TextAlign.center,
              //   //                         "English",
              //   //                         style: TextStyle(fontSize: 14.sp),
              //   //                       )),
              //   //                 ],
              //   //               ),
              //   //             ),DropdownMenuItem(
              //   //               value: "ar",
              //   //               child: Row(
              //   //                 children: [
              //   //                   SizedBox(
              //   //                       width: 20.w,
              //   //                       child: Text(
              //   //                         "Arabic",
              //   //                         textAlign: TextAlign.center,
              //   //                         style: TextStyle(fontSize: 14.sp),
              //   //                       )),
              //   //                 ],
              //   //               ),
              //   //             ),
              //   //               DropdownMenuItem(
              //   //                 value: "tr",
              //   //                 child: Row(
              //   //                   children: [
              //   //                     SizedBox(
              //   //                         width: 20.w,
              //   //                         child: Text(
              //   //                           "Turkey",
              //   //                           textAlign: TextAlign.center,
              //   //                           style: TextStyle(fontSize: 14.sp),
              //   //                         )),
              //   //                   ],
              //   //                 ),
              //   //               ),
              //   //             ], onChanged: (String? lang) async {
              //   //           SharedPreferences local= await SharedPreferences.getInstance();
              //   //           local.setString("lang", lang!);
              //   //           if(mounted) {
              //   //             MyApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: lang));
              //   //           }
              //   //         }),
              //   //       ),
              //   //     ),
              //   //     // ), IconButton(
              //   //     //   icon: const Icon(Icons.logout),
              //   //     // //  onPressed: () => MyApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'ar')),
              //   //     //
              //   //     // ),
              //   //   ],
              //   // ),
              //   // actions: [
              //   //   // ElevatedButton.icon(
              //   //   //   onPressed: () {},
              //   //   //   icon: const Icon(Icons.history),
              //   //   //   label: Text("HOME_PAGE_BUTTON5".tr(context)),
              //   //   // ),
              //   // ],
              //   title: Text(
              //     "APP_NAME".tr(context),
              //     style: TextStyle(fontSize: 14.sp),
              //   ),
              // ),


              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerDocked,
              floatingActionButton: _getFAB(true, context),
              bottomNavigationBar: FABBottomAppBar(
                backgroundColor: oldPrimaryColor,
                color: Colors.white38,
                selectedColor: Colors.white,
                onTabSelected: _selectedTab,
                items: [
                  FABBottomAppBarItem(iconData: Icons.home, text: "HOME_PAGE_NAVIGATION_HOME".tr(context)),
                  FABBottomAppBarItem(
                      iconData: Icons.account_box, text: "HOME_PAGE_NAVIGATION_MY_PROFILE".tr(context)),
                  FABBottomAppBarItem(iconData: Icons.notifications,
                      text: "HOME_PAGE_NAVIGATION_NOTIFICATION".tr(context),
                      count: count),
                  FABBottomAppBarItem(
                      iconData: Icons.payment, text: "HOME_PAGE_NAVIGATION_PAYMENTS".tr(context)),
                ],
              ),
              body: Container(
                  decoration: const BoxDecoration(image: DecorationImage(
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.repeat,
                      image: AssetImage('assets/images/bg.png'))),
                  child: _selectedWidget()));
        }
    );
  }

  Widget _getFAB(bool canAdd, BuildContext context) {
    return SpeedDial(
      backgroundColor: secondaryColor2,
      childMargin: EdgeInsets.zero,
      //animatedIconTheme: IconThemeData(size: 22),
      //backgroundColor: Color(0xFF801E48),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: ImageIcon(
              const AssetImage('assets/images/school.png'),
              color: Colors.red,
              size: 24.sp,
            ),
            //backgroundColor: Color(0xFF801E48),
            onTap: () {
              Go.to(context, const LoginPage(isAnother: true));
            },
            label: "HOME_PAGE_FLOAT_BUTTON".tr(context),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: primaryColor,
                fontSize: 10.sp),
            labelBackgroundColor: Colors.white),
        // FAB 2
        SpeedDialChild(
            visible: canAdd,
            child: ImageIcon(
              const AssetImage('assets/images/student.png'),
              color: Colors.red,
              size: 24.sp,
            ),
            //backgroundColor: Color(0xFF801E48),
            onTap: () =>
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
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
                                  itemCount: widget.user.schools!.length,
                                  itemBuilder: (context, index) {
                                    return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                                color: primaryColor)),
                                        onPressed: () =>
                                            Go.off(
                                                context,
                                                AddChild(
                                                    accessToken: widget.user
                                                        .schools![index]
                                                        .accessToken!)),
                                        child: Text(
                                            widget.user.schools![index].name!,
                                            style: TextStyle(
                                                fontSize: 17.sp,
                                                color: primaryColor)));
                                  })));
                    }),
            //Go.to(context, const AddChild());
            label: "HOME_PAGE_FLOAT_BUTTON2".tr(context),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: primaryColor,
                fontSize: 10.sp),
            labelBackgroundColor: Colors.white
        )
      ],
      //  animatedIcon: AnimatedIcons.add_event,
      child: ImageIcon(
        const AssetImage("assets/images/add.png"),
        size: 17.sp,
      ),
    );
  }
}
  void selectLanguage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: EdgeInsets.zero,
              title: SizedBox(
                  height: 8.h,
                  child: Card(
                      color: primaryColor,
                      elevation: 5,
                      child:  Center(
                          child: Text(
                            "HOME_PAGE_CHANGE_LANGUAGE".tr(context),
                            style: const TextStyle(color: Colors.white),
                          )))),
              content: SizedBox(
                  height: 30.h, // Change as per your requirement
                  width: 30.w,
                  child: ListView(
                      shrinkWrap: true,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: primaryColor)),
                            onPressed: () async {
                              SharedPreferences local = await SharedPreferences
                                  .getInstance();
                              local.setString("lang", "ar");
                              if (context.mounted) {
                                MyApp.of(context)?.setLocale(const Locale.fromSubtags(languageCode: "ar"));
                                Go.back(context);
                              }
                            },
                            child: Text(
                                "Arabic",
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    color: primaryColor))), ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: primaryColor)),
                            onPressed: () async {
                                          SharedPreferences local= await SharedPreferences.getInstance();
                                          local.setString("lang", "en");
                                          if(context.mounted) {
                                            MyApp.of(context)?.setLocale(const Locale.fromSubtags(languageCode: "en"));
                                            Go.back(context);
                                          }

                            },
                            child: Text(
                                "English",
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    color: primaryColor))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: primaryColor)),
                            onPressed: () async {
                                          SharedPreferences local= await SharedPreferences.getInstance();
                                          local.setString("lang", "tr");
                                          if(context.mounted) {
                                            MyApp.of(context)?.setLocale(const Locale.fromSubtags(languageCode: "tr"));
                                            Go.back(context);
                                          }

                            },
                            child: Text(
                                "Turkey",
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    color: primaryColor))),
                      ])));
        });
  }






