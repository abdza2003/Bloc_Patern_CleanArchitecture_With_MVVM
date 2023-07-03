import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/constants/color_manager.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/core/util/snackbar_message.dart';
import 'package:school_cafteria/features/account/presentation/pages/homepage.dart';
import 'package:school_cafteria/features/account/presentation/pages/notifications.dart';
import 'package:school_cafteria/scrollviewAppbar.dart';
import 'package:school_cafteria/test/app_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'appBar.dart';
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
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.high,
    playSound: true);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// firebase background message handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }
class BottomNav extends StatefulWidget {
  BottomNav({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int count = 0;
  final _scrollController = ScrollController();
  double maxScroll = 0;
  double currentScroll = 0;

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    maxScroll = _scrollController.position.maxScrollExtent;
    currentScroll = _scrollController.offset;
    setState(() {});
  }

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
  }

  @override
  void initState() {
    List<String> accessTokens = [];
    for (var school in widget.user.schools!) {
      accessTokens.add(school.accessToken!);
    }
    BlocProvider.of<AccountBloc>(context)
        .add(GetNotificationEvent(accessTokens));
    initFirebase();
    super.initState();
    _scrollController.addListener(_onScroll);
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
    if (index == 1) {
      _scaffoldKey.currentState!.openDrawer();
    } else {
      setState(() {
        // currentScroll = 0;
        _selectedIndex = index;
      });
    }
  }

  Widget _selectedWidget() {
    if (_selectedIndex == 0) {
      return HomePage(user: widget.user);
    } else if (_selectedIndex == 2) {
      currentScroll = 0;

      List<String> accessTokens = [];
      for (var school in widget.user.schools!) {
        accessTokens.add(school.accessToken!);
      }
      return NotificationPage(accessTokens: accessTokens);
    } else if (_selectedIndex == 3) {
      List<int> studentIds = [];
      for (var child in widget.user.childern!) {
        studentIds.add(child.id!);
      }
      BlocProvider.of<BalanceBloc>(context)
          .add(GetPaymentsEvent(studentIds, null, null));
      return PaymentsPage(
        studentIds: studentIds,
        children: widget.user.childern!,
      );
    } else {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(listener: (context, state) {
      if (state is LoadedNotification) {
        //Counting Notification to Show in Badge
        count = 0;
        if (state.notifications.isNotEmpty) {
          for (var notification in state.notifications) {
            if (notification.status == "0") {
              count++;
            }
          }
        }
      } else if (state is SuccessEditPhotoState) {
        SnackBarMessage()
            .showSuccessSnackBar(message: state.message, context: context);
        setState(() {
          widget.user.image = state.image;
        });
      } else if (state is LoggedInState) {
        setState(() {
          widget.user = state.user;
          print('=============sucess============');
        });
      }
    }, builder: (context, state) {
      return Container(
        width: 100.w,
        height: 100.h,
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
        child: Scaffold(
            // appBar: getAppBar(),
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            drawer: NavigationDrawerProfile(
              user: widget.user,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _getFAB(true, context),
            bottomNavigationBar: FABBottomAppBar(
              backgroundColor: HexColor('#23284E'),
              color: Colors.white38,
              selectedColor: Colors.white,
              onTabSelected: _selectedTab,
              items: [
                FABBottomAppBarItem(
                    iconData: Icons.home,
                    text: "HOME_PAGE_NAVIGATION_HOME".tr(context)),
                FABBottomAppBarItem(
                    iconData: Icons.account_box,
                    text: "HOME_PAGE_NAVIGATION_MY_PROFILE".tr(context)),
                FABBottomAppBarItem(
                    iconData: Icons.notifications,
                    text: "HOME_PAGE_NAVIGATION_NOTIFICATION".tr(context),
                    count: count),
                FABBottomAppBarItem(
                    iconData: Icons.payment,
                    text: "HOME_PAGE_NAVIGATION_PAYMENTS".tr(context)),
              ],
            ),
            body: Container(
              width: 100.w,
              height: 100.h,
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
              child: RefreshIndicator(
                onRefresh: () async {
                  if (_selectedIndex == 0) {
                    List<String> accessTokens = [];
                    for (var school in widget.user.schools!) {
                      accessTokens.add(school.accessToken!);
                    }
                    setState(() {});
                    BlocProvider.of<AccountBloc>(context)
                        .add(RefreshEvent(accessTokens));

                    return Future.value();
                  }
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 22.2.h,
                      pinned: true,
                      centerTitle: true,
                      scrolledUnderElevation: 10,
                      backgroundColor: currentScroll < 16.h
                          ? Colors.transparent
                          : primaryColor,
                      title: currentScroll > 16.h
                          ? Text(
                              'MEDRESE',
                              style: FontManager.impact.copyWith(
                                  color: Colors.white, letterSpacing: 2),
                            )
                          : const SizedBox(),
                      flexibleSpace: scrollviewAppbar(),
                    ),
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          Container(
                            height: 85.h,
                          ),
                          _selectedWidget(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      );
    });
  }

  Widget _getFAB(bool canAdd, BuildContext context) {
    return SpeedDial(
      switchLabelPosition: false,
      childMargin: EdgeInsets.zero,
      visible: true,
      curve: Curves.bounceIn,
      child: ImageIcon(
        const AssetImage("assets/images/add.png"),
        size: 17.sp,
      ),
      children: [
        SpeedDialChild(

            // backgroundColor: Colors.red,
            elevation: 5,
            child: ImageIcon(
              const AssetImage(
                'assets/images/school.png',
              ),
              color: HexColor('#EA4B6F'),
              size: 21.sp,
            ),
            onTap: () {
              Go.to(context, const LoginPage(isAnother: true));
            },
            label: "HOME_PAGE_FLOAT_BUTTON".tr(context),
            labelStyle: FontManager.kumbhSansBold.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 10.sp,
            ),
            labelBackgroundColor: Colors.white),
        // FAB 2
        // SpeedDialChild(
        //     elevation: 5,
        //     visible: canAdd,
        //     child: ImageIcon(
        //       const AssetImage('assets/images/student.png'),
        //       color: HexColor('#EA4B6F'),
        //       size: 21.sp,
        //     ),
        //     onTap: () => showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //               backgroundColor: primaryColor,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(15),
        //               ),
        //               titlePadding: EdgeInsets.zero,
        //               title: SizedBox(
        //                   height: 8.h,
        //                   child: Card(
        //                       shape: RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(15),
        //                       ),
        //                       margin: EdgeInsets.zero,
        //                       color: primaryColor,
        //                       elevation: 10,
        //                       child: Center(
        //                           child: Text(
        //                         "CHOOSE_SCHOOL".tr(context),
        //                         style: const TextStyle(color: Colors.white),
        //                       )))),
        //               content: SizedBox(
        //                   height: 30.h, // Change as per your requirement
        //                   width: 30.w,
        //                   child: ListView.separated(
        //                       shrinkWrap: true,
        //                       separatorBuilder: (context, index) =>
        //                           const Divider(thickness: 1),
        //                       itemCount: widget.user.schools!.length,
        //                       itemBuilder: (context, index) {
        //                         return ElevatedButton(
        //                           style: ElevatedButton.styleFrom(
        //                             fixedSize: Size(0, 5.h),
        //                             shape: RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(15),
        //                             ),
        //                             backgroundColor: Colors.white,
        //                             side: const BorderSide(
        //                               color: primaryColor,
        //                             ),
        //                           ),
        //                           onPressed: () => Go.off(
        //                               context,
        //                               AddChild(
        //                                   accessToken: widget.user
        //                                       .schools![index].accessToken!)),
        //                           child: Text(
        //                             widget.user.schools![index].name!,
        //                             style: FontManager.kumbhSansBold.copyWith(
        //                               fontSize: 17.sp,
        //                               color: primaryColor,
        //                             ),
        //                           ),
        //                         );
        //                       })));
        //         }),
        //     label: "HOME_PAGE_FLOAT_BUTTON2".tr(context),
        //     labelStyle: FontManager.kumbhSansBold.copyWith(
        //       fontWeight: FontWeight.bold,
        //       color: primaryColor,
        //       fontSize: 10.sp,
        //     ),
        //     labelBackgroundColor: Colors.white)
      ],
    );
  }
}

void selectLanguage(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: HexColor('#8D6996'),
            titlePadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: SizedBox(
                height: 8.h,
                child: Card(
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // backgroundColor:,
                    color: HexColor('#8D6996'),
                    elevation: 5,
                    child: Center(
                        child: Text(
                      "HOME_PAGE_CHANGE_LANGUAGE".tr(context),
                      style: FontManager.kumbhSansBold.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    )))),
            content: SizedBox(
                height: 30.h, // Change as per your requirement
                width: 30.w,
                child: ListView(shrinkWrap: true, children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(0, 5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: primaryColor)),
                      onPressed: () async {
                        SharedPreferences local =
                            await SharedPreferences.getInstance();
                        local.setString("lang", "ar");
                        if (context.mounted) {
                          MyApp.of(context)?.setLocale(
                              const Locale.fromSubtags(languageCode: "ar"));
                          Go.back(context);
                        }
                      },
                      child: Text(
                        "Arabic",
                        style: FontManager.kumbhSansBold.copyWith(
                          fontSize: 15.sp,
                          color: HexColor('#777575'),
                        ),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(0, 5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: primaryColor)),
                      onPressed: () async {
                        SharedPreferences local =
                            await SharedPreferences.getInstance();
                        local.setString("lang", "en");
                        if (context.mounted) {
                          MyApp.of(context)?.setLocale(
                              const Locale.fromSubtags(languageCode: "en"));
                          Go.back(context);
                        }
                      },
                      child: Text(
                        "English",
                        style: FontManager.kumbhSansBold.copyWith(
                          fontSize: 15.sp,
                          color: HexColor('#777575'),
                        ),
                      )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(0, 5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: primaryColor)),
                    onPressed: () async {
                      SharedPreferences local =
                          await SharedPreferences.getInstance();
                      local.setString("lang", "tr");
                      if (context.mounted) {
                        MyApp.of(context)?.setLocale(
                            const Locale.fromSubtags(languageCode: "tr"));
                        Go.back(context);
                      }
                    },
                    child: Text(
                      "Turkey",
                      style: FontManager.kumbhSansBold.copyWith(
                        fontSize: 15.sp,
                        color: HexColor('#777575'),
                      ),
                    ),
                  ),
                ])));
      });
}
