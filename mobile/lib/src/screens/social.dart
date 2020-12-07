import 'package:flutter/material.dart';
import 'package:halpla/src/models/cat.dart';
import 'package:halpla/src/providers/auth.dart';
import 'package:halpla/src/providers/friends.dart';
import 'package:halpla/src/screens/addfriend.dart';
import 'package:halpla/src/models/exerciseDay.dart';
import 'package:provider/provider.dart';
import '../providers/exercise.dart';
import '../providers/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import '../components/social/friend.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'conversation.dart';
import 'package:halpla/src/helpers/passport.dart';

class SocialScreen extends StatefulWidget {
  static String id = 'social';
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  bool loading = false;
  TextEditingController textEditingController = TextEditingController();
  Future fetchYourself;
  Future fetchFriends;
  Future fetchExerciseData;
  Future fetchedChatlog;
  Map<String, Map> chatlogMap = {};
  @override
  void initState() {
    super.initState();
    // _loadFriends();
    fetchYourself =
        Provider.of<FriendsProvider>(context, listen: false).fetchYourself();
    fetchFriends = Provider.of<FriendsProvider>(context, listen: false)
        .fetchFriends(
            Provider.of<AvatarProvider>(context, listen: false).friendIds);
    fetchExerciseData = Provider.of<ExerciseProvider>(context, listen: false)
        .fetchExerciseDays(
            Provider.of<AvatarProvider>(context, listen: false).friendIds);
    fetchedChatlog = fetchChatlog();
    FirebaseFirestore.instance
        .collection('presence')
        .doc(Provider.of<AvatarProvider>(context, listen: false).auth.userId)
        .set({
      'online': false,
      'lastOnline': DateTime.now().millisecondsSinceEpoch,
      'chatRoom': '',
      'newFrom': []
    });
  }

  void selfDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Stack(overflow: Overflow.visible, children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 2),
                    Text(
                        Provider.of<AvatarProvider>(context).myCat.name +
                            " 's stats ",
                        style: GoogleFonts.fredokaOne(
                            fontSize: 25, color: Colors.black)),
                    Spacer(flex: 2),
                    //Image.asset(Passport.getCountryFlag(cat.country)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CatAvatar(
                        cat: Provider.of<AvatarProvider>(context).myCat,
                        height: 200,
                      ),
                    ),
                    Spacer(flex: 1),
                    Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: StepsChart(
                            Provider.of<AvatarProvider>(context).myCat)),
                    Spacer(flex: 2),
                  ],
                ),
              ),
            ]),
          ));
        });
  }

  Future<bool> fetchChatlog() async {
    QuerySnapshot chatlog = await FirebaseFirestore.instance
        .collection("chatlog")
        .where('cats',
            arrayContains:
                Provider.of<AuthProvider>(context, listen: false).userId)
        .get();
    if (chatlog == null) return true;
    List chatlogs = chatlog.docs;
    chatlogs.sort(
        (a, b) => a.data()['lastSentAt'] < b.data()['lastSentAt'] ? 1 : -1);
    chatlogs.toList().forEach((doc) {
      chatlogMap[doc.data()['cats'].firstWhere((id) =>
              id != Provider.of<AuthProvider>(context, listen: false).userId)] =
          doc.data();
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    Provider.of<AvatarProvider>(context);
    return FutureBuilder<Object>(
        future: Future.wait(
            [fetchYourself, fetchFriends, fetchExerciseData, fetchedChatlog]),
        builder: (context, snapshot) {
          if (!snapshot.hasError &&
              snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                backgroundColor: veryLightRed,
                body: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(top: 25),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Expanded(
                              child: ListView(children: [
                            ...chatlogMap.keys.map((key) {
                              Cat cat = Provider.of<FriendsProvider>(context)
                                  .friendAvatars
                                  .firstWhere((cat) => cat.id == key,
                                      orElse: () => null);
                              if (cat != null) {
                                return renderChatPreview(cat);
                              } else {
                                return SizedBox();
                              }
                            }).toList(),
                            ...Provider.of<FriendsProvider>(context)
                                .friendAvatars
                                .where(
                                    (cat) => !chatlogMap.keys.contains(cat.id))
                                .map((cat) {
                              return renderChatPreview(cat);
                            }).toList()
                          ])),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  selfDialog();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  width: 60,
                                  height: 60,
                                  child: Icon(
                                    FontAwesomeIcons.user,
                                    color: Colors.blueGrey,
                                    size: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFe0f2f1)),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, SearchScreen.id),
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  width: 60,
                                  height: 60,
                                  child: Icon(
                                    FontAwesomeIcons.userPlus,
                                    color: Colors.blueGrey,
                                    size: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFe0f2f1)),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  width: 60,
                                  height: 60,
                                  child: Icon(
                                    FontAwesomeIcons.times,
                                    color: Colors.blueGrey,
                                    size: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFe0f2f1)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          }

          // return Scaffold(
          //     // backgroundColor: Provider.of<AvatarProvider>(context).onboarded
          //     //     ? mainBackgroundColor
          //     //     : darkBackgroundColor,
          //     body: Stack(
          //   children: <Widget>[],
          // ));
          return new Scaffold(
            body: content,
          );
        });
  }

  Widget renderChatPreview(Cat cat) {
    bool hasInvited = Provider.of<ExerciseProvider>(context, listen: false)
            .exerciseDaysJioedByFriends
            .firstWhere((ExerciseDay day) => day.packLeader == cat.id,
                orElse: () => null) !=
        null;
    bool hasRVSPed = hasInvited &&
        Provider.of<ExerciseProvider>(context, listen: false)
            .exerciseDaysJioedByFriends
            .firstWhere((element) => element.packLeader == cat.id)
            .friendIds
            .contains(Provider.of<AuthProvider>(context, listen: false).userId);
    String groupChatId;
    if (Provider.of<FriendsProvider>(context, listen: false)
            .auth
            .userId
            .compareTo(cat.id) ==
        -1) {
      groupChatId =
          Provider.of<FriendsProvider>(context, listen: false).auth.userId +
              '-' +
              cat.id;
    } else {
      groupChatId = cat.id +
          '-' +
          Provider.of<FriendsProvider>(context, listen: false).auth.userId;
    }

    return InkWell(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) =>
              ConversationScreen(peerCat: cat, groupChatId: groupChatId),
          transitionsBuilder: (context, anim1, anim2, child) =>
              FadeTransition(opacity: anim1, child: child),
          transitionDuration: Duration(milliseconds: 0),
        ),
      ),
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: offWhite,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            CatAvatar(height: 100, cat: cat),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(Passport.getCountryFlag(cat.country)),
                          Text('  ' + cat.name,
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 20, color: Colors.black)),
                        ],
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("chatlog")
                              .doc(groupChatId)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snap) {
                            QuerySnapshot snapData =
                                snap.hasData ? (snap.data ?? null) : null;
                            if (snapData == null || snapData.docs.length == 0) {
                              return SizedBox();
                            }
                            snapData.toString();
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                snapData.docs[0]['nameFrom'] +
                                    ": " +
                                    snapData.docs[0]['content'],
                                style: GoogleFonts.openSans(
                                    fontSize: 10,
                                    color: !snapData.docs[0]['read'] &&
                                            snapData.docs[0]['from'] !=
                                                Provider.of<AuthProvider>(
                                                        context)
                                                    .userId
                                        ? Colors.red
                                        : Colors.black,
                                    fontWeight: snapData.docs[0]['read']
                                        ? FontWeight.normal
                                        : FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          })
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    insetPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    backgroundColor: Colors.transparent,
                                    content: Builder(builder: (context) {
                                      return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FriendStage(
                                              isMe: false,
                                              hasInvitedYouToEvent: hasInvited,
                                              cat: cat));
                                    }));
                              });
                        },
                        child: Container(
                          child: Icon(FontAwesomeIcons.info,
                              size: 18,
                              color: hasInvited && !hasRVSPed
                                  ? Colors.white
                                  : Color(0xff767777)),
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              color: hasInvited && !hasRVSPed
                                  ? lightBlue
                                  : Color(0xffEAEEE6),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                      SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            String groupChatId;
                            if (Provider.of<FriendsProvider>(context,
                                        listen: false)
                                    .auth
                                    .userId
                                    .compareTo(cat.id) ==
                                -1) {
                              groupChatId = Provider.of<FriendsProvider>(
                                          context,
                                          listen: false)
                                      .auth
                                      .userId +
                                  '-' +
                                  cat.id;
                            } else {
                              groupChatId = cat.id +
                                  '-' +
                                  Provider.of<FriendsProvider>(context,
                                          listen: false)
                                      .auth
                                      .userId;
                            }
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, anim1, anim2) =>
                                    ConversationScreen(
                                        peerCat: cat, groupChatId: groupChatId),
                                transitionsBuilder:
                                    (context, anim1, anim2, child) =>
                                        FadeTransition(
                                            opacity: anim1, child: child),
                                transitionDuration: Duration(milliseconds: 0),
                              ),
                            );
                          },
                          //onTap: () {},
                          child: Container(
                            child: Icon(Icons.chat_bubble,
                                size: 18, color: Color(0xffc07ac9)),
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: Color(0xffFCEBFE),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
