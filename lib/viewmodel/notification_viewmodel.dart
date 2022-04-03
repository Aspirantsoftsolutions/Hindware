import 'package:SomanyHIL/locator.dart';
import 'package:SomanyHIL/services/push_notification_service.dart';

class NotificationViewModel {
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  Future startUpNotification() async {
    await _pushNotificationService.initialise();
  }
// Not required
  // Future onDidReceiveLocalNotification(
  //     int id, String title, String body, String payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title),
  //       content: Text(body),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => SplashScreen(),
  //               ),
  //             );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
}
