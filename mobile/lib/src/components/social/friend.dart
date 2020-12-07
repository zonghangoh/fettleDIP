import 'package:flutter/material.dart';
import 'package:halpla/src/providers/auth.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halpla/src/models/activeDay.dart';
import 'package:halpla/src/models/cat.dart';
import '../../constants/ui.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:halpla/src/providers/exercise.dart';
import 'package:halpla/src/providers/friends.dart';
import '../../screens/conversation.dart';
import 'package:halpla/src/helpers/passport.dart';

class FriendStage extends StatefulWidget {
  final bool isMe;
  final Cat cat;
  final bool hasInvitedYouToEvent;
  const FriendStage({
    Key key,
    this.isMe = false,
    this.hasInvitedYouToEvent = false,
    this.cat,
  }) : super(key: key);

  @override
  _FriendStageState createState() => _FriendStageState();
}

class _FriendStageState extends State<FriendStage> {
  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: lightRed,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.0,
          ),
          Text("Long press to remove friend.",
              style: GoogleFonts.fredokaOne(color: Colors.white, fontSize: 12)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  String date(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }

    Duration difference = tm.difference(today);
    if (difference.compareTo(oneDay) < 1 && tm.day == today.day) {
      return "today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "tomorrow";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Monday";
        case 2:
          return "Tuesday";
        case 3:
          return "Wednesday";
        case 4:
          return "Thursday";
        case 5:
          return "Friday";
        case 6:
          return "Saturday";
        case 7:
          return "Sunday";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
  }

  void petDialog(context, Cat cat) {
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
                    Text(
                      "Pet " + cat.name + "?",
                      style: GoogleFonts.fredokaOne(fontSize: 30),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 45.0),
                      child: CatAvatar(
                        cat: cat,
                        height: 100,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40,
                      width: 150,
                      child: RaisedButton(
                          onPressed: () {
                            Provider.of<FriendsProvider>(context, listen: false)
                                .sendPet(
                                    cat.id,
                                    Provider.of<AvatarProvider>(context,
                                            listen: false)
                                        .name,
                                    cat);
                            Navigator.of(context).pop();
                            //setState(() => sentPet = true);
                          },
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('okie')],
                          )),
                    ),
                  ],
                ),
              ),
            ]),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 280 +
            (widget.hasInvitedYouToEvent &&
                    !Provider.of<ExerciseProvider>(context, listen: false)
                        .exerciseDaysJioedByFriends
                        .firstWhere(
                            (element) => element.packLeader == widget.cat.id)
                        .friendIds
                        .contains(
                            Provider.of<AuthProvider>(context, listen: false)
                                .userId)
                ? 60.0
                : 0.0),
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 280 +
                    ((widget.hasInvitedYouToEvent &&
                            !Provider.of<ExerciseProvider>(context,
                                    listen: false)
                                .exerciseDaysJioedByFriends
                                .firstWhere((element) =>
                                    element.packLeader == widget.cat.id)
                                .friendIds
                                .contains(Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .userId))
                        ? 60.0
                        : 0.0),
                width: MediaQuery.of(context).size.width),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                  Passport.getCountryFlag(widget.cat.country)),
                              Text('  ' + widget.cat.name,
                                  style: GoogleFonts.fredokaOne(
                                      fontSize: 20, color: Colors.black)),
                            ],
                          ),
                        ),
                        if (!widget.isMe)
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: InkWell(
                                    onTap: () {
                                      _showToast();
                                    },
                                    onLongPress: () {
                                      FirebaseFirestore.instance
                                          .collection('avatars')
                                          .doc(widget.cat.id)
                                          .update({
                                        'friendIds': FieldValue.arrayRemove([
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .userId
                                        ])
                                      });
                                      FirebaseFirestore.instance
                                          .collection('avatars')
                                          .doc(Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .userId)
                                          .update({
                                        'friendIds': FieldValue.arrayRemove(
                                            [widget.cat.id])
                                      });
                                      Provider.of<FriendsProvider>(context,
                                              listen: false)
                                          .friendAvatars
                                          .removeWhere((oldCat) =>
                                              oldCat.id == widget.cat.id);
                                      Provider.of<AvatarProvider>(context,
                                              listen: false)
                                          .friendIds
                                          .remove(widget.cat.id);
                                      Provider.of<AvatarProvider>(context,
                                              listen: false)
                                          .forceNotifyListeners();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      child: Icon(Icons.close,
                                          size: 18, color: Colors.red),
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                          color: veryLightRed,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    String groupChatId;
                                    if (Provider.of<FriendsProvider>(context,
                                                listen: false)
                                            .auth
                                            .userId
                                            .compareTo(widget.cat.id) ==
                                        -1) {
                                      groupChatId =
                                          Provider.of<FriendsProvider>(context,
                                                      listen: false)
                                                  .auth
                                                  .userId +
                                              '-' +
                                              widget.cat.id;
                                    } else {
                                      groupChatId = widget.cat.id +
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
                                                peerCat: widget.cat,
                                                groupChatId: groupChatId),
                                        transitionsBuilder:
                                            (context, anim1, anim2, child) =>
                                                FadeTransition(
                                                    opacity: anim1,
                                                    child: child),
                                        transitionDuration:
                                            Duration(milliseconds: 0),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CatAvatar(
                          cat: widget.cat,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: StepsChart(widget.cat)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(right: 25, bottom: 25),
                    child: Text(
                      "Last updated: " +
                          (widget.cat.lastUpdatedSteps != null
                              ? DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY)
                                  .format(widget.cat.lastUpdatedSteps)
                              : 'null'),
                      style: GoogleFonts.fredokaOne(fontSize: 10),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  if (widget.hasInvitedYouToEvent &&
                      !Provider.of<ExerciseProvider>(context, listen: false)
                          .exerciseDaysJioedByFriends
                          .firstWhere(
                              (element) => element.packLeader == widget.cat.id)
                          .friendIds
                          .contains(
                              Provider.of<AuthProvider>(context, listen: false)
                                  .userId))
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 4.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Join my TABATA session " +
                                    (Provider.of<ExerciseProvider>(context)
                                            .exerciseDaysJioedByFriends
                                            .firstWhere((element) =>
                                                element.packLeader ==
                                                widget.cat.id)
                                            .hasBegun
                                        ? "now"
                                        : (date(Provider.of<ExerciseProvider>(
                                                    context)
                                                .exerciseDaysJioedByFriends
                                                .firstWhere((element) =>
                                                    element.packLeader ==
                                                    widget.cat.id)
                                                .scheduledAt) +
                                            ' ' +
                                            DateFormat.Hms().format(
                                                Provider.of<ExerciseProvider>(
                                                        context)
                                                    .exerciseDaysJioedByFriends
                                                    .firstWhere((element) =>
                                                        element.packLeader ==
                                                        widget.cat.id)
                                                    .scheduledAt))),
                                style: GoogleFonts.fredokaOne(fontSize: 12)),
                            if (!Provider.of<ExerciseProvider>(context,
                                    listen: false)
                                .exerciseDaysJioedByFriends
                                .firstWhere((element) =>
                                    element.packLeader == widget.cat.id)
                                .friendIds
                                .contains(Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .userId))
                              RaisedButton(
                                  onPressed: () {
                                    DocumentReference documentReference =
                                        FirebaseFirestore.instance
                                            .collection('workoutRooms')
                                            .doc(Provider.of<ExerciseProvider>(
                                                    context,
                                                    listen: false)
                                                .exerciseDaysJioedByFriends
                                                .firstWhere((element) =>
                                                    element.packLeader ==
                                                    widget.cat.id)
                                                .channelName);
                                    FirebaseFirestore.instance
                                        .runTransaction((transaction) async {
                                      return transaction
                                          .get(documentReference)
                                          .then((sfDoc) {
                                        if (!sfDoc.exists) {
                                          throw "Document does not exist!";
                                        }
                                        Map roomData = sfDoc.data();
                                        int numberOfParticipants =
                                            roomData['participants'].length;
                                        if (numberOfParticipants < 4 &&
                                            !roomData['participants'].contains(
                                                Provider.of<AuthProvider>(
                                                        context)
                                                    .userId)) {
                                          ExerciseProvider ex =
                                              Provider.of<ExerciseProvider>(
                                                  context,
                                                  listen: false);
                                          ex.rvsp(widget.cat.id);
                                          transaction
                                              .update(documentReference, {
                                            'participants': [
                                              ...roomData['participants'],
                                              Provider.of<AuthProvider>(context,
                                                      listen: false)
                                                  .userId
                                            ]
                                          });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    content: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.35,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Stack(
                                                      overflow:
                                                          Overflow.visible,
                                                      children: [
                                                        Positioned(
                                                          right: -40.0,
                                                          top: -40.0,
                                                          child: InkResponse(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: CircleAvatar(
                                                              child: Icon(
                                                                  Icons.close),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Workout Room Is Full.",
                                                                style: GoogleFonts
                                                                    .fredokaOne(
                                                                        fontSize:
                                                                            30),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]),
                                                ));
                                              });
                                        }
                                      });
                                    }).then((value) => null);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text("RVSP",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.fredokaOne(
                                            fontSize: 10, color: Colors.white)),
                                  ),
                                  color: lightBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.transparent)))
                          ]),
                    ),
                ],
              ),
              decoration: BoxDecoration(
                  color: offWhite,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 260 +
                  (widget.hasInvitedYouToEvent &&
                          !Provider.of<ExerciseProvider>(context, listen: false)
                              .exerciseDaysJioedByFriends
                              .firstWhere((element) =>
                                  element.packLeader == widget.cat.id)
                              .friendIds
                              .contains(Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .userId)
                      ? 60.0
                      : 0.0),
            ),
          ],
        ));
  }
}

class CatAvatar extends StatefulWidget {
  final Cat cat;
  final double height;
  const CatAvatar({
    Key key,
    this.height,
    this.cat,
  }) : super(key: key);

  @override
  _CatAvatarState createState() => _CatAvatarState();
}

class _CatAvatarState extends State<CatAvatar> with TickerProviderStateMixin {
  AnimationController catController;

  bool isWaving = false;

  @override
  void initState() {
    super.initState();
    catController = AnimationController(vsync: this);
  }

  void dispose() {
    catController.dispose();
    super.dispose();
  }

  String getCurrentClothes(int itemId, int isFat) {
    switch (isFat) {
      case 0:
        switch (itemId) {
          case 0:
            return 'assets/NormalCatBouncing.json';
          case 1:
            return 'assets/JapanCatBlackKimonoBouncing.json';
          case 2:
            return 'assets/JapanCatPinkKimonoBouncing.json';
          case 3:
            return 'assets/HawaiiCatBouncing.json';
          case 4:
            return 'assets/NTUCatRedBouncing.json';
          case 5:
            return 'assets/NTUCatBlueBouncing.json';
          case 6:
            return 'assets/IEMCatWhiteBouncing.json';
          case 7:
            return 'assets/IEMCatBlackBouncing.json';
          default:
            return 'assets/NormalCatBouncing.json';
        }
        break;
      case 1:
        return 'assets/FatCatBouncing.json';
      default:
        return 'assets/NormalCatBouncing.json';
    }
  }

  String getWavingCat(int itemId, int isFat) {
    switch (isFat) {
      case 0:
        switch (itemId) {
          case 0:
            return 'assets/NormalCatWaving.json';
          case 1:
            return 'assets/JapanCatBlackKimonoWaving.json';
          case 2:
            return 'assets/JapanCatPinkKimonoWaving.json';
          case 3:
            return 'assets/HawaiiCatWaving.json';
          case 4:
            return 'assets/NTUCatRedWaving.json';
          case 5:
            return 'assets/NTUCatBlueWaving.json';
          case 6:
            return 'assets/IEMCatWhiteWaving.json';
          case 7:
            return 'assets/IEMCatBlackWaving.json';
          default:
            return 'assets/NormalCatWaving.json';
        }
        break;
      case 1:
        return 'assets/FatCatWaving.json';
      default:
        return 'assets/NormalCatWaving.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height ?? 200.0,
        child: GestureDetector(
            child: Lottie.asset(
                isWaving
                    ? getWavingCat(widget.cat.equippedItemId, widget.cat.isFat)
                    : getCurrentClothes(
                        widget.cat.equippedItemId, widget.cat.isFat),
                controller: catController, onLoaded: (composition) {
              catController
                ..addStatusListener((AnimationStatus status) {
                  if (status == AnimationStatus.completed) {
                    if (!isWaving) {
                      catController.repeat();
                    } else {
                      setState(() => isWaving = false);
                    }
                  }
                });
              catController
                ..duration = composition.duration
                ..forward();
            }),
            onTap: () {
              if (!isWaving) {
                setState(() => isWaving = true);
                catController.forward(from: 0);
              }
            }));
  }
}

class StepsChart extends StatelessWidget {
  final Cat cat;
  final bool animate;

  StepsChart(this.cat, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      generateData(),
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeriesSteps, DateTime>> generateData() {
    final data = cat.past7DaysOfSteps
        .map((ActiveDay d) => TimeSeriesSteps(d.date, d.stepsTracked))
        .toList();

    return [
      new charts.Series<TimeSeriesSteps, DateTime>(
        id: 'Steps',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSteps steps, _) => steps.time,
        measureFn: (TimeSeriesSteps steps, _) => steps.steps,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSteps {
  final DateTime time;
  final int steps;

  TimeSeriesSteps(this.time, this.steps);
}
