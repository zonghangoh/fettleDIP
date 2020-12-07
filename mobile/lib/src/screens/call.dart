import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:halpla/src/models/exerciseDay.dart';
import 'package:halpla/src/providers/friends.dart';
import 'package:halpla/src/providers/exercise.dart';
import 'package:halpla/src/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halpla/src/helpers/passport.dart';
import '../constants/ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import '../components/exercise/catTrainer.dart';
import 'package:halpla/src/providers/avatar.dart';
import 'package:lottie/lottie.dart';

const APP_ID = "aae49542fb7e4c98b20b970b8c9ebe00";

class VideoRoom extends StatefulWidget {
  static String id = 'video';
  final ExerciseDay exerciseDay;

  /// non-modifiable channel name of the page
  final String channelName;
  final String token;
  final int callerId;

  /// Creates a call page with given channel name.
  const VideoRoom(
      {Key key, this.exerciseDay, this.callerId, this.token, this.channelName})
      : super(key: key);

  @override
  VideoRoomState createState() {
    return new VideoRoomState();
  }
}

class VideoRoomState extends State<VideoRoom> with TickerProviderStateMixin {
  static final _users = List<int>();
  final _infoStrings = <String>[];

  bool collectedReward = false;

  bool muted = false;
  FirebaseAuth _fAuth = FirebaseAuth.instance;

  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer(playerId: 'my_unique_playerId');

  DateTime exerciseStartedAt;
  Stream workoutStream;

  @override
  void dispose() {
    // clear users
    _users.clear();

    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      audioPlayer.startHeadlessService();
    }
    init();
  }

  // initialize agora sdk
  init() async {
    initialize();
    workoutStream = FirebaseFirestore.instance
        .collection('workoutRooms')
        .doc(widget.channelName)
        .snapshots();
  }

  void initialize() {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings
            .add("APP_ID missing, please provide your APP_ID in settings.dart");
        _infoStrings.add("Agora Engine is not starting");
      });
      return;
    }

    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    AgoraRtcEngine.enableWebSdkInteroperability(true);
    // set parameters for Agora Engine
    AgoraRtcEngine.setParameters('{\"che.video.lowBitRateStreamParameter\"' +
        ':{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}');
    // join channel corresponding to current group
    AgoraRtcEngine.joinChannel(
        widget.token, widget.channelName, null, widget.callerId);
  }

  /// Create agora sdk instance and initialze
  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create(APP_ID);
    AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        String info = 'onError: ' + code.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        String info = 'firstRemoteVideo: ' +
            uid.toString() +
            ' ' +
            width.toString() +
            'x' +
            height.toString();
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    List<Widget> list = [
      Stack(
        children: [
          AgoraRenderWidget(
              widget.exerciseDay.friendIds.indexOf(
                      Provider.of<AuthProvider>(context, listen: false)
                          .userId) +
                  1,
              local: true,
              preview: true),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Passport.getCountryFlag(
                Provider.of<AvatarProvider>(context).country)),
          ),
        ],
      )
    ];
    _users.forEach((int uid) => {
          list.add(Stack(
            children: [
              AgoraRenderWidget(uid),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset(
                      Passport.getCountryFlag(
                          Provider.of<FriendsProvider>(context)
                                  .workoutBuddyAvatars
                                  .firstWhere(
                                      (avatar) =>
                                          avatar.id ==
                                          widget.exerciseDay.friendIds[uid - 1],
                                      orElse: () {})
                                  ?.country ??
                              Provider.of<AvatarProvider>(context).country),
                    ),
                    SizedBox(width: 10),
                    Text(
                        Provider.of<FriendsProvider>(context)
                                .workoutBuddyAvatars
                                .firstWhere(
                                    (avatar) =>
                                        avatar.id ==
                                        widget.exerciseDay.friendIds[uid - 1],
                                    orElse: () {})
                                ?.name ??
                            '',
                        style: GoogleFonts.fredokaOne(
                            fontSize: 20, color: Colors.black))
                  ],
                ),
              )
            ],
          ))
        });
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    List<Widget> wrappedViews =
        views.map((Widget view) => _videoView(view)).toList();
    return Expanded(
        child: Row(
      children: wrappedViews,
    ));
  }

  /// Video layout wrapper
  Widget _viewRows() {
    List<Widget> views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[
            _videoView(views[0]),
          ],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]]),
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3)),
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
          ],
        ));
      default:
    }
    return Container(
        child: Text("Room is at max capacity. Someone has to leave.",
            style: TextStyle(color: Colors.white)));
  }

  Widget startButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: RaisedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('workoutRooms')
                  .doc(widget.channelName)
                  .update({'startedAt': DateTime.now().millisecondsSinceEpoch});
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Start Workout",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredokaOne(
                          fontSize: 20, color: Colors.white)),
                )),
            color: lightGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.transparent))),
      ),
    );
  }

  Widget redeemRewardButton(List<String> usersWhoCollectedReward) {
    if (usersWhoCollectedReward
        .contains(Provider.of<AuthProvider>(context, listen: false).userId)) {
      return SizedBox();
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: RaisedButton(
            onPressed: () {
              collectReward(usersWhoCollectedReward);
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Collect Your Reward",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredokaOne(
                          fontSize: 20, color: Colors.white)),
                )),
            color: lightGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.transparent))),
      ),
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: lightGreen,
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: () => _onToggleMute(),
                  child: new Icon(
                    muted ? Icons.mic : Icons.mic_off,
                    color: muted ? Colors.white : lightGreen,
                    size: 20.0,
                  ),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? lightGreen : Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: () => _onSwitchCamera(),
                  child: new Icon(
                    Icons.switch_camera,
                    color: lightGreen,
                    size: 20.0,
                  ),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: ListView.builder(
                  reverse: true,
                  itemCount: _infoStrings.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_infoStrings.length == 0) {
                      return null;
                    }
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.yellowAccent,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(_infoStrings[index],
                                      style:
                                          TextStyle(color: Colors.blueGrey))))
                        ]));
                  })),
        ));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  collectReward(List<String> usersWhoCollectedReward) {
    if (!usersWhoCollectedReward
        .contains(Provider.of<AuthProvider>(context, listen: false).userId)) {
      collectedReward = true;
      FirebaseFirestore.instance
          .collection('workoutRooms')
          .doc(widget.channelName)
          .update({
        'completed': true,
        'usersWhoCollectedReward': FieldValue.arrayUnion(
            [Provider.of<AuthProvider>(context, listen: false).userId])
      });
      FirebaseFirestore.instance
          .collection('avatars')
          .doc(Provider.of<AuthProvider>(context, listen: false).userId)
          .update({
        'bonusCoins': FieldValue.increment(10),
      });
      Provider.of<AvatarProvider>(context, listen: false).bonusCoins += 10;
      Provider.of<AvatarProvider>(context, listen: false)
          .forceNotifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                content: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Lottie.asset('assets/coinDrop.json')),
                    Text(
                      "Yay! You have received 10 coins.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredokaOne(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ));
          });
    }
  }

  endSession() {
    FirebaseFirestore.instance
        .collection('workoutRooms')
        .doc(widget.channelName)
        .update({'completed': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                    stream: workoutStream,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) return SizedBox();
                      bool isHost = false;
                      if (snapshot.data['hostedBy'] ==
                          Provider.of<ExerciseProvider>(context).auth.userId)
                        isHost = true;
                      if (snapshot.data['participants'].length !=
                          Provider.of<FriendsProvider>(context)
                              .workoutBuddyAvatars
                              .length) {
                        Provider.of<FriendsProvider>(context)
                            .fetchWorkoutBuddies(
                                snapshot.data['participants'].cast<String>());
                      }
                      return Center(
                          child: Stack(
                        //uncomment _panel for debugging
                        children: <Widget>[
                          _panel(),
                          _viewRows(),
                          _toolbar(),
                          CatTrainer(
                            endSession: endSession,
                            exerciseStartedAt:
                                snapshot.data['startedAt'] == null
                                    ? null
                                    : DateTime.fromMillisecondsSinceEpoch(
                                        snapshot.data['startedAt']),
                          ),
                          if (isHost && snapshot.data['startedAt'] == null)
                            startButton(),
                          if (snapshot.data['completed'] == true &&
                              !collectedReward)
                            redeemRewardButton(snapshot
                                .data['usersWhoCollectedReward']
                                .cast<String>())
                        ],
                      ));
                    }),
              ),
            ],
          ),
        ));
  }
}
