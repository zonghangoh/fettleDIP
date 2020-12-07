import 'package:flutter/material.dart';
import 'package:halpla/src/models/cat.dart';
import 'package:halpla/src/providers/auth.dart';
import 'package:provider/provider.dart';
import '../providers/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/social/friend.dart';
import '../helpers/passport.dart';
import '../components/chatbubble.dart';
import '../helpers/pusher.dart';

class ConversationScreen extends StatefulWidget {
  static String id = 'conversation';
  final Cat peerCat;
  final String groupChatId;
  const ConversationScreen({
    Key key,
    this.groupChatId,
    this.peerCat,
  }) : super(key: key);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with WidgetsBindingObserver {
  bool loading = false;
  TextEditingController textEditingController = TextEditingController();
  Stream messageStream;
  Stream presenceStream;
  bool peerIsInChat = false;
  final ScrollController listScrollController = new ScrollController();
  final TextEditingController textController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    messageStream = FirebaseFirestore.instance
        .collection('chatlog')
        .doc(widget.groupChatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots();

    presenceStream = FirebaseFirestore.instance
        .collection('presence')
        .doc(widget.peerCat.id)
        .snapshots();

    FirebaseFirestore.instance
        .collection('presence')
        .doc(Provider.of<AvatarProvider>(context, listen: false).auth.userId)
        .set({
      'online': true,
      'lastOnline': DateTime.now().millisecondsSinceEpoch,
      'chatRoom': widget.groupChatId,
      'newFrom': FieldValue.arrayRemove([widget.peerCat.id])
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  sendMessage() {
    if (textController.text.length == 0) return;

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    var documentReference = FirebaseFirestore.instance
        .collection('chatlog')
        .doc(widget.groupChatId)
        .collection('messages')
        .doc(timeStamp.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      //  transaction.delete
      transaction.set(
        documentReference,
        {
          'from':
              Provider.of<AvatarProvider>(context, listen: false).auth.userId,
          'to': widget.peerCat.id,
          'nameFrom': Provider.of<AvatarProvider>(context, listen: false).name,
          'timestamp': timeStamp,
          'content': textController.text,
          'type': 0,
          'read': false
        },
      );
    }).then((value) {
      if (!peerIsInChat) {
        FirebaseFirestore.instance
            .collection('presence')
            .doc(widget.peerCat.id)
            .update({
          'newFrom': FieldValue.arrayUnion(
              [Provider.of<AuthProvider>(context, listen: false).userId])
        });

        Pusher.sendNotification(
            title: Provider.of<AvatarProvider>(context, listen: false).name,
            message: textController.text,
            peerPushToken: widget.peerCat.pushToken);
      }
      textController.clear();
    });

    FirebaseFirestore.instance
        .collection("chatlog")
        .doc(widget.groupChatId)
        .set({
      'lastSentAt': DateTime.now().millisecondsSinceEpoch,
      'cats': [
        Provider.of<AvatarProvider>(context, listen: false).auth.userId,
        widget.peerCat.id
      ]
    }, SetOptions(merge: true));
  }

  Widget onlineMarker() {
    return StreamBuilder(
        key: Key("online"),
        stream: presenceStream,
        builder: (context, snap) {
          DocumentSnapshot snapDataPre =
              snap.hasData ? (snap.data ?? null) : null;
          Map snapData = {
            'online': false,
            'chatRoom': '',
            'lastOnline': DateTime.now()
                .subtract(Duration(days: 1))
                .millisecondsSinceEpoch,
          };
          if (snapDataPre != null)
            snapData = snapDataPre.data() ??
                {
                  'online': false,
                  'chatRoom': '',
                  'lastOnline': DateTime.now()
                      .subtract(Duration(days: 1))
                      .millisecondsSinceEpoch,
                };
          if (snapData['online'] &&
              snapData['chatRoom'] == widget.groupChatId) {
            peerIsInChat = true;
          } else {
            peerIsInChat = false;
          }
          return Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            width: 10,
            height: 10,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: peerIsInChat &&
                      DateTime.now().subtract(Duration(minutes: 30)).isBefore(
                          DateTime.fromMillisecondsSinceEpoch(
                              snapData['lastOnline']))
                  ? Colors.green
                  : Colors.red,
            ),
          );
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FirebaseFirestore.instance
          .collection('presence')
          .doc(Provider.of<AvatarProvider>(context, listen: false).auth.userId)
          .set({
        'online': false,
        'lastOnline': DateTime.now().millisecondsSinceEpoch,
        'chatRoom': '',
        'newFrom': FieldValue.arrayRemove([widget.peerCat.id])
      });
    } else if (state == AppLifecycleState.resumed) {
      FirebaseFirestore.instance
          .collection('presence')
          .doc(Provider.of<AvatarProvider>(context, listen: false).auth.userId)
          .set({
        'online': true,
        'lastOnline': DateTime.now().millisecondsSinceEpoch,
        'chatRoom': widget.groupChatId,
        'newFrom': FieldValue.arrayRemove([widget.peerCat.id])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: veryLightRed,
            leading: InkWell(
                child: Icon(FontAwesomeIcons.chevronLeft, color: Colors.black),
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('presence')
                      .doc(Provider.of<AvatarProvider>(context, listen: false)
                          .auth
                          .userId)
                      .set({
                    'online': false,
                    'lastOnline': DateTime.now().millisecondsSinceEpoch,
                    'chatRoom': '',
                    'newFrom': FieldValue.arrayRemove([widget.peerCat.id])
                  }).then((value) => Navigator.pop(context));
                }),
            title: Row(
              children: [
                Text(widget.peerCat.name,
                    style: TextStyle(color: Colors.black)),
                onlineMarker()
              ],
            )),
        backgroundColor: veryLightRed,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Passport.getCountryChatBG(
                                widget.peerCat.country)),
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit.cover)),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                              stream: messageStream,
                              builder: (context, AsyncSnapshot snap) {
                                QuerySnapshot snapData =
                                    snap.hasData ? (snap.data ?? null) : null;
                                if (snapData == null ||
                                    snapData.docs.length == 0) {
                                  return SizedBox();
                                }
                                return ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  cacheExtent: 100000.0,
                                  addAutomaticKeepAlives: true,
                                  padding:
                                      EdgeInsets.fromLTRB(10, 25, 10, 10.0),
                                  itemBuilder: (context, index) => Message(
                                      key: ValueKey(snapData.docs[index].id),
                                      groupChatId: widget.groupChatId,
                                      message: snapData.docs[index].data()),
                                  itemCount: snapData.docs.length,
                                  reverse: true,
                                  controller: listScrollController,
                                );
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CatAvatar(height: 150, cat: widget.peerCat),
                            CatAvatar(
                                height: 150,
                                cat:
                                    Provider.of<AvatarProvider>(context).myCat),
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    )),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 50,
                        width: MediaQuery.of(context).size.width - 40,
                        child: TextField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              focusedBorder: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.transparent)),
                              hoverColor: Colors.transparent,
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent),
                          controller: textController,
                        )),
                    InkWell(
                        onTap: sendMessage,
                        child: Icon(
                          Icons.send,
                          size: 25,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
