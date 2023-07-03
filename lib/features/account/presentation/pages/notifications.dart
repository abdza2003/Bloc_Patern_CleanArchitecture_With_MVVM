import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/features/account/presentation/bloc/account/account_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/loading_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, required this.accessTokens})
      : super(key: key);

  final List<String> accessTokens;
  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<NotificationPage> {
  @override
  void initState() {
    BlocProvider.of<AccountBloc>(context)
        .add(GetNotificationEvent(widget.accessTokens));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(listener: (context, state) {
      if (state is ErrorMsgState) {
        SnackBarMessage()
            .showErrorSnackBar(message: state.message, context: context);
      } else if (state is SuccessDeleteNotificationState) {
        SnackBarMessage()
            .showSuccessSnackBar(message: state.message, context: context);
        BlocProvider.of<AccountBloc>(context)
            .add(GetNotificationEvent(widget.accessTokens));
      }
    }, buildWhen: (accountBloc, accountState) {
      if (accountState is LoadedNotification) {
        return true;
      } else {
        return false;
      }
    }, builder: (
      context,
      state,
    ) {
      if (state is LoadedNotification) {
        return state.notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 50.sp,
                      color: Colors.white60,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "NOTIFICATIONS_EMPTY".tr(context),
                      style: FontManager.kumbhSansBold.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.notifications.length,
                itemBuilder: (_, int index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(left: 7.w, right: 7.w, bottom: 1.h),
                    child: Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                            bottomRight: Radius.zero),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          color: Colors.white.withOpacity(.57),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomRight: Radius.zero),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.55),
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                              offset: Offset(0, -5),
                            )
                          ],
                        ),
                        child: SizedBox(
                          height: 14.h + 10.w,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 4.h,
                                child: Center(
                                  child: AutoSizeText(
                                    state.notifications[index].title!,
                                    style: FontManager.kumbhSansBold.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 7.h + 2.w,
                                child: Center(
                                  child: AutoSizeText(
                                    state.notifications[index].body!,
                                    style: FontManager.kumbhSansBold.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      confirmationDialog(
                                        context,
                                        () {
                                          BlocProvider.of<AccountBloc>(context)
                                              .add(
                                            DeleteNotificationEvent(
                                              state.notifications[index].id!,
                                            ),
                                          );
                                        },
                                        "NOTIFICATIONS_DELETE_CONFIRMATION"
                                            .tr(context),
                                      );
                                      // BlocProvider.of<AccountBloc>(context).add(DeleteNotificationEvent(state.notifications[index].id!));
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
      } else {
        return const LoadingWidget();
      }
    });
  }
}
