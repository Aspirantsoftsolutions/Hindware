import 'dart:async';

import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/screens/home_screen.dart';
import 'package:SomanyHIL/screens/login_screen.dart';
import 'package:SomanyHIL/viewmodel/login_viewmodel.dart';
import 'package:SomanyHIL/viewmodel/notification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../rest/eightfolds_retrofit.dart';
import '../style/colors.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/SplashScreen';

  SplashScreen({
    Key key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with EDimension {
  String version = '';

  @override
  void initState() {
    super.initState();
    NotificationViewModel().startUpNotification();
    startTime();
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        version = value.version;
      });
    });
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() {
    Utils.getFromSharedPraferances(EightFoldsRetrofit.ACCESS_TOKEN)
        ?.then((value) {
      if (value != null && value.isNotEmpty) {
        LoginViewModel.secureLogin(context).then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        });
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              width: double.maxFinite,
              height: getHeightAsPerScreenRatio(context, 70),
              alignment: Alignment.center,
              child: Image.asset(
                Constants.logo,
                width: getWidthAsPerScreenRatio(context, 80),
                height: getWidthAsPerScreenRatio(context, 51),
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Stack(
              children: [
                Align(
                  child: Container(
                    width: double.maxFinite,
                    height: getHeightAsPerScreenRatio(context, 28),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          const Color(0xFFEF4136),
                          const Color(0xFFF46B29),
                          const Color(0xFFF8931D),
                        ],
                      ),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(
                          getHeightAsPerScreenRatio(context, 28))),
                  child: Container(
                    width: double.maxFinite,
                    height: getHeightAsPerScreenRatio(context, 30),
                    alignment: Alignment.center,
                    color: AppColor.backgroundColor,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: getHeightAsPerScreenRatio(context, 10)),
                    child: Text(
                      'Version $version',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFf000B22).withOpacity(0.6),
                          fontFamily: 'SegoeUI',
                          fontWeight: FontWeight.w400,
                          fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
