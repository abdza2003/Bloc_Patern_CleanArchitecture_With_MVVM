import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          CircularProgressIndicator(color: oldPrimaryColor,),
        ],
      ),
    );
  }
}
