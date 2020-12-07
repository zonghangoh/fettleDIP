import 'package:flutter/material.dart';
import 'package:halpla/src/providers/friends.dart';
import 'package:halpla/src/screens/addfriend.dart';
import 'package:halpla/src/screens/quest.dart';
import 'package:provider/provider.dart';
import 'src/providers/auth.dart';
import 'src/providers/avatar.dart';
import 'src/providers/exercise.dart';
import 'src/providers/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/screens/shop.dart';
import 'src/screens/home.dart';
import 'src/screens/login.dart';
import 'src/screens/exercise.dart';
import 'src/screens/airport.dart';
import 'src/screens/conversation.dart';
import 'src/screens/call.dart';
import 'src/screens/social.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage');
      // showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onReesumme');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch');
      return;
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'co.fettle.android' : 'co.fettle.ios',
      'Fettle',
      'Fettle Push Notifications',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.Max,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState != ConnectionState.done) {
            return Container(color: Colors.black);
          }
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => AuthProvider()),
                ChangeNotifierProxyProvider<AuthProvider, AvatarProvider>(
                  create: (ctx) => AvatarProvider(),
                  update: (ctx, auth, prevAvatar) => prevAvatar..update(auth),
                ),
                ChangeNotifierProxyProvider<AuthProvider, ExerciseProvider>(
                  create: (ctx) => ExerciseProvider(),
                  update: (ctx, auth, prevExercise) =>
                      prevExercise..update(auth),
                ),
                ChangeNotifierProxyProvider<AuthProvider, FriendsProvider>(
                  create: (ctx) => FriendsProvider(),
                  update: (ctx, auth, prevExercise) =>
                      prevExercise..update(auth),
                ),
                ChangeNotifierProxyProvider<AuthProvider,
                    NotificationsProvider>(
                  create: (ctx) => NotificationsProvider(),
                  update: (ctx, auth, prevExercise) =>
                      prevExercise..update(auth),
                ),
              ],
              child: Consumer<AuthProvider>(builder: (ctx, auth, _) {
                Key key = new UniqueKey();
                return MaterialApp(
                    key: key,
                    title: 'Fettle',
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                    ),
                    home: auth.isLoggedIn ? HomeScreen() : LoginScreen(),
                    routes: {
                      HomeScreen.id: (context) => HomeScreen(),
                      LoginScreen.id: (context) => LoginScreen(),
                      ShopScreen.id: (context) => ShopScreen(),
                      ExerciseScreen.id: (context) => ExerciseScreen(),
                      AirportScreen.id: (context) => AirportScreen(),
                      TaskScreen.id: (context) => TaskScreen(),
                      SocialScreen.id: (context) => SocialScreen(),
                      SearchScreen.id: (context) => SearchScreen(),
                      VideoRoom.id: (context) => VideoRoom(),
                      ConversationScreen.id: (context) => ConversationScreen()
                    });
              }));
        });
  }
}
