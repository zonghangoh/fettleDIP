import 'package:flutter/material.dart';
import 'package:halpla/src/providers/friends.dart';
import 'package:halpla/src/screens/addfriend.dart';
import 'package:halpla/src/models/exerciseDay.dart';
import 'package:provider/provider.dart';
import '../providers/exercise.dart';
import '../providers/avatar.dart';

import '../constants/ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/social/friend_old.dart';

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
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
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

  @override
  Widget build(BuildContext context) {
    Widget content;
    return FutureBuilder<Object>(
        future: Future.wait([fetchYourself, fetchFriends, fetchExerciseData]),
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
                              child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: new ListView.builder(
                                      itemCount:
                                          Provider.of<FriendsProvider>(context)
                                              .friendAvatars
                                              .length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FriendStage(
                                              hasInvitedYouToEvent: Provider.of<
                                                              ExerciseProvider>(
                                                          context,
                                                          listen: false)
                                                      .exerciseDaysJioedByFriends
                                                      .firstWhere(
                                                          (ExerciseDay day) =>
                                                              day.packLeader ==
                                                              Provider.of<FriendsProvider>(
                                                                      context)
                                                                  .friendAvatars[
                                                                      index]
                                                                  .id,
                                                          orElse: () => null) !=
                                                  null,
                                              cat: Provider.of<FriendsProvider>(
                                                      context)
                                                  .friendAvatars[index]),
                                        );
                                      }))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor

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
}
