import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halpla/src/constants/ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halpla/src/providers/database.dart';
import 'package:halpla/src/providers/friends.dart';
import 'package:halpla/src/providers/avatar.dart';
import '../models/cat.dart';
import 'package:provider/provider.dart';
import '../components/social/friend.dart';

class SearchScreen extends StatefulWidget {
  static String id = 'search';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  bool loading = false;

  final searchController = TextEditingController();
  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is removed from the
  //   // widget tree.
  //   searchController.dispose();
  //   super.dispose();
  // } //not used yet

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].data()["name"],
              );
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  bool haveUserSearched = false;
  bool sentFriendRequest = false;
  Cat foundCat;

  void initiateSearch() async {
    foundCat = await Provider.of<FriendsProvider>(context, listen: false)
        .findAFriend(searchController.text);
    setState(() {
      sentFriendRequest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: veryLightRed,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(40, 60, 40, 60),
              decoration: new BoxDecoration(
                  color: offWhite,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("Find a Friend",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredokaOne(
                              fontSize: 30, color: Colors.blueGrey)),
                    ),
                    Align(
                      child: Text("Search by Username",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredokaOne(
                              fontSize: 20, color: lightGreen)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                  hintText: "Enter Name ...",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: 60,
                            height: 60,
                            child: Icon(
                              FontAwesomeIcons.search,
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
                    if (foundCat != null) ...[
                      CatAvatar(cat: foundCat, height: 500),
                      SizedBox(height: 20),
                      Text(foundCat.name,
                          style: GoogleFonts.fredokaOne(
                              fontSize: 20, color: Colors.black)),
                      sentFriendRequest
                          ? RaisedButton(
                              onPressed: () {},
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Sent!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.fredokaOne(
                                            fontSize: 15, color: Colors.white)),
                                  )),
                              color: veryLightGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.transparent)))
                          : RaisedButton(
                              onPressed: () {
                                Provider.of<FriendsProvider>(context,
                                        listen: false)
                                    .sendFriendRequest(
                                        foundCat.id,
                                        Provider.of<AvatarProvider>(context,
                                                listen: false)
                                            .name);
                                setState(() => sentFriendRequest = true);
                              },
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Add As Friend",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.fredokaOne(
                                            fontSize: 15, color: Colors.white)),
                                  )),
                              color: lightGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.transparent)))
                    ]
                  ], // children
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(10),
                width: 60,
                height: 60,
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Colors.blueGrey,
                  size: 20,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
              ),
            ),
          ],
        ),
      ),
    );
    //Futurebuilder
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  SearchTile({this.userName});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                userName,
                style: GoogleFonts.fredokaOne(
                    fontSize: 30, color: Colors.blueGrey),
              ),
            ], // Children
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Add Friend"),
          ) // Container
        ],
      ),
    );
  }
}
