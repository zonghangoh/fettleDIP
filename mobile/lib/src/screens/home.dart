import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:halpla/src/screens/exercise.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/avatar.dart';
import '../providers/friends.dart';
import '../providers/notifications.dart';
import '../models/notification.dart';
import '../helpers/passport.dart';
import '../constants/ui.dart';
import 'shop.dart';
import 'airport.dart';
import 'quest.dart';
import 'social.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/social/friend.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  Future fetchBioData;
  int index = 0;

  Stream notificationStream;
  Stream presenceStream;

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  AudioCache audioCache;
  AudioPlayer advancedPlayer;

  @override
  void initState() {
    super.initState();
    advancedPlayer = AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    //kimee's fake notifs
    // Provider.of<FriendsProvider>(context, listen: false)
    //     .sendFriendRequest('MHImEvfarYgVqf63W7jAQRUd19m1', 'Imposterrrr');

    // Provider.of<FriendsProvider>(context, listen: false)
    //     .sendPet('MHImEvfarYgVqf63W7jAQRUd19m1', 'Molester');
    fetchBioData =
        Provider.of<AvatarProvider>(context, listen: false).fetchBioData();
    notificationStream = FirebaseFirestore.instance
        .collection('notifications')
        .doc(Provider.of<AuthProvider>(context, listen: false).userId)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .limit(10)
        .snapshots();

    presenceStream = FirebaseFirestore.instance
        .collection('presence')
        .doc(Provider.of<AuthProvider>(context, listen: false).userId)
        .snapshots();
    FirebaseFirestore.instance
        .collection('presence')
        .doc(Provider.of<AvatarProvider>(context, listen: false).auth.userId)
        .update({
      'online': false,
      'lastOnline': DateTime.now().millisecondsSinceEpoch,
      'chatRoom': '',
    });
    firebaseMessaging.getToken().then((token) async {
      if (token == '' || token == null) return;
      print('token: ' + token);
      FirebaseFirestore.instance
          .collection('avatars')
          .doc(Provider.of<AvatarProvider>(context, listen: false).auth.userId)
          .update({
        'pushToken': token,
      });
    });
  }

  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Widget renderNotification(FettleNotification notification) {
    return NotificationMessage(notification: notification);
  }

  void openNotifications() async {
    await Provider.of<NotificationsProvider>(context, listen: false)
        .fetchNotifications();
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
                child: Container(
                    color: Colors.transparent,
                    child: new Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: new BoxDecoration(
                            color: lightYellow,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0))),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 20.0), // content padding
                            child: ListView(
                              reverse: true,
                              children: [
                                SizedBox(height: 20),
                                Text("INBOX".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.fredokaOne(
                                        fontSize: 12, color: Colors.black)),
                                SizedBox(height: 20),
                                ...Provider.of<NotificationsProvider>(context)
                                    .notifications
                                    .reversed
                                    .map((e) {
                                  return renderNotification(e);
                                })

                                // TextField(),
                              ],
                            )))));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: fetchBioData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              Provider.of<AvatarProvider>(context, listen: false).onboarded) {
            return Scaffold(
                backgroundColor: veryLightBlue,
                body: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Passport.getCountryBG(
                                Provider.of<AvatarProvider>(context).country)),
                            fit: BoxFit.cover)),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 25),
                            padding: EdgeInsets.only(right: 25, left: 25),
                            width: MediaQuery.of(context).size.width * 0.90,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StepsProgressBar(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 4),
                                    child: Image.asset(
                                      'assets/coin.png',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: AutoSizeText(
                                          ' ' +
                                              Provider.of<AvatarProvider>(
                                                      context,
                                                      listen: false)
                                                  .coinsLeft
                                                  .toString(),
                                          style: GoogleFonts.fredokaOne(
                                              fontSize: 12,
                                              color: Colors.blueGrey)),
                                    ),
                                  )
                                ])),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    ' ' +
                                        Provider.of<AvatarProvider>(context)
                                            .name,
                                    style: GoogleFonts.fredokaOne(
                                        fontSize: 16, color: Colors.blueGrey))
                              ]),
                        ),
                        Expanded(
                            key: ValueKey(index),
                            child: Container(
                                child: index == 1
                                    ? Lottie.asset(
                                        'assets/NormalCatWaving.json')
                                    : CatAvatar(
                                        cat:
                                            Provider.of<AvatarProvider>(context)
                                                .myCat))),
                        // Expanded(
                        //     key: ValueKey(index),
                        //     child: Lottie.asset(index == 0
                        //         ? 'assets/situps.json'
                        //         : 'assets/squats.json')),
                        // controller: catController,
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .smsLogout,
                                  child: Image.asset(Passport.getCountryFlag(
                                      Provider.of<AvatarProvider>(context)
                                          .country)),
                                ),
                                Text(
                                    ' ' +
                                        Provider.of<AvatarProvider>(context)
                                            .country,
                                    style: GoogleFonts.fredokaOne(
                                        fontSize: 16, color: Colors.blueGrey))
                              ]),
                        ),
                        Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(bottom: 25),
                                    padding:
                                        EdgeInsets.only(left: 25, right: 25),
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await Navigator.pushNamed(
                                                  context, AirportScreen.id);
                                              Provider.of<AvatarProvider>(
                                                      context,
                                                      listen: false)
                                                  .fetchBioData();
                                            },
                                            child: Container(
                                              child: Icon(
                                                  FontAwesomeIcons.plane,
                                                  size: 18,
                                                  color: Color(0xff767777)),
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffEAEEE6),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                      context, ShopScreen.id)
                                                  .then((value) {
                                                Provider.of<AvatarProvider>(
                                                        context,
                                                        listen: false)
                                                    .fetchBioData();
                                              });
                                            },
                                            child: Container(
                                              child: Icon(
                                                  FontAwesomeIcons.shoppingBag,
                                                  size: 18,
                                                  color: Color(0xff65b0f2)),
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffcfe6f9),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await Navigator.pushNamed(
                                                  context, TaskScreen.id);
                                              Provider.of<AvatarProvider>(
                                                      context,
                                                      listen: false)
                                                  .fetchBioData();
                                            },
                                            child: Container(
                                              child: Icon(
                                                  FontAwesomeIcons.solidFlag,
                                                  size: 18,
                                                  color: Color(0xffc07ac9)),
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffFCEBFE),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                            ),
                                          ),
                                          StreamBuilder(
                                              key: Key("notifications"),
                                              stream: notificationStream,
                                              builder: (context,
                                                  AsyncSnapshot snapshots) {
                                                if (!snapshots.hasData) {
                                                  return Container(
                                                    child: Icon(
                                                        FontAwesomeIcons
                                                            .mailBulk,
                                                        size: 18,
                                                        color:
                                                            Color(0xff56b770)),
                                                    width: 38,
                                                    height: 38,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffC1FED0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                  );
                                                } else {
                                                  return InkWell(
                                                    onTap: openNotifications,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .mailBulk,
                                                              size: 18,
                                                              color: Color(
                                                                  0xff56b770)),
                                                          width: 38,
                                                          height: 38,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xffC1FED0),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                        ),
                                                        if (snapshots.data.docs
                                                                .length >
                                                            0)
                                                          Container(
                                                            child: Text(
                                                              snapshots
                                                                      .data
                                                                      .docs
                                                                      .length
                                                                      .toString() +
                                                                  (snapshots.data.docs
                                                                              .length >
                                                                          10
                                                                      ? '+'
                                                                      : ''),
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            width: 12.0,
                                                            height: 12.0,
                                                            decoration:
                                                                new BoxDecoration(
                                                              color: lightRed,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              })
                                        ])),
                                Container(
                                    margin: EdgeInsets.only(bottom: 25),
                                    padding: EdgeInsets.all(25),
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(),
                                          StreamBuilder(
                                              key: Key("presence"),
                                              stream: presenceStream,
                                              builder: (context,
                                                  AsyncSnapshot snapshots) {
                                                if (!snapshots.hasData ||
                                                    snapshots.data.data() ==
                                                        null) {
                                                  return InkWell(
                                                    onTap: () async {
                                                      await Navigator.pushNamed(
                                                          context,
                                                          SocialScreen.id);
                                                      Provider.of<AvatarProvider>(
                                                              context,
                                                              listen: false)
                                                          .fetchBioData();
                                                    },
                                                    child: Container(
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .users,
                                                          size: 18,
                                                          color: lightRed),
                                                      width: 45,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                          color: veryLightRed,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                    ),
                                                  );
                                                } else {
                                                  return Stack(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          await Navigator
                                                              .pushNamed(
                                                                  context,
                                                                  SocialScreen
                                                                      .id);
                                                          Provider.of<AvatarProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .fetchBioData();
                                                        },
                                                        child: Container(
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .users,
                                                              size: 18,
                                                              color: lightRed),
                                                          width: 45,
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  veryLightRed,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                        ),
                                                      ),
                                                      if (snapshots.data !=
                                                              null &&
                                                          snapshots.data[
                                                                  'newFrom'] !=
                                                              null &&
                                                          snapshots
                                                                  .data[
                                                                      'newFrom']
                                                                  .length >
                                                              0)
                                                        Container(
                                                          child: Text(
                                                            '!',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          width: 20.0,
                                                          height: 20.0,
                                                          decoration:
                                                              new BoxDecoration(
                                                            color: lightRed,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        )
                                                    ],
                                                  );
                                                }
                                              }),

                                          RaisedButton(
                                              onPressed: () async {
                                                await Navigator.pushNamed(
                                                    context, ExerciseScreen.id);
                                                Provider.of<AvatarProvider>(
                                                        context,
                                                        listen: false)
                                                    .fetchBioData();
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text("Twerk It",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts
                                                            .fredokaOne(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white)),
                                                  )),
                                              color: lightGreen,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color:
                                                          Colors.transparent)))
                                          //  #5BD57A
                                        ])),
                              ],
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 25,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07),
                                            width: 18,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            decoration: BoxDecoration(
                                                color: Color(0xffD2D2D2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 25,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07),
                                            width: 18,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.09,
                                            decoration: BoxDecoration(
                                                color: Color(0xffEBEBEB),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 25,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07),
                                            width: 18,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            decoration: BoxDecoration(
                                                color: Color(0xffD2D2D2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 25,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07),
                                            width: 18,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.09,
                                            decoration: BoxDecoration(
                                                color: Color(0xffEBEBEB),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                        ],
                                      )
                                    ]))
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          }
          if (Provider.of<AvatarProvider>(context).onboarded == null)
            return Scaffold(
                backgroundColor: veryLightBlue,
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitRotatingCircle(
                        color: Colors.white,
                        size: 50.0,
                      )
                    ]));
          return Scaffold(
              backgroundColor: veryLightBlue,
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.all(25),
                        padding: EdgeInsets.all(25),
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(children: [
                          Text(
                              "What did your parents name you after that terrible mistake?",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 14, color: Colors.black)),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new TextField(
                              onChanged: (text) {
                                if (text.length == 0 || text.length == 1)
                                  setState(() {});
                              },
                              controller: nameController,
                              decoration: new InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: "Name",
                                  fillColor: Colors.white70),
                            ),
                          ),
                        ])),
                    Visibility(
                      visible: nameController.text.length > 0,
                      child: Center(
                          child: InkWell(
                        onTap: () =>
                            Provider.of<AvatarProvider>(context, listen: false)
                                .saveBioData(nameController.text),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          width: 60,
                          height: 60,
                          child: Icon(
                            FontAwesomeIcons.arrowRight,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                        ),
                      )),
                    )
                  ]));
        });
  }
}

class NotificationMessage extends StatefulWidget {
  const NotificationMessage({
    Key key,
    @required this.notification,
  }) : super(key: key);

  final FettleNotification notification;

  @override
  _NotificationMessageState createState() => _NotificationMessageState();
}

class _NotificationMessageState extends State<NotificationMessage> {
  @override
  void initState() {
    super.initState();
    if (!widget.notification.read) {
      Provider.of<NotificationsProvider>(context, listen: false)
          .readNotification(widget.notification.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    //bool acceptedFriendRequest = false; @sam @az
    return Dismissible(
        key: Key(widget.notification.id),
        onDismissed: (direction) {
          // remove notification from database
          Provider.of<NotificationsProvider>(context, listen: false)
              .deleteNotification(widget.notification.id);
        },
        background: Container(color: Colors.red),
        child: Container(
            margin: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.notification.title,
                            style: GoogleFonts.fredokaOne(
                                fontSize: 12, color: Colors.black)),
                        Text(widget.notification.subtitle,
                            style: GoogleFonts.fredokaOne(
                                fontSize: 10, color: Colors.black)),
                        if (widget.notification.type ==
                                NotificationType.FriendRequest &&
                            widget.notification.action == 0)
                          // acceptedFriendRequest
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(top: 8.0),
                          //         child: Align(
                          //           alignment: Alignment.center,
                          //           child: Text("Accepted friend request",
                          //               textAlign: TextAlign.center,
                          //               style: GoogleFonts.fredokaOne(
                          //                   fontSize: 5, color: lightGreen)),
                          //         ))
                          //     :
                          Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RaisedButton(
                                        onPressed: () {
                                          // setState(() {
                                          //   acceptedFriendRequest = true;
                                          //             }); @sam @az
                                          widget.notification.action = 1;
                                          Provider.of<NotificationsProvider>(
                                                  context,
                                                  listen: false)
                                              .interactWithNotification(
                                                  widget.notification.id, 1);
                                          Provider.of<FriendsProvider>(context,
                                                  listen: false)
                                              .acceptFriendRequest(
                                                  widget.notification
                                                      .body['peerId'],
                                                  Provider.of<AvatarProvider>(
                                                          context,
                                                          listen: false)
                                                      .name);
                                          Provider.of<AvatarProvider>(context,
                                                  listen: false)
                                              .friendIds
                                              .add(widget
                                                  .notification.body['peerId']);
                                          Provider.of<AvatarProvider>(context,
                                                      listen: false)
                                                  .friendIds =
                                              Provider.of<AvatarProvider>(
                                                      context,
                                                      listen: false)
                                                  .friendIds
                                                  .toSet()
                                                  .toList();
                                          Provider.of<FriendsProvider>(context,
                                                  listen: false)
                                              .fetchFriends(
                                                  Provider.of<AvatarProvider>(
                                                          context,
                                                          listen: false)
                                                      .friendIds);
                                          setState(() {});
                                        },
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Accept",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.fredokaOne(
                                                      fontSize: 15,
                                                      color:
                                                          Color(0xffFCEBFE))),
                                            )),
                                        color: Color(0xffc07ac9),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.transparent))),
                                    RaisedButton(
                                        onPressed: () {
                                          widget.notification.action = 1;
                                          Provider.of<NotificationsProvider>(
                                                  context,
                                                  listen: false)
                                              .interactWithNotification(
                                                  widget.notification.id, 1);
                                          Provider.of<FriendsProvider>(context,
                                                  listen: false)
                                              .rejectFriendRequest(
                                                  widget.notification
                                                      .body['peerId'],
                                                  widget.notification.id);
                                        },
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Delete",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.fredokaOne(
                                                      fontSize: 15,
                                                      color:
                                                          Color(0xffFCEBFE))),
                                            )),
                                        color: Color(0xffc07ac9),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.transparent)))
                                  ]))
                      ],
                    ),
                  ),
                ),
                if (!widget.notification.read)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      child: Text(
                        '',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      width: 12.0,
                      height: 12.0,
                      decoration: new BoxDecoration(
                        color: lightRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            height: 125,
            width: MediaQuery.of(context).size.width));
  }
}

class StepsProgressBar extends StatelessWidget {
  const StepsProgressBar({
    Key key,
  }) : super(key: key);

  double computeCompletionPercentage(context) {
    int stepsToday =
        Provider.of<AvatarProvider>(context, listen: false).stepsToday;
    int tier = (stepsToday / 1000).floor() + 1;
    return stepsToday / (tier * 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.all(25),
        width: MediaQuery.of(context).size.width * 0.56,
        height: MediaQuery.of(context).size.height * 0.03,
        decoration: BoxDecoration(
            color: Color(0xffEAEEE6),
            border: Border.all(
              color: Color(0xffEAEEE6),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      Container(
        margin: EdgeInsets.only(right: 25),
        padding: EdgeInsets.all(25),
        width: MediaQuery.of(context).size.width *
            0.5 *
            computeCompletionPercentage(context),
        height: MediaQuery.of(context).size.height * 0.03,
        decoration: BoxDecoration(
            color: lightGreen,
            border: Border.all(
              color: lightGreen,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.005, left: 4),
        child: Text(
            ' ' +
                Provider.of<AvatarProvider>(context, listen: false)
                    .stepsToday
                    .toString() +
                '/' +
                (((Provider.of<AvatarProvider>(context, listen: false)
                                        .stepsToday /
                                    1000)
                                .floor() +
                            1) *
                        1000)
                    .toString(),
            style: GoogleFonts.fredokaOne(fontSize: 12, color: Colors.white)),
      )
    ]);
  }
}
