import 'package:flutter/material.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:sizer/sizer.dart';
void confirmationDialog(
    BuildContext context,Function function,String confirmationText) {
  showDialog<bool>(
      context: context,
      builder: (_) =>
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  actionsAlignment: MainAxisAlignment.center,
                  actions: <Widget>[
                    ElevatedButton(
                        child: Text(
                            "Confirm", style: TextStyle(fontSize: 14.sp)),
                        onPressed: () async {
                          function();
                          Go.back(context);
                        }),

                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("DIALOG_BUTTON_CANCEL".tr(context),
                            style: TextStyle(fontSize: 14.sp)))
                  ],
                  title: Text(
                    confirmationText,
                    style: TextStyle(fontSize: 11.sp),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    confirmationText,
                    style: TextStyle(fontSize: 11.sp),
                    textAlign: TextAlign.center,
                  ),
                );
              }));
}