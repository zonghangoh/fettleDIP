import 'package:flutter/material.dart';
import 'package:halpla/src/providers/avatar.dart';
import 'package:halpla/src/providers/exercise.dart';
import 'package:halpla/src/providers/friends.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../constants/ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../helpers/gym.dart';
import 'package:intl/intl.dart';
import 'call.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/exerciseDay.dart';
import '../models/cat.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/social/friend.dart';
import '../helpers/pusher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseScreen extends StatefulWidget {
  static String id = 'exercise';
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  bool loading = false;
  TextEditingController textEditingController = TextEditingController();
  bool openJio = false;
  DateTime tentativeStartsAt = DateTime.now();
  Future fetchExerciseData;
  Future fetchFriends;
  List<Cat> catsToSendInvitationTo = [];
  @override
  void initState() {
    super.initState();
    fetchFriends = Provider.of<FriendsProvider>(context, listen: false)
        .fetchFriends(
            Provider.of<AvatarProvider>(context, listen: false).friendIds);
    fetchExerciseData = Provider.of<ExerciseProvider>(context, listen: false)
        .fetchExerciseDays(
            Provider.of<AvatarProvider>(context, listen: false).friendIds);
  }

  Future fetchCatsInRoom(List<String> workoutBuddyIds) async {
    await Provider.of<FriendsProvider>(context, listen: false)
        .fetchWorkoutBuddies(workoutBuddyIds);
    return;
  }

  String date(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "january";
        break;
      case 2:
        month = "february";
        break;
      case 3:
        month = "march";
        break;
      case 4:
        month = "april";
        break;
      case 5:
        month = "may";
        break;
      case 6:
        month = "june";
        break;
      case 7:
        month = "july";
        break;
      case 8:
        month = "august";
        break;
      case 9:
        month = "september";
        break;
      case 10:
        month = "october";
        break;
      case 11:
        month = "november";
        break;
      case 12:
        month = "december";
        break;
    }

    Duration difference = tm.difference(today);
    if (difference.compareTo(oneDay) < 1 && tm.day == today.day) {
      return tm.hour.toString() +
          ":" +
          (tm.minute < 10 ? "0" : '') +
          tm.minute.toString();
    } else if (difference.compareTo(twoDay) < 1) {
      return "tomorrow";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "monday";
        case 2:
          return "tuesday";
        case 3:
          return "wednesday";
        case 4:
          return "thursday";
        case 5:
          return "friday";
        case 6:
          return "saturday";
        case 7:
          return "sunday";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
  }

  Widget renderListOfCats(Function setState) {
    return Expanded(
        child: ListView(
      children: [
        ...Provider.of<FriendsProvider>(context).friendAvatars.map((friend) {
          return InkWell(
            onTap: () {
              if (catsToSendInvitationTo.contains(friend)) {
                catsToSendInvitationTo.remove(friend);
              } else {
                catsToSendInvitationTo.add(friend);
              }
              setState(() {});
            },
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: catsToSendInvitationTo.contains(friend)
                      ? lightBlue
                      : offWhite,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                children: [
                  CatAvatar(height: 100, cat: friend),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(friend.name,
                            style: GoogleFonts.fredokaOne(
                                fontSize: 20, color: Colors.black)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ],
    ));
  }

  void openJioModal() {
    showModalBottomSheet(
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
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0))),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 0.0), // content padding
                            child: Column(
                              children: [
                                Text(
                                    "You are one step closer to being less flabby"
                                        .toUpperCase(),
                                    style: GoogleFonts.fredokaOne(
                                        fontSize: 8, color: Colors.black)),
                                SizedBox(height: 25),

                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Starts At",
                                        style: GoogleFonts.fredokaOne(
                                            fontSize: 15, color: Colors.black)),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            DateTime selectedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2025),
                                            );
                                            if (selectedDate != null) {
                                              TimeOfDay selectedTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if (selectedTime != null) {
                                                var newHour = selectedTime.hour;
                                                var newMinute =
                                                    selectedTime.minute;
                                                tentativeStartsAt =
                                                    new DateTime(
                                                        selectedDate.year,
                                                        selectedDate.month,
                                                        selectedDate.day,
                                                        newHour,
                                                        newMinute,
                                                        0,
                                                        0,
                                                        0);

                                                setState(() {});
                                              }
                                            }
                                          },
                                          child: Text(
                                              date(tentativeStartsAt)
                                                      .toUpperCase() +
                                                  ' ' +
                                                  DateFormat.Hms().format(
                                                      tentativeStartsAt),
                                              style: GoogleFonts.fredokaOne(
                                                  fontSize: 15,
                                                  color: Colors.blueGrey)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 50),
                                Text(
                                    'Select friends to send a direct invitation.',
                                    style: GoogleFonts.fredokaOne(
                                        fontSize: 12, color: Colors.black)),
                                renderListOfCats(setState),
                                SizedBox(height: 50),
                                RaisedButton(
                                    onPressed: () {
                                      String channelName =
                                          Provider.of<ExerciseProvider>(context,
                                                  listen: false)
                                              .createExerciseDay(
                                                  scheduledAt:
                                                      tentativeStartsAt,
                                                  friendIds: [],
                                                  openJio: openJio);
                                      Pusher.sendExerciseInvites(
                                          catsToSendInvitationTo,
                                          Provider.of<ExerciseProvider>(context,
                                                  listen: false)
                                              .auth
                                              .userId,
                                          Provider.of<AvatarProvider>(context,
                                                  listen: false)
                                              .name,
                                          channelName,
                                          tentativeStartsAt);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              "Fill My Existential Void",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.fredokaOne(
                                                  fontSize: 20,
                                                  color: Colors.white)),
                                        )),
                                    color: lightGreen,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Colors.transparent))),
                                SizedBox(height: 50),

                                // TextField(),
                              ],
                            )))));
          });
        });
  }

  Widget renderHostButton() {
    if (Provider.of<ExerciseProvider>(context, listen: false)
            .exerciseDaysOrganisedByMe
            .length ==
        0) {
      return Container(
        padding: EdgeInsets.all(25),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(FontAwesomeIcons.fire, color: lightRed),
            SizedBox(height: 4),
            Text("INITIATE A WORKOUT",
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(
                    fontSize: 20, color: Colors.black87)),
            SizedBox(height: 4),
            Text("YOU ARE A TRAILBLAZER.",
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(
                    fontSize: 14, color: Colors.black54)),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                  onPressed: () async {
                    openJioModal();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Open Jio",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredokaOne(
                                fontSize: 20, color: Colors.white)),
                      )),
                  color: lightGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.transparent))),
            )
          ],
        ),
      );
    } else {
      ExerciseDay exerciseDay =
          Provider.of<ExerciseProvider>(context, listen: false)
              .exerciseDaysOrganisedByMe[0];
      return Container(
        padding: EdgeInsets.all(25),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(FontAwesomeIcons.fire, color: lightRed),
            SizedBox(height: 4),
            Text("YOU ARE A HOST",
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(
                    fontSize: 20, color: Colors.black87)),
            SizedBox(height: 4),
            Text(
                (exerciseDay.friendIds.length - 1).toString() +
                    ((exerciseDay.friendIds.length - 1) == 1
                        ? ' friend is attending.'
                        : ' friends are attending.'),
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(
                    fontSize: 14, color: Colors.black54)),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                  onPressed: () async {
                    if (exerciseDay.hasBegun) {
                      if (await Permission.camera.request().isGranted) {
                        if (await Permission.microphone.request().isGranted) {
                          Gym.getWorkoutRoomToken(
                                  id: exerciseDay.friendIds.indexOf(
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .userId) +
                                      1,
                                  channelName: exerciseDay.channelName)
                              .then((token) async {
                            await fetchCatsInRoom(exerciseDay.friendIds);
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, anim1, anim2) =>
                                      VideoRoom(
                                    exerciseDay: exerciseDay,
                                    callerId: exerciseDay.friendIds.indexOf(
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .userId) +
                                        1,
                                    token: token,
                                    channelName: exerciseDay.channelName,
                                  ),
                                  transitionsBuilder:
                                      (context, anim1, anim2, child) =>
                                          FadeTransition(
                                              opacity: anim1, child: child),
                                  transitionDuration: Duration(milliseconds: 0),
                                ));
                          });
                        }
                      }
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            exerciseDay.hasBegun
                                ? 'Join Workout Room'
                                : "Scheduled for " +
                                    date(exerciseDay.scheduledAt),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredokaOne(
                                fontSize: 20, color: Colors.white)),
                      )),
                  color: exerciseDay.hasBegun ? lightGreen : Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.transparent))),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              backgroundColor: Colors.white,
                              content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView(
                                        children: Provider.of<FriendsProvider>(
                                                context)
                                            .friendAvatars
                                            .where((f) => exerciseDay.friendIds
                                                .contains(f.id))
                                            .map((e) => Row(
                                                  children: [
                                                    CatAvatar(
                                                        cat: e, height: 120),
                                                    Text(e.name,
                                                        style: GoogleFonts
                                                            .fredokaOne(
                                                                color: Colors
                                                                    .black))
                                                  ],
                                                ))
                                            .toList()),
                                  )));
                        });
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('View Attendees',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredokaOne(
                                fontSize: 20, color: Colors.white)),
                      )),
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.transparent))),
            )
          ],
        ),
      );
    }
  }

  Widget renderJoinButton(ExerciseDay exerciseDay) {
    if (exerciseDay.packLeader ==
        Provider.of<AuthProvider>(context, listen: false).userId) {
      return SizedBox();
    }
    return Container(
      padding: EdgeInsets.all(25),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          CatAvatar(
              height: 120,
              cat: Provider.of<FriendsProvider>(context)
                  .friendAvatars
                  .firstWhere(
                      (element) => element.id == exerciseDay.packLeader)),
          SizedBox(height: 10),
          Text(
              "Workout with " +
                  Provider.of<FriendsProvider>(context)
                      .friendAvatars
                      .firstWhere(
                          (element) => element.id == exerciseDay.packLeader)
                      .name,
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.fredokaOne(fontSize: 20, color: Colors.black87)),
          SizedBox(height: 4),
          Text(
              (exerciseDay.friendIds.length - 1).toString() +
                  (exerciseDay.friendIds.length - 1 == 1
                      ? " friend is attending!"
                      : " friends are attending!"),
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.fredokaOne(fontSize: 14, color: Colors.black54)),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: !exerciseDay.scheduledAt.isAfter(DateTime.now())
                ? RaisedButton(
                    onPressed: () async {
                      if (await Permission.camera.request().isGranted) {
                        if (await Permission.microphone.request().isGranted) {
                          Gym.getWorkoutRoomToken(
                                  id: exerciseDay.friendIds.indexOf(
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .userId) +
                                      1,
                                  channelName: exerciseDay.channelName)
                              .then((token) async {
                            await fetchCatsInRoom(exerciseDay.friendIds);

                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, anim1, anim2) =>
                                      VideoRoom(
                                    exerciseDay: exerciseDay,
                                    callerId: exerciseDay.friendIds.indexOf(
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .userId) +
                                        1,
                                    token: token,
                                    channelName: exerciseDay.channelName,
                                  ),
                                  transitionsBuilder:
                                      (context, anim1, anim2, child) =>
                                          FadeTransition(
                                              opacity: anim1, child: child),
                                  transitionDuration: Duration(milliseconds: 0),
                                ));
                          });
                        }
                      }
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Join Video Call",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 20, color: Colors.white)),
                        )),
                    color: lightBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.transparent)))
                : RaisedButton(
                    onPressed: () {},
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Scheduled for " + date(exerciseDay.scheduledAt),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 20, color: Colors.white)),
                        )),
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.transparent))),
          )
        ],
      ),
    );
  }

  Widget renderFriendInviteModal(
      {String channelName,
      String hostId,
      bool hasStarted: false,
      bool hasRVSPed: false,
      bool isPrivate: false}) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(25),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(hostId,
              textAlign: TextAlign.left,
              style:
                  GoogleFonts.fredokaOne(fontSize: 12, color: Colors.black87)),
          Text("HAS INVITED YOU TO AN UPCOMING WORKOUT!",
              textAlign: TextAlign.left,
              style:
                  GoogleFonts.fredokaOne(fontSize: 12, color: Colors.black87)),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                    onPressed: () async {
                      if (await Permission.camera.request().isGranted) {
                        if (await Permission.microphone.request().isGranted) {
                          // Gym.getWorkoutRoomToken(channelName: channelName)
                          //     .then((token) {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       PageRouteBuilder(
                          //         pageBuilder: (context, anim1, anim2) =>
                          //             VideoRoom(
                          //           token: token,
                          //           channelName: channelName,
                          //         ),
                          //         transitionsBuilder:
                          //             (context, anim1, anim2, child) =>
                          //                 FadeTransition(
                          //                     opacity: anim1, child: child),
                          //         transitionDuration: Duration(milliseconds: 0),
                          //       ));
                          // });
                        }
                      }
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("RVSP",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 20, color: Colors.white)),
                        )),
                    color: lightBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.transparent))),
                RaisedButton(
                    onPressed: () {},
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Ignore",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 20, color: Colors.white)),
                        )),
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.transparent))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column renderJios() {
    return Column(
        children: Provider.of<ExerciseProvider>(context)
            .exerciseDaysJioedByFriends
            .where((element) =>
                !element.friendIds
                    .contains(Provider.of<AuthProvider>(context).userId) &&
                Provider.of<FriendsProvider>(context).friendAvatars.firstWhere(
                        (a) => a.id == element.packLeader,
                        orElse: () => null) !=
                    null)
            .map((ed) => Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 25),
                  width: MediaQuery.of(context).size.width * 0.925,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        child: CatAvatar(
                            height: 100,
                            cat: Provider.of<FriendsProvider>(context)
                                .friendAvatars
                                .firstWhere((a) => a.id == ed.packLeader,
                                    orElse: () => null)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.925 - 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                Provider.of<FriendsProvider>(context)
                                    .friendAvatars
                                    .firstWhere((a) => a.id == ed.packLeader,
                                        orElse: () => null)
                                    .name,
                                style: GoogleFonts.fredokaOne(
                                  fontSize: 16,
                                )),
                            Text(
                                "Scheduled " +
                                    (ed.scheduledAt.isAfter(DateTime.now())
                                        ? "for " + date(ed.scheduledAt)
                                        : 'now'),
                                style: GoogleFonts.fredokaOne(
                                  fontSize: 12,
                                )),
                            RaisedButton(
                                onPressed: () {
                                  DocumentReference documentReference =
                                      FirebaseFirestore.instance
                                          .collection('workoutRooms')
                                          .doc(ed.channelName);
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
                                              Provider.of<AuthProvider>(context,
                                                      listen: false)
                                                  .userId)) {
                                        print('hello');
                                        ExerciseProvider ex =
                                            Provider.of<ExerciseProvider>(
                                                context,
                                                listen: false);
                                        ex.rvsp(ed.packLeader);
                                        transaction.update(documentReference, {
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
                                                    overflow: Overflow.visible,
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
                                    side:
                                        BorderSide(color: Colors.transparent)))
                          ],
                        ),
                      )
                    ],
                  ),
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: Future.wait([fetchFriends, fetchExerciseData]),
        builder: (context, snapshot) {
          if (!snapshot.hasError &&
              snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                backgroundColor: veryLightGreen,
                body: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(top: 25),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        renderHostButton(),
                        if (Provider.of<ExerciseProvider>(context)
                                .exerciseDaysJoinedByMe
                                .length >
                            0)
                          Expanded(
                              child: ListView(children: [
                            if (Provider.of<ExerciseProvider>(context)
                                    .exerciseDaysOrganisedByMe
                                    .length !=
                                0)
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: renderJoinButton(
                                    Provider.of<ExerciseProvider>(context)
                                        .exerciseDaysOrganisedByMe[0]),
                              ),
                            ...Provider.of<ExerciseProvider>(context)
                                .exerciseDaysJoinedByMe
                                .map((ExerciseDay day) {
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: renderJoinButton(day),
                              );
                            }).toList(),
                            renderJios(),
                          ])),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          }

          return Scaffold(
              backgroundColor: veryLightGreen,
              body: Center(
                  child: SpinKitRotatingCircle(
                color: Colors.white,
                size: 50.0,
              )));
        });
  }
}
