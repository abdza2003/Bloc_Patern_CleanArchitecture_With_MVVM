import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding:  EdgeInsets.symmetric(vertical: 25.h),
        child: Center(
          child: SizedBox(
            height: 25.h,
            width: 40.w,
            child: CircularProgressIndicator(
              color: pc2,
            ),
          ),
        ),
    );
  }
}
