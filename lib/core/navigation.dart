import 'package:flutter/material.dart';
class Go {

static void to (BuildContext context, Widget widget) { Navigator.push(context, MaterialPageRoute(builder:(_) =>  widget)); }

static void off (BuildContext context, Widget widget, [bool showRouteNavigation = true]) async {

if (showRouteNavigation) { Navigator.pushReplacement (context, MaterialPageRoute (builder:(_) => widget));
return;
}
Navigator.push(
context,
PageRouteBuilder (pageBuilder: (_,__,___) => widget),

);
}

static void offALL (BuildContext context, Widget widget) async {

Navigator.pushAndRemoveUntil(context, MaterialPageRoute (builder:(_) =>  widget), (_) => false); }

static void back (BuildContext context) async { Navigator.pop(context);

}
}