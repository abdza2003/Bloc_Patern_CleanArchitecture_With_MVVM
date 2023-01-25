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
          } else if (state is SuccessMsgState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
          }
        },
        child: Scaffold(
            floatingActionButton: _getFAB(true, context),
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
                groupBy: (child) => child.school!.name!,
                useStickyGroupSeparators: true,
                // optional
                groupSeparatorBuilder: (String groupByValue) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            groupByValue,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                itemBuilder: (context, ChildModel childModel) {
                  final name = TextEditingController();
                  name.text="mohammad alaa hallabo hallabo hallabo";
                  final balance = TextEditingController();
                  balance.text=toCurrencyString(
                                  childModel.balance.toString(),
                                  trailingSymbol: "TUR",
                                  useSymbolPadding: true);
                  return SizedBox(
                    height: 30.h,
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: pc2.withOpacity(0.3),
                          blurRadius: 20.0,
                        )
                      ]),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        elevation: 10,
                        child: Row( mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                             color: pc2.withOpacity(0.2),
                              width: 38.w,
                              height: 100.h,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  childModel.image == null
                                      ? Image.asset(
                                    'assets/launcher/logo.png',
                                    scale: 25.0,
                                  )
                                      : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                            child:Image(
                                    image: NetworkImage(Network().baseUrl +
                                        childModel.image!),
                                    width: 30.w,
                                    )),
                                  // Container(
                                  //   decoration: BoxDecoration,
                                  // )

                                  // Row(
                                  //   children: [
                                  //     Icon(Icons.account_balance_wallet),
                                  //     SizedBox(width: 5.w,),
                                  //     Text(
                                  //           toCurrencyString(
                                  //               childModel.balance.toString(),
                                  //               trailingSymbol: "TUR",
                                  //               useSymbolPadding: true),
                                  //       style: TextStyle(
                                  //           color: Colors.black, fontSize: 11.sp),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 60.w,
                                  height: 12.h,
                                  child: Column(children: [

                                  SizedBox(
                                  height: 7.h,
                                    width: 60.w,
                                    child:TextField(
                                      style: TextStyle(fontSize: 13.sp),
                                      decoration: InputDecoration(
                                        //contentPadding: EdgeInsets.symmetric(vertical: 6),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.person,color: primaryColor,),

                                      ),
                                      readOnly:true,
                                            controller:name ,
                                          )),
                                          SizedBox(
                                  height: 5.h,
                                    width: 60.w,
                                    child:TextField(
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 1),
                                      border: InputBorder.none,
                                        prefixIcon: Icon(Icons.account_balance_wallet,color: primaryColor,),

                                      ),
                                      readOnly:true,
                                            controller:balance ,
                                          ))


                                        ],
                                      ),

                                  ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(28.w, 7.h),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0)),
                                        ),
                                        onPressed: () {},
                                        icon: Icon(
                                          // <-- Icon
                                          Icons.calendar_month,
                                          size: 16.sp,
                                        ),
                                        label: Text(
                                          "HOME_PAGE_BUTTON1".tr(context),
                                          style: TextStyle(fontSize: 9.sp),
                                        ), // <-- Text
                                      ),
                                    ),
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(28.w, 7.h),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0)),
                                        ),
                                        onPressed: () {},
                                        icon: Icon(
                                          // <-- Icon
                                          Icons.not_interested,
                                          size: 16.sp,
                                        ),
                                        label: Text(
                                          "HOME_PAGE_BUTTON2".tr(context),
                                          style: TextStyle(fontSize: 9.sp),
                                        ), // <-- Text
                                    ),
                                     )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(28.w, 7.h),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0)),
                                        ),
                                        onPressed: () {},
                                        icon: Icon(
                                          // <-- Icon
                                          Icons.receipt,
                                          size: 16.sp,
                                        ),
                                        label: Text(
                                          "HOME_PAGE_BUTTON3".tr(context),
                                          style: TextStyle(fontSize: 9.sp),
                                        ), // <-- Text
                                    ),
                                     ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(28.w, 7.h),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0)),
                                        ),
                                        onPressed: () {},
                                        icon: Icon(
                                          // <-- Icon
                                          Icons.receipt,
                                          size: 16.sp,
                                        ),
                                        label: Text(
                                          "HOME_PAGE_BUTTON3".tr(context),
                                          style: TextStyle(fontSize: 9.sp),
                                        ), // <-- Text
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          ],
                        ),
                        // child: Column(
                        //   children: [
                        //     Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //
                        //         Column(
                        //           children: [
                        //             Text(
                        //               "HOME_PAGE_CHILD_NAME".tr(context) + childModel.name!,
                        //               style: TextStyle(fontSize: 15.sp),
                        //             ),
                        //             SizedBox(height: 2.h,),
                        //             Row(
                        //               children: [
                        //                 Text(
                        //                   "HOME_PAGE_CHILD_BALANCE".tr(context) + toCurrencyString(childModel.balance.toString(),trailingSymbol: "TUR",useSymbolPadding:true),
                        //                   style: TextStyle(
                        //                       color: Colors.black54, fontSize: 11.sp),
                        //                 ),
                        //                 IconButton(onPressed: (){}, icon: Icon(
                        //                     Icons.add_circle_outline,))
                        //               ],
                        //             ),
                        //             SizedBox(height: 2.h,),
                        //             Row(
                        //               children: [
                        //                 const Icon(
                        //                   Icons.check_circle,
                        //                   color: Colors.green,
                        //                 ),
                        //                 SizedBox(
                        //                   width: 5.w,
                        //                 ),
                        //                 Text("HOME_PAGE_CHILD_STATUE".tr(context)),
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //         Column(
                        //           children:[ childModel.image == null
                        //               ? Image.asset(
                        //                   'assets/launcher/logo.png',
                        //                   scale: 15.0,
                        //                 )
                        //               : Image(
                        //                   image: NetworkImage(
                        //                       Network().baseUrl + childModel.image!),
                        //                   height: 20.h,
                        //                   width: 25.w,
                        //                 ),
                        //         ]),
                        //
                        //       ],
                        //     ),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: Icon( // <-- Icon
                        //             Icons.calendar_month,
                        //             size: 11.sp,
                        //           ),
                        //           label: Text("HOME_PAGE_BUTTON1".tr(context),style: TextStyle(fontSize: 8.sp),), // <-- Text
                        //         ),ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: Icon( // <-- Icon
                        //             Icons.not_interested,
                        //             size: 11.sp,
                        //           ),
                        //           label: Text("HOME_PAGE_BUTTON2".tr(context),style: TextStyle(fontSize: 8.sp),), // <-- Text
                        //         ),ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: Icon( // <-- Icon
                        //             Icons.receipt,
                        //             size: 11.sp,
                        //           ),
                        //           label: Text("HOME_PAGE_BUTTON3".tr(context),style: TextStyle(fontSize: 8.sp),), // <-- Text
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
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
                    ),
                  );
                })));
  }

  Widget _getFAB(bool canAdd, BuildContext context) {
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
            visible: canAdd,
            child: const Icon(Icons.child_care),
            //backgroundColor: Color(0xFF801E48),
            onTap: () {},
            label: "HOME_PAGE_FLOAT_BUTTON2".tr(context),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 10.sp),
            labelBackgroundColor: primaryColor)
      ],
    );
  }
}
