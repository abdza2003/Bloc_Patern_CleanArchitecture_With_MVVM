import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/features/account/presentation/bloc/account/account_bloc.dart';
import 'package:school_cafteria/features/account/presentation/pages/account/loginpage.dart';
import 'package:school_cafteria/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:school_cafteria/splash.dart';
import 'package:school_cafteria/test/clip_oval_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
  ));
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('myAccounts');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // print('object')
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    getLocale();
    super.initState();
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  void getLocale() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    setLocale(
      Locale(
        local.getString("lang") ??
            (Platform.localeName.split('_')[0] == 'ar'
                ? 'ar'
                : Platform.localeName.split('_')[0] == 'tr'
                    ? "tr"
                    : 'en'),
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<AccountBloc>()),
          BlocProvider(create: (_) => di.sl<ProductsBloc>()),
          BlocProvider(create: (_) => di.sl<BalanceBloc>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          //locale: DevicePreview.locale(context),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
          title: 'School Cafeteria',
          theme: appTheme,
          supportedLocales: const [Locale('en'), Locale('tr'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          locale: _locale,
          home: Splash(),
        ),
      );
    });
  }
}
