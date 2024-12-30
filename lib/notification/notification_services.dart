import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/notification/notification_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('Permission_Granted');
    } else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('Provisional_Permission_Granted');
    } else {
      print('Permission_Denied');
    }

  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitializationSettings = DarwinInitializationSettings();

    var initializeSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onDidReceiveNotificationResponse: (payload){
        handleMessage(context, message);
      }
    );
  }

  Future<void> showNotification(RemoteMessage message)async{

    AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'Important Flutter Notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      androidNotificationChannel.id.toString(),
      androidNotificationChannel.name.toString(),
      channelDescription: 'NotificationChannel Description',
      icon: '@mipmap/ic_launcher',
      importance: Importance.high,
      ticker: 'ticker',
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero, (){
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails
      );
    });

  }

  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message){
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print(message.data.toString());
      print(message.data['type']);
      print(message.data['id']);
      if(Platform.isAndroid){
        initLocalNotifications(context, message);
        showNotification(message);
      } else{
        showNotification(message);
      }
    });
  }

  Future<void> setupInteractWhenAppNotOpen(BuildContext context) async {
    // when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event){
      handleMessage(context, event);
    });

    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }
  }

  handleMessage(BuildContext context, RemoteMessage message){
    if(message.data['type'] == 'message'){
      Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => NotificationScreen(id: message.data['id'])));
    }
  }

}