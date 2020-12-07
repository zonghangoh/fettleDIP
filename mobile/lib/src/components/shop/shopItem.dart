import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/avatar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/ui.dart';

class ShopItem extends StatefulWidget {
  final String name;
  final int price;
  final String assetURL;
  final bool hasPurchased;
  final bool isVoucher;

  final bool matchesCurrentCountry;
  final int itemId;
  final String country;
  final String description;

  const ShopItem(
      {Key key,
      this.isVoucher = false,
      this.itemId,
      this.description,
      this.name,
      this.price,
      this.assetURL,
      this.hasPurchased = false,
      this.matchesCurrentCountry = false,
      this.country})
      : super(key: key);

  @override
  _ShopItemState createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem> {
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
          Text("Not enough coins.",
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 30),
        width: MediaQuery.of(context).size.width / 4,
        child: GestureDetector(
          onTap: () {
            buyItemDialogue(
                context,
                this.widget.itemId,
                this.widget.name,
                this.widget.description ?? '',
                this.widget.price,
                this.widget.assetURL);
          },
          child: Image.asset(this.widget.assetURL),
        ),
      ),
      if (widget.hasPurchased)
        Container(
            child: GestureDetector(
          onTap: () {
            if (widget.isVoucher) {
              useVoucherDialog(context, this.widget.itemId, this.widget.name,
                  this.widget.description, this.widget.assetURL);
              return;
            }
            equipItemDialogue(context, this.widget.itemId, this.widget.name,
                this.widget.assetURL);
          },
          child: Image.asset('assets/Owned.png', width: 100),
        )),
      if (!widget.hasPurchased && !widget.matchesCurrentCountry)
        Container(
            child: GestureDetector(
          onTap: () {
            unavailableDialogue(context, this.widget.name, this.widget.assetURL,
                this.widget.country);
          },
          child: Image.asset('assets/Unavailable.png', width: 100),
        )),
    ]);
  }

  void buyItemDialogue(context, int itemId, String name, String description,
      int price, String assetURL) {
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
                      "Buy " + name + "?",
                      style: GoogleFonts.fredokaOne(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      description,
                      style: GoogleFonts.fredokaOne(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 40),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Image.asset(assetURL),
                    ),
                    SizedBox(
                      height: 40,
                      width: 150,
                      child: RaisedButton(
                          onPressed: () {
                            if (Provider.of<AvatarProvider>(context,
                                        listen: false)
                                    .coinsLeft <
                                price) {
                              _showToast();
                            } else {
                              Provider.of<AvatarProvider>(context,
                                      listen: false)
                                  .buyItem(itemId, price);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/coin.png',
                                width: 20,
                                height: 20,
                              ),
                              Text(price.toString(),
                                  style: GoogleFonts.fredokaOne(
                                      fontSize: 16, color: Colors.white))
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ]),
          ));
        });
  }

  void useVoucherDialog(
      context, int itemId, String name, String description, String assetURL) {
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
                      "Use " + name + " voucher?",
                      style: GoogleFonts.fredokaOne(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      description,
                      style: GoogleFonts.fredokaOne(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 40),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Image.asset(assetURL),
                    ),
                    SizedBox(
                      height: 40,
                      width: 150,
                      child: RaisedButton(
                          onPressed: () {
                            Provider.of<AvatarProvider>(context, listen: false)
                                .useVoucher(itemId);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          color: Colors.blue,
                          child: Text('Yes!',
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 16, color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ]),
          ));
        });
  }

  void equipItemDialogue(context, int itemId, String name, String assetURL) {
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
                      "Wear " + name + "?",
                      style: GoogleFonts.fredokaOne(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 40),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Image.asset(assetURL),
                    ),
                    SizedBox(
                      height: 40,
                      width: 150,
                      child: RaisedButton(
                          onPressed: () {
                            Provider.of<AvatarProvider>(context, listen: false)
                                .equipItem(itemId);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          color: Colors.blue,
                          child: Text('Yes!',
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 16, color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ]),
          ));
        });
  }

  void unavailableDialogue(
      context, String name, String assetURL, String country) {
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
                      'You can only buy ' + name + " in " + country,
                      style: GoogleFonts.fredokaOne(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 40),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Image.asset(assetURL),
                    ),
                    SizedBox(
                      height: 40,
                      width: 150,
                      child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.blue,
                          child: Text('Okay!',
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 16, color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ]),
          ));
        });
  }
}
