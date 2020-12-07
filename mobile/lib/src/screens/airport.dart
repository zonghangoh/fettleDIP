import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/avatar.dart';

import '../constants/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class AirportScreen extends StatefulWidget {
  static String id = 'airport';
  @override
  _AirportScreenState createState() => _AirportScreenState();
}

class _AirportScreenState extends State<AirportScreen> {
  bool loading = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _signOut() async {
    setState(() => loading = true);
    Provider.of<AuthProvider>(context, listen: false).smsLogout();
    setState(() => loading = false);
  }

  confirmTicketPurchase(String country, int coins) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      title: Text(""),
      content: TicketPass(
        shouldExpand: false,
        alignment: Alignment.center,
        separatorColor: Colors.black,
        separatorHeight: 2.0,
        color: Colors.white,
        curve: Curves.easeOut,
        titleColor: Colors.transparent,
        ticketTitle: Text(
          '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        expandIcon: SizedBox(),
        titleHeight: 50,
        width: 300,
        height: 200,
        shadowColor: Colors.blue.withOpacity(0.5),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Confirm Flight',
                  style: GoogleFonts.fredokaOne(
                      fontSize: 24, color: Colors.blueGrey)),
              Text('to ' + country + '?',
                  style: GoogleFonts.fredokaOne(
                      fontSize: 24, color: Colors.blueGrey)),
              SizedBox(height: 25),
              RaisedButton(
                  onPressed: () {
                    // JERAL
                    // NEED TO PUT LISTEN: FALSE INSIDE ONPRESSED IF INTERACTING WITH PROVIDER, IF NT CODE WILL NOT RUN
                    if (Provider.of<AvatarProvider>(context, listen: false)
                            .coinsLeft <
                        coins) {
                    } else {
                      Provider.of<AvatarProvider>(context, listen: false)
                          .flyToCountry(country, 100);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("FLY AWAY",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredokaOne(
                                fontSize: 20, color: Colors.white)),
                      )),
                  color: (Provider.of<AvatarProvider>(context, listen: false)
                              .coinsLeft <
                          coins)
                      ? Colors.grey
                      : lightBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.transparent)))
            ],
          ),
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        // future: Provider.of<AvatarProvider>(context).fetchBioData(),
        builder: (context, snapshot) {
      if (snapshot.hasError ||
          snapshot.connectionState != ConnectionState.done) {
        return Scaffold(
            backgroundColor: offWhite,
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
                          child: ListView(
                            children: [
                              InkWell(
                                onTap: () =>
                                    confirmTicketPurchase('Japan', 100),
                                child: Container(
                                  padding: EdgeInsets.all(25),
                                  margin: EdgeInsets.only(bottom: 25),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(
                                            lightPink.withOpacity(0.75),
                                            BlendMode.dstATop),
                                        image: AssetImage(
                                            "assets/japanBackground.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("JAPAN",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredokaOne(
                                                fontSize: 20,
                                                color: Colors.black87)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("KIMOCHI.",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredokaOne(
                                                fontSize: 14,
                                                color: Colors.black54)),
                                      ),
                                      SizedBox(height: 20),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/coin.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                              Text(' 100',
                                                  style: GoogleFonts.fredokaOne(
                                                      fontSize: 16,
                                                      color: Colors.black))
                                            ],
                                          ),
                                          width: 60,
                                          height: 38,
                                          decoration: BoxDecoration(
                                              color: lightBlue,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    confirmTicketPurchase('Hawaii', 100),
                                child: Container(
                                  padding: EdgeInsets.all(25),
                                  margin: EdgeInsets.only(bottom: 25),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(
                                            lightPink.withOpacity(0.75),
                                            BlendMode.dstATop),
                                        image: AssetImage(
                                            "assets/hawaiiBackground.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("HAWAII",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredokaOne(
                                                fontSize: 20,
                                                color: Colors.black87)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("SAWADI.",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredokaOne(
                                                fontSize: 14,
                                                color: Colors.black54)),
                                      ),
                                      SizedBox(height: 20),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: () => {},
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  'assets/coin.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                Text(' 100',
                                                    style:
                                                        GoogleFonts.fredokaOne(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black))
                                              ],
                                            ),
                                            width: 60,
                                            height: 38,
                                            decoration: BoxDecoration(
                                                color: lightBlue,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    confirmTicketPurchase('Singapore', 100),
                                child: Container(
                                  padding: EdgeInsets.all(25),
                                  margin: EdgeInsets.only(bottom: 25),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(
                                            lightPink.withOpacity(0.75),
                                            BlendMode.dstATop),
                                        image: AssetImage(
                                            "assets/singaporeBackground.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Singapore",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredokaOne(
                                                fontSize: 20,
                                                color: Colors.black87)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("HAHAHA.",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.fredokaOne(
                                                fontSize: 14,
                                                color: Colors.black54)),
                                      ),
                                      SizedBox(height: 20),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: () => {},
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  'assets/coin.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                Text(' 100',
                                                    style:
                                                        GoogleFonts.fredokaOne(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black))
                                              ],
                                            ),
                                            width: 60,
                                            height: 38,
                                            decoration: BoxDecoration(
                                                color: lightBlue,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Now COVID I scared",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.fredokaOne(
                                        fontSize: 20, color: Colors.white)),
                              )),
                          color: lightGreen,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.transparent))),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/coin.png',
                            width: 20,
                            height: 20,
                          ),
                          Text(
                              ' ' +
                                  Provider.of<AvatarProvider>(context)
                                      .coinsLeft
                                      .toString(),
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 16, color: Colors.blueGrey))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
      }

      return Scaffold(
          // backgroundColor: Provider.of<AvatarProvider>(context).onboarded
          //     ? mainBackgroundColor
          //     : darkBackgroundColor,
          body: Stack(
        children: <Widget>[],
      ));
    });
  }
}

class TicketPass extends StatefulWidget {
  const TicketPass({
    this.width = 300,
    @required this.child,
    this.color = Colors.white,
    this.height = 200,
    this.elevation = 1.0,
    this.shadowColor = Colors.black,
    this.expandedHeight = 500,
    this.shouldExpand = false,
    this.curve = Curves.easeOut,
    this.animationDuration = const Duration(seconds: 1),
    this.alignment = Alignment.center,
    this.expandIcon = const CircleAvatar(
      maxRadius: 14,
      child: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
        size: 20,
      ),
    ),
    this.shrinkIcon = const CircleAvatar(
      maxRadius: 14,
      child: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
        size: 20,
      ),
    ),
    this.separatorHeight = 1.0,
    this.separatorColor = Colors.black,
    this.expansionTitle = const Text(
      'Purchased By',
      style: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),
    this.titleColor = Colors.blue,
    this.titleHeight = 50.0,
    this.purchaserList,
    this.ticketTitle = const Text(
      'Sample title',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    this.expansionChild,
  });

  final double width;
  final double height;
  final double expandedHeight;
  final double elevation;
  final double titleHeight;
  final Widget child;
  final Color color;
  final Color shadowColor;
  final Color titleColor;
  final bool shouldExpand;
  final Curve curve;
  final Duration animationDuration;
  final Alignment alignment;
  final Widget expandIcon;
  final Widget shrinkIcon;
  final Color separatorColor;
  final double separatorHeight;
  final Text expansionTitle;
  final Text ticketTitle;
  final Widget expansionChild;
  final List<String> purchaserList;

  @override
  _TicketPassState createState() => _TicketPassState();
}

class _TicketPassState extends State<TicketPass> {
  bool switcher = false;
  List<String> sample = <String>[
    'Sample 1',
    'Sample 2',
    'Sample 3',
    'Sample 4',
    'Sample 5',
    'Sample 6',
    'Sample 7',
    'Sample 8'
  ];

  Widget _myWidget() {
    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            widget.child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      clipper: TicketClipper(),
      color: widget.color,
      elevation: widget.elevation,
      shadowColor: widget.shadowColor,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: widget.curve,
        width: widget.width,
        height: widget.shouldExpand
            ? switcher
                ? widget.expandedHeight
                : widget.height
            : widget.height,
        child: _myWidget(),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0.0, 55);
    path.relativeArcToPoint(const Offset(0, 40),
        radius: const Radius.circular(10.0), largeArc: true);
    path.lineTo(0.0, size.height - 10);
    path.quadraticBezierTo(0.0, size.height, 10.0, size.height);
    path.lineTo(size.width - 10.0, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 10);
    path.lineTo(size.width, 95);
    path.arcToPoint(Offset(size.width, 55),
        radius: const Radius.circular(10.0), clockwise: true);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(10.0, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 10.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ExtendedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0.0, 55);
    path.relativeArcToPoint(const Offset(0, 40),
        radius: const Radius.circular(10.0), largeArc: true);
    path.lineTo(0.0, size.height - 10);
    path.quadraticBezierTo(0.0, size.height, 10.0, size.height);
    path.lineTo(size.width - 10.0, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 10);
    path.lineTo(size.width, 95);
    path.arcToPoint(Offset(size.width, 55),
        radius: const Radius.circular(10.0), clockwise: true);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(10.0, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 10.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
