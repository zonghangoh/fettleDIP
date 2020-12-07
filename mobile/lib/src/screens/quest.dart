import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/ui.dart';
import 'package:halpla/src/providers/friends.dart';
import '../models/cat.dart';
import '../models/quest.dart';
import '../models/exerciseDay.dart';
import '../screens/shop.dart';

import '../providers/exercise.dart';
import '../providers/avatar.dart';
import 'package:provider/provider.dart';
import '../components/social/friend.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class TaskScreen extends StatefulWidget {
  static String id = 'task';
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Future fetchFriends;
  Future fetchExerciseData;
  Quest currentQuest;
  bool loadedLottie = false;
  @override
  void initState() {
    super.initState();
    // _loadFriends();
    currentQuest = Quest.testQuest();
    fetchFriends = Provider.of<FriendsProvider>(context, listen: false)
        .fetchFriends(
            Provider.of<AvatarProvider>(context, listen: false).friendIds);
    fetchExerciseData = Provider.of<ExerciseProvider>(context, listen: false)
        .fetchExerciseDays(
            Provider.of<AvatarProvider>(context, listen: false).friendIds);
  }

  Container taskList(
      String title, String description, IconData iconImg, Color iconColor) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 40),
      child: Row(
        children: <Widget>[
          Icon(
            iconImg,
            color: iconColor,
            size: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AvatarProvider>(context);
    return FutureBuilder<Object>(
        future: Future.wait([fetchFriends, fetchExerciseData]),
        builder: (context, snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState != ConnectionState.done) {
            return new Scaffold(
              backgroundColor: lightPurple,
              body: SizedBox(),
            );
          }
          return Scaffold(
            backgroundColor: lightPurple,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(height: 24),
                  // Icon(FontAwesomeIcons.solidFlag,
                  //     size: 24, color: Color(0xffc07ac9)),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 4),
                          child: Image.asset(
                            'assets/coin.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Text(
                          "Reward: " +
                              currentQuest.coinReward.toString() +
                              ' * friends (max 10)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredokaOne(
                              color: purple, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Take at least " +
                          currentQuest.minimumStepsEach.toString() +
                          " Steps each.",
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.fredokaOne(color: purple, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0, right: 25, left: 25, bottom: 20),
                    child: Text(
                      DateFormat.yMMMMEEEEd().format(currentQuest.startDate) +
                          ' - ' +
                          DateFormat.yMMMMEEEEd().format(currentQuest.endDate),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredokaOne(
                          color: purple.withOpacity(0.5), fontSize: 12),
                    ),
                  ),
                  currentQuest.isEligibleForQuest(
                          Provider.of<FriendsProvider>(context).friendAvatars)
                      ? renderQuest()
                      : Text(
                          'You need ' +
                              currentQuest.minimumFriends.toString() +
                              ' friends to participate in this quest!',
                          style: GoogleFonts.fredokaOne(
                              color: Colors.black, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                  Container(
                    decoration: BoxDecoration(
                      color: purple,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, anim1, anim2) =>
                                        ShopScreen(
                                      showVouchers: true,
                                    ),
                                    transitionsBuilder:
                                        (context, anim1, anim2, child) =>
                                            FadeTransition(
                                                opacity: anim1, child: child),
                                    transitionDuration:
                                        Duration(milliseconds: 0),
                                  ),
                                );
                              },
                              child: Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Show Rewards",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.fredokaOne(
                                        fontSize: 14, color: Colors.black)),
                              )),
                              color: offWhite,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.transparent))),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: 40,
                            height: 40,
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
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Expanded renderQuest() {
    if (currentQuest.hasCompletedQuest([
      Provider.of<AvatarProvider>(context).myCat,
      ...Provider.of<FriendsProvider>(context).friendAvatars
    ])) {
      return Expanded(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Lottie.asset(
                    Provider.of<AvatarProvider>(context)
                            .lastCollectedRewardAt
                            .isBefore(currentQuest.startDate)
                        ? 'assets/successMouse.json'
                        : 'assets/coinDrop.json',
                    repeat: false,
                    onLoaded: (composition) {
                      // if (!loadedLottie)
                      //   Future.delayed(const Duration(milliseconds: 1000), () {
                      //     setState(() => loadedLottie = true);
                      //   });
                    },
                  ),
                ),
                Text("Yay! Mission Accomplished!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredokaOne(
                        fontSize: 18, color: Colors.black)),
                Provider.of<AvatarProvider>(context)
                        .lastCollectedRewardAt
                        .isBefore(currentQuest.startDate)
                    ? Padding(
                        padding: EdgeInsets.all(20),
                        child: RaisedButton(
                            onPressed: () {
                              Provider.of<AvatarProvider>(context,
                                      listen: false)
                                  .completeQuest(currentQuest.coinReward *
                                      (Provider.of<FriendsProvider>(context,
                                                      listen: false)
                                                  .friendAvatars
                                                  .length >
                                              10
                                          ? 10
                                          : Provider.of<FriendsProvider>(
                                                  context,
                                                  listen: false)
                                              .friendAvatars
                                              .length));
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Collect Reward",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.fredokaOne(
                                          fontSize: 15, color: Colors.white)),
                                )),
                            color: lightGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.transparent))))
                    : Padding(
                        padding: EdgeInsets.all(20),
                        child: RaisedButton(
                            onPressed: () {},
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Collected Reward",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.fredokaOne(
                                          fontSize: 15, color: Colors.white)),
                                )),
                            color: veryLightGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.transparent)))),
              ],
            )),
      );
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            insetPadding: EdgeInsets.symmetric(horizontal: 0),
                            backgroundColor: Colors.transparent,
                            content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FriendStage(
                                    isMe: true,
                                    hasInvitedYouToEvent: false,
                                    cat: Provider.of<AvatarProvider>(context,
                                            listen: false)
                                        .myCat)));
                      });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: CatAvatar(
                          height: 100,
                          cat: Provider.of<AvatarProvider>(context).myCat),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(Provider.of<AvatarProvider>(context).name,
                              style: GoogleFonts.fredokaOne(
                                  color: Colors.black, fontSize: 20)),
                          IndividualProgressBar(
                              cat: Provider.of<AvatarProvider>(context).myCat,
                              quest: currentQuest)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            ...Provider.of<FriendsProvider>(context)
                .friendAvatars
                .map(
                  (cat) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                  backgroundColor: Colors.transparent,
                                  content: Padding(
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
                                                          cat.id,
                                                      orElse: () => null) !=
                                              null,
                                          cat: cat)));
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(child: CatAvatar(height: 100, cat: cat)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(cat.name,
                                    style: GoogleFonts.fredokaOne(
                                        color: purple, fontSize: 20)),
                                IndividualProgressBar(
                                    cat: cat, quest: currentQuest)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}

class IndividualProgressBar extends StatelessWidget {
  final Cat cat;
  final Quest quest;
  const IndividualProgressBar({
    Key key,
    this.quest,
    this.cat,
  }) : super(key: key);

  double computeCompletionPercentage(context) {
    int totalSteps = cat.stepsCoveredSinceDate(quest.startDate);
    if (totalSteps > quest.minimumStepsEach) return 1.0;
    return totalSteps / quest.minimumStepsEach;
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
        padding: EdgeInsets.all(25),
        width: MediaQuery.of(context).size.width *
            0.56 *
            computeCompletionPercentage(context),
        height: MediaQuery.of(context).size.height * 0.03,
        decoration: BoxDecoration(
            color: lightGreen,
            border: Border.all(
              color: lightGreen,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    ]);
  }
}
