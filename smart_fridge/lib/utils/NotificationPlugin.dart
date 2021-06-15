

import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:smart_fridge/models/Product.dart';

class NotificationPlugin {
  //
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification> didReceivedLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('ic_stat_name');

    initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          onNotificationClick(payload);
        });
  }

  Future<void> scheduleNotification(String name, String expirationDate) async {
    final DateTime now = DateTime.now();
    List<String> stringExpiration = expirationDate.split('/');
    String savedDateString = "";
    if(stringExpiration.length == 3)
      savedDateString = stringExpiration[2] + '-' + stringExpiration[1] + '-' + stringExpiration[0];
    else{
      stringExpiration = expirationDate.split('.');
      if(stringExpiration.length == 3){
        savedDateString = stringExpiration[2] + '-' + stringExpiration[1] + '-' + stringExpiration[0];
      }else
        savedDateString = expirationDate;
    }

    final DateTime expirationDateTime = new DateFormat("yyyy-MM-dd").parse(savedDateString);
    int difference = expirationDateTime.difference(now).inSeconds;
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      "CHANNEL_DESCRIPTION 1",
      icon: '@mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      0,
      name,
      'The product has expired!',
      scheduleNotificationDateTime,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

  // Future<void> showNotificationWithAttachment() async {
  //   var attachmentPicturePath = await _downloadAndSaveFile(
  //       'https://via.placeholder.com/800x200', 'attachment_img.jpg');
  //   var iOSPlatformSpecifics = IOSNotificationDetails(
  //     attachments: [IOSNotificationAttachment(attachmentPicturePath)],
  //   );
  //   var bigPictureStyleInformation = BigPictureStyleInformation(
  //     FilePathAndroidBitmap(attachmentPicturePath),
  //     contentTitle: '<b>Attached Image</b>',
  //     htmlFormatContentTitle: true,
  //     summaryText: 'Test Image',
  //     htmlFormatSummaryText: true,
  //   );
  //   var androidChannelSpecifics = AndroidNotificationDetails(
  //     'CHANNEL ID 2',
  //     'CHANNEL NAME 2',
  //     'CHANNEL DESCRIPTION 2',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     styleInformation: bigPictureStyleInformation,
  //   );
  //   var notificationDetails =
  //   NotificationDetails(android: androidChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Title with attachment',
  //     'Body with Attachment',
  //     notificationDetails,
  //   );
  // }
  //
  // _downloadAndSaveFile(String url, String fileName) async {
  //   var directory = await getApplicationDocumentsDirectory();
  //   var filePath = '${directory.path}/$fileName';
  //   var response = await http.get(url);
  //   var file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({ this.id, this.title, this.body, this.payload,});
}
