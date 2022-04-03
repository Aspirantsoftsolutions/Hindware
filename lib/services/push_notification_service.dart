import 'dart:convert';
import 'dart:io';

import 'package:SomanyHIL/model/common_response.dart';
import 'package:SomanyHIL/rest/eightfolds_retrofit.dart';
import 'package:broadcast_events/broadcast_events.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info/package_info.dart';
import 'package:SomanyHIL/locator.dart';
import 'package:SomanyHIL/model/user_device.dart';
import 'package:SomanyHIL/model/notification.dart';
import 'package:SomanyHIL/services/local_notification_service.dart';
import 'package:SomanyHIL/services/navigation_service.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/utils.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationAppLaunchDetails notificationAppLaunchDetails;
  final NavigationService _navigationService = locator<NavigationService>();

  Future initialise() async {
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    await initLocalNotifications(flutterLocalNotificationsPlugin);

    if (Platform.isIOS) {
      // request permissions if we're on android
      _fcm.requestNotificationPermissions(IosNotificationSettings());
      requestIOSPermissions(flutterLocalNotificationsPlugin);
    }

    _fcm.getToken().then((token) {
      debugPrint('Firebase Token: $token');
      Utils.saveToSharedPraferances(Constants.PUSH_REG_ID, token);
    });

    _fcm.configure(
      // Called when the app is in the foreground and we receive a push notification
      onMessage: (Map<String, dynamic> message) async {
        debugPrint('onMessage: $message');
        var notification = _serialiseNotificationMessage(message);
        if (notification != null) {
          _notifyToRefreshScreen(notification);
          showNotification(
              PushNotificationService.flutterLocalNotificationsPlugin,
              notification);
        }
      },
      // Called when the app has been closed comlpetely and it's opened
      // from the push notification.
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('onLaunch: $message');
        var notificationMsg = _serialiseNotificationMessage(message);
        Utils.saveToSharedPraferances(
            Constants.NOTIFICATION_MESSAGE, jsonEncode(notificationMsg));
        _switchAndNotifyScreen(notificationMsg);
      },
      // Called when the app is in the background and it's opened
      // from the push notification.
      onResume: (Map<String, dynamic> message) async {
        debugPrint('onResume: $message');
        _switchAndNotifyScreen(_serialiseNotificationMessage(message));
      },
    );
  }

  static Future submitDeviceInfo() async {
    var pushRegId = await Utils.getFromSharedPraferances(Constants.PUSH_REG_ID);
    if (pushRegId == null) return;
    var userDevice = UserDevice();
    userDevice.pushRegId = pushRegId;
    // var uuid = await ImeiPlugin.getId();
    String udid = await FlutterUdid.udid;
    userDevice.imei = udid;
    userDevice.platformId = Platform.isAndroid ? 1 : 2;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    userDevice.appPackage = packageInfo.packageName;
    try {
      var result = await EightFoldsRetrofit()
          .getSecureRetrofitService()
          .then((value) => value.updateDeviceInfo(userDevice));
      return result;
    } catch (error) {
      final data = error.response.data;
      if (data != null) {
        var commonResponse = CommonResponse.fromJson(data);
        if (commonResponse.code == 401) {
          var restClient =
              await EightFoldsRetrofit().getSecureRetrofitService();
          var result = await restClient.getRefreshToken();
          await Utils.saveToSharedPraferances(
              EightFoldsRetrofit.ACCESS_TOKEN, result.token);
          debugPrint('');
        }
      }
      throw error;
    }
  }

  MyNotification _serialiseNotificationMessage(Map<String, dynamic> message) {
    // UiUtils.showMyToast(message: '${message.toString()}');
    var notification;
    if (Platform.isAndroid) {
      var notificationData = message['data'];
      if (notificationData != null) {
        notification = MyNotification();
        notification.id = notificationData['id'];
        notification.message = notificationData['message'];
        notification.title = notificationData['title'];
        notification.type = notificationData['type'];
        notification.fromUserName = notificationData['fromUserName'];
        notification.fromUserId = notificationData['fromUserId'];
        notification.messageGroupId = notificationData['messageGroupId'];
      }
    } else {
      notification = MyNotification();
      notification.id = message['id'];
      notification.message = message['message'];
      notification.title = message['title'];
      notification.type = message['type'];
      notification.fromUserName = message['fromUserName'];
      notification.fromUserId = message['fromUserId'];
      notification.messageGroupId = message['messageGroupId'];
    }

    return notification;
  }

  _notifyToRefreshScreen(MyNotification notification) {
    switch (notification?.type ?? '') {
      case Constants.NOTIFICATION_TYPE_COMMENT:
        BroadcastEvents()
            .publish(Constants.REFRESH_COMMENT, arguments: notification);
        break;
    }
  }

  _switchAndNotifyScreen(MyNotification notification) {
    _notifyToRefreshScreen(notification);
    BroadcastEvents().publish(Constants.SWITCH_SCREEN_ON_NOTIFICATION_TAP,
        arguments: notification);
  }
}
