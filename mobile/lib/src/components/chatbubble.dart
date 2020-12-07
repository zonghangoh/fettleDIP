import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:math';
import '../constants/ui.dart';
import 'package:provider/provider.dart';
import '../providers/avatar.dart';
import '../providers/auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Message extends StatefulWidget {
  const Message({Key key, this.message, this.groupChatId}) : super(key: key);
  final Map message;
  final String groupChatId;
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  void initState() {
    super.initState();
    if (!widget.message['read'] &&
        widget.message['from'] !=
            Provider.of<AvatarProvider>(context, listen: false).auth.userId) {
      FirebaseFirestore.instance
          .collection("chatlog")
          .doc(widget.groupChatId)
          .collection('messages')
          .doc(widget.message['timestamp'].toString())
          .update({'read': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message['from'] ==
        Provider.of<AvatarProvider>(context).auth.userId)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SpeechBubble(
            color: Colors.white,
            nipLocation: NipLocation.BOTTOM_RIGHT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                renderContent(true),
                Container(
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          DateTime.fromMillisecondsSinceEpoch(
                                      widget.message['timestamp'])
                                  .hour
                                  .toString() +
                              ":" +
                              (DateTime.fromMillisecondsSinceEpoch(
                                              widget.message['timestamp'])
                                          .minute <
                                      10
                                  ? "0"
                                  : '') +
                              DateTime.fromMillisecondsSinceEpoch(
                                      widget.message['timestamp'])
                                  .minute
                                  .toString(),
                          style: TextStyle(fontSize: 8, color: Colors.black)),
                      SizedBox(width: 5),
                      if (widget.message['read'])
                        Icon(FontAwesomeIcons.check,
                            color: Colors.black, size: 10)
                    ],
                  ),
                ),
              ],
            )),
      );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SpeechBubble(
          color: purple,
          nipLocation: NipLocation.BOTTOM_LEFT,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              renderContent(false),
              Text(
                  DateTime.fromMillisecondsSinceEpoch(
                              widget.message['timestamp'])
                          .hour
                          .toString() +
                      ":" +
                      (DateTime.fromMillisecondsSinceEpoch(
                                      widget.message['timestamp'])
                                  .minute <
                              10
                          ? "0"
                          : '') +
                      DateTime.fromMillisecondsSinceEpoch(
                              widget.message['timestamp'])
                          .minute
                          .toString(),
                  style: TextStyle(fontSize: 8, color: Colors.white)),
            ],
          )),
    );
  }

  Widget renderContent(bool fromMe) {
    if (widget.message['type'] == 0)
      return Text(widget.message['content'],
          style: TextStyle(color: fromMe ? Colors.black : Colors.white));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Workout with me on ' +
                DateFormat.yMMMMEEEEd().format(
                    DateTime.fromMillisecondsSinceEpoch(
                        widget.message['startsAt'])) +
                ' at ' +
                DateTime.fromMillisecondsSinceEpoch(widget.message['startsAt'])
                    .hour
                    .toString() +
                ":" +
                (DateTime.fromMillisecondsSinceEpoch(widget.message['startsAt'])
                            .minute <
                        10
                    ? "0"
                    : '') +
                DateTime.fromMillisecondsSinceEpoch(widget.message['startsAt'])
                    .minute
                    .toString(),
            style: TextStyle(color: fromMe ? Colors.black : Colors.white)),
        if (!fromMe && widget.message['response'] == 0)
          RaisedButton(
            color: Colors.white,
            onPressed: () {
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('workoutRooms')
                  .doc(widget.message['channelName']);
              FirebaseFirestore.instance.runTransaction((transaction) async {
                return transaction.get(documentReference).then((sfDoc) {
                  if (!sfDoc.exists) {
                    throw "Document does not exist!";
                  }
                  Map roomData = sfDoc.data();
                  int numberOfParticipants = roomData['participants'].length;
                  if (numberOfParticipants < 4 &&
                      !roomData['participants'].contains(
                          Provider.of<AuthProvider>(context, listen: false)
                              .userId)) {
                    FirebaseFirestore.instance
                        .collection("chatlog")
                        .doc(widget.groupChatId)
                        .collection('messages')
                        .doc(widget.message['timestamp'].toString())
                        .update({'response': 1});
                    transaction.update(documentReference, {
                      'participants': [
                        ...roomData['participants'],
                        Provider.of<AuthProvider>(context, listen: false).userId
                      ]
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
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
                                    Text("Workout Room Is Full."),
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
            child: Text('Okay'),
          ),
        if (!fromMe && widget.message['response'] == 1)
          Text('You have RVSPed.',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.6))),
        if (fromMe && widget.message['response'] == 1)
          Text('Your friend has RVSPed.',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black.withOpacity(0.6))),
        if (fromMe && widget.message['response'] == 0)
          Text('Pending response.',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black.withOpacity(0.6)))
      ],
    );
  }
}

enum NipLocation {
  TOP,
  RIGHT,
  BOTTOM,
  LEFT,
  BOTTOM_RIGHT,
  BOTTOM_LEFT,
  TOP_RIGHT,
  TOP_LEFT
}

const defaultNipHeight = 10.0;
var rotatedNip;

class SpeechBubble extends StatelessWidget {
  /// Creates a widget that emulates a speech bubble.
  /// Could be used for a tooltip, or as a pop-up notification, etc.
  SpeechBubble(
      {Key key,
      @required this.child,
      this.nipLocation: NipLocation.BOTTOM,
      this.color: Colors.redAccent,
      this.borderRadius: 4.0,
      this.height,
      this.width,
      this.padding,
      this.nipHeight = defaultNipHeight,
      this.offset = Offset.zero})
      : super(key: key);

  /// The [child] contained by the [SpeechBubble]
  final Widget child;

  /// The location of the nip of the speech bubble.
  ///
  /// Use [NipLocation] enum, either [TOP], [RIGHT], [BOTTOM], or [LEFT].
  /// The nip will automatically center to the side that it is assigned.
  final NipLocation nipLocation;

  /// The color of the body of the [SpeechBubble] and nip.
  /// Defaultly red.
  final Color color;

  /// The [borderRadius] of the [SpeechBubble].
  /// The [SpeechBubble] is built with a circular border radius on all 4 corners.
  final double borderRadius;

  /// The explicitly defined height of the [SpeechBubble].
  /// The [SpeechBubble] will defaultly enclose its [child].
  final double height;

  /// The explicitly defined width of the [SpeechBubble].
  /// The [SpeechBubble] will defaultly enclose its [child].
  final double width;

  /// The padding between the child and the edges of the [SpeechBubble].
  final EdgeInsetsGeometry padding;

  /// The nip height
  final double nipHeight;

  final Offset offset;

  Widget build(BuildContext context) {
    Offset nipOffset;
    AlignmentGeometry alignment;
    var rotatedNipHalfHeight = getNipHeight(nipHeight) / 2;
    var offset = nipHeight / 2 + rotatedNipHalfHeight;
    switch (this.nipLocation) {
      case NipLocation.TOP:
        nipOffset = Offset(0.0, -offset + rotatedNipHalfHeight);
        alignment = Alignment.topCenter;
        break;
      case NipLocation.RIGHT:
        nipOffset = Offset(offset - rotatedNipHalfHeight, 0.0);
        alignment = Alignment.centerRight;
        break;
      case NipLocation.BOTTOM:
        nipOffset = Offset(0.0, offset - rotatedNipHalfHeight);
        alignment = Alignment.bottomCenter;
        break;
      case NipLocation.LEFT:
        nipOffset = Offset(-offset + rotatedNipHalfHeight, 0.0);
        alignment = Alignment.centerLeft;
        break;
      case NipLocation.BOTTOM_LEFT:
        nipOffset = this.offset +
            Offset(
                offset - rotatedNipHalfHeight, offset - rotatedNipHalfHeight);
        alignment = Alignment.bottomLeft;
        break;
      case NipLocation.BOTTOM_RIGHT:
        nipOffset = this.offset +
            Offset(
                -offset + rotatedNipHalfHeight, offset - rotatedNipHalfHeight);
        alignment = Alignment.bottomRight;
        break;
      case NipLocation.TOP_LEFT:
        nipOffset = this.offset +
            Offset(
                offset - rotatedNipHalfHeight, -offset + rotatedNipHalfHeight);
        alignment = Alignment.topLeft;
        break;
      case NipLocation.TOP_RIGHT:
        nipOffset = this.offset +
            Offset(
                -offset + rotatedNipHalfHeight, -offset + rotatedNipHalfHeight);
        alignment = Alignment.topRight;
        break;
      default:
    }

    return Stack(
      alignment: alignment,
      children: <Widget>[
        speechBubble(),
        nip(nipOffset),
      ],
    );
  }

  Widget speechBubble() {
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(this.borderRadius),
      ),
      color: this.color,
      elevation: 1.0,
      child: Container(
        height: this.height,
        width: this.width,
        padding: this.padding ?? const EdgeInsets.all(8.0),
        child: this.child,
      ),
    );
  }

  Widget nip(Offset nipOffset) {
    return Transform.translate(
      offset: nipOffset,
      child: RotationTransition(
        turns: AlwaysStoppedAnimation(45 / 360),
        child: Material(
          borderRadius: BorderRadius.all(
            Radius.circular(1.5),
          ),
          color: this.color,
          child: Container(
            height: nipHeight,
            width: nipHeight,
          ),
        ),
      ),
    );
  }

  double getNipHeight(double nipHeight) => sqrt(2 * pow(nipHeight, 2));
}
