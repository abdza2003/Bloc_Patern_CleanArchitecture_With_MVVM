import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/features/account/data/models/child_model.dart';
import 'package:school_cafteria/features/account/presentation/pages/Account/loginpage.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/navigation.dart';
import '../../../../core/network/api.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../domain/entities/user.dart';
import '../bloc/account/account_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is ErrorMsgState) {
            SnackBarMessage()
                .showErrorSnackBar(message: state.message, context: context);
          } else if (state is LoggedOutState) {
            Go.offALL(context, const LoginPage(isAnother: false));
          }
          else if (state is SuccessMsgState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
          }
        },
        child: Scaffold(
          floatingActionButton: _getFAB(true,context),
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    BlocProvider.of<AccountBloc>(context).add(LogoutEvent());
                  },
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.history)),
              ],
              title: Text(
                "APP_NAME".tr(context),
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            body: GroupedListView<ChildModel, String>(
                elements: user.childern!,
                // itemCount: user.childern?.length,
                groupBy: (child) => child.schoolId!,
                useStickyGroupSeparators: true,
                // optional
                groupSeparatorBuilder: (String groupByValue) => Text(
                      "HOME_PAGE_GROUP_BY_SCHOOL".tr(context)+groupByValue,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                itemBuilder: (context, ChildModel childModel) {
                  return SizedBox(
                    height: 30.h,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      elevation: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  side:MaterialStateProperty.all(BorderSide(color: primaryColor)) ,
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                                ),
                                  onPressed: (){}, child: Text("weekly program")),
                              TextButton(
                                  style: ButtonStyle(
                                    side:MaterialStateProperty.all(BorderSide(color: primaryColor)) ,
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                                  ),onPressed: (){}, child: Text("weekly program")),
                              TextButton(
                                  style: ButtonStyle(
                                    side:MaterialStateProperty.all(BorderSide(color: primaryColor)) ,
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                                  ),onPressed: (){}, child: Text("weekly program")),
                              TextButton(
                                  style: ButtonStyle(
                                    side:MaterialStateProperty.all(BorderSide(color: primaryColor)) ,
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                                  ),onPressed: (){}, child: Text("weekly program"))
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "HOME_PAGE_CHILD_NAME".tr(context) + childModel.name!,
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              Text(
                                "HOME_PAGE_CHILD_BALANCE".tr(context) + toCurrencyString(childModel.balance.toString(),trailingSymbol: "TUR",useSymbolPadding:true),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 11.sp),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text("HOME_PAGE_CHILD_STATUE".tr(context)),
                                ],
                              )
                            ],
                          ),
                          Container(
                            child: childModel.image == null
                                ? Image.asset(
                                    'assets/launcher/logo.png',
                                    scale: 15.0,
                                  )
                                : Image(
                                    image: NetworkImage(
                                        Network().baseUrl + childModel.image!),
                                    height: 20.h,
                                    width: 25.w,
                                  ),
                          ),
                        ],
                      ),
                      // child: ListTile(
                      //   minLeadingWidth: 20.w,
                      //   trailing: user.childern![index]
                      //         .image == null ? Image.asset('assets/launcher/logo.png',
                      //       scale: 15.0,) : Image(image: NetworkImage(
                      //         Network().baseUrl + user.childern![index]
                      //             .image!), height: 10.h, width: 20.w,),
                      //     onTap: (){},
                      //   title: Text(user.childern![index].name!),
                      //   subtitle: Text(user.childern![index].balance.toString()),
                      // ),
                    ),
                  );
                })));
  }
  Widget _getFAB(bool canAdd,BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      //animatedIconTheme: IconThemeData(size: 22),
      //backgroundColor: Color(0xFF801E48),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: const Icon(Icons.home_work),
            //backgroundColor: Color(0xFF801E48),
            onTap: () {
              Go.to(context, const LoginPage(isAnother: true));
            },
            label: "HOME_PAGE_FLOAT_BUTTON".tr(context),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 10.sp),
            labelBackgroundColor: primaryColor),
        // FAB 2
        SpeedDialChild(
            visible:canAdd ,
            child: const Icon(Icons.child_care),
            //backgroundColor: Color(0xFF801E48),
            onTap: () {

            },
            label: "HOME_PAGE_FLOAT_BUTTON2".tr(context),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 10.sp),
            labelBackgroundColor: primaryColor
        )
      ],
    );
  }
}
