import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pages/agenda/AgendaScreen.dart';

class NotifiactionService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'scheduled',
          channelName: 'scheduled',
          channelDescription: 'norification chanel for basic tests',
          importance: NotificationImportance.Max,
          defaultColor: Colors.red,
          ledColor: Colors.white,
          channelShowBadge: true,
          onlyAlertOnce: true,
          //playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'scheduled',
          channelGroupName: 'Group 1',
        ),
      ],
      debug: true,
    );
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == true) {
      Get.to(AgendaScreen());
    }
    // Your code goes here
  }

  static Future<void> createScheduleNotification({
    required int id,
    required int badge,
    required String body,
    required String userid,
    required String title,
    required DateTime date,
  }) async {
    try {
      await AwesomeNotifications().createNotification(
        schedule: NotificationCalendar(
          hour: date.hour,
          minute: date.minute,
          allowWhileIdle: true,
          preciseAlarm: true,
        ),
        content: NotificationContent(
            id: id,
            channelKey: 'scheduled',
            title: title,
            body: body,
            badge: badge,
            payload: {'userId': userid}),
      );
      print('sucess sucessfully notif ${id}');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> cancelnotif({
    required int id,
  }) async {
    try {
      await AwesomeNotifications().cancel(id);
      print('sucess deleting notif ${id}');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> cacellll() async {
    try {
      await AwesomeNotifications().cancelAll();
      print('sucess deleting notif');
    } catch (e) {
      print(e);
    }
  }
}
