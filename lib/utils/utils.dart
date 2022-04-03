import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SomanyHIL/rest/eightfolds_retrofit.dart';

class Utils {
  static Future<bool> logout(BuildContext context) async {
    InspectionUtils().assignedInspevtion = [];
    await saveToSharedPraferances(EightFoldsRetrofit.ACCESS_TOKEN, null);
    return true;
  }

  static String getFileUrl(String fileId) {
    // return '${EightFoldsRetrofit.BASE_URL}api/media/file/$fileId';
    return '';
  }

  static String formateDate(
      {String date,
      String formateFrom = 'yyyy-MM-dd HH:mm:ss',
      String formateTo}) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      //  dateTime = dateFormat.parse(date, true).toLocal();
      return DateFormat(formateTo).format(dateTime);
    } catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  static String getNowInUTC() {
    DateTime now = DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(now.toUtc());
  }

  static String getValidMobile(String s) {
    var mobile = s;
    mobile.replaceAll(" ", "");
    mobile.replaceAll("-", "");
    if (mobile.startsWith("+91") || mobile.length > 10) {
      mobile = mobile.substring(mobile.length - 10, mobile.length);
    }
    return mobile;
  }

  static String formateDateInDays(
      {String date, String formateFrom = 'yyyy-MM-dd HH:mm:ss'}) {
    try {
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = dateFormat.parse(date, true).toLocal();
      var value = DateTime(dateTime.year, dateTime.month, dateTime.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
      switch (value) {
        case 0:
          {
            var time = dateTime.toLocal();
            return DateFormat('hh:mm a').format(time);
          }
        case -1:
          return 'Yesterday';
        default:
          return DateFormat('dd MMM').format(dateTime.toLocal());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  static Future<void> setAccessTokenNative(String accessToken) async {
    const plarform = MethodChannel('in.eightfolds/startservice');
    try {
      plarform.invokeMethod(
          'setAccessToken', {EightFoldsRetrofit.ACCESS_TOKEN: accessToken});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> saveToSharedPraferances(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String> getFromSharedPraferances(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static void hideDialog(ProgressDialog pd) {
    if (pd != null && pd.isShowing()) {
      pd.hide();
    }
  }

  static void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void sendEmail(String shareUrl) async {
    final MailOptions mailOptions = MailOptions(
      body:
          'Meditation & yoga teachers can use this app to teach meditations & yoga to students. This is an app that keeps you connected to your students all the time. Now you don\'t have to rely on a messenger app or a Facebook page. You can directly be in touch with your students. You can chat, connect and teach meditations & yoga directly from here.<br><br>Meditation teachers get to engage with students. Teachers find everything they need to conduct a meditation session.<br><br><br>$shareUrl',
      subject: 'Satsanga | Teach meditations & yoga (Early Access)',
      // recipients: ['example@example.com'],
      isHTML: true,
      // bccRecipients: ['other@example.com'],
      // ccRecipients: ['third@example.com'],
      // attachments: [
      //   'path/to/image.png',
      // ],
    );

    await FlutterMailer.send(mailOptions);
  }
}
