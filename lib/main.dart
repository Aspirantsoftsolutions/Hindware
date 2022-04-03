import 'package:SomanyHIL/locator.dart';
import 'package:SomanyHIL/screens/data_maintain_screen.dart';
import 'package:SomanyHIL/screens/home_screen.dart';
import 'package:SomanyHIL/screens/login_screen.dart';
import 'package:SomanyHIL/screens/splash_screen.dart';
import 'package:SomanyHIL/style/theme.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.APP_NAME,
      theme: kLightThemeData,
      darkTheme: kDarkThemeData,
      themeMode: ThemeMode.light,
      home: SplashScreen(),
      routes: {
        SplashScreen.routeName: (_) => SplashScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        DataMaintainScreen.routeName: (_) => DataMaintainScreen(null),
      },
    );
  }
}
