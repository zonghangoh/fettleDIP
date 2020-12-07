import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/avatar.dart';
import '../constants/ui.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/shop/shopItem.dart';
import '../helpers/shop.dart';

class ShopScreen extends StatefulWidget {
  static String id = 'shop';
  final bool showVouchers;

  const ShopScreen({
    Key key,
    this.showVouchers = false,
  }) : super(key: key);
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool loading = false;
  TextEditingController textEditingController = TextEditingController();
  bool showingVoucher = false;

  @override
  void initState() {
    super.initState();
    if (widget.showVouchers) showingVoucher = true;
  }

  void _signOut() async {
    setState(() => loading = true);
    Provider.of<AuthProvider>(context, listen: false).smsLogout();
    setState(() => loading = false);
  }

  Widget buildShelves() {
    if (!showingVoucher)
      return Expanded(
        child: new ListView.builder(
            itemCount: ClothesShop.shelvesNumber,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                        child: Image.asset('assets/tray.png')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ShopItem(
                            key: ValueKey(
                                ClothesShop.availableItems[index * 2].id),
                            description: ClothesShop
                                .availableItems[index * 2].description,
                            itemId: ClothesShop.availableItems[index * 2].id,
                            name: ClothesShop.availableItems[index * 2].name,
                            price: ClothesShop.availableItems[index * 2].price,
                            assetURL:
                                ClothesShop.availableItems[index * 2].assetURL,
                            country:
                                ClothesShop.availableItems[index * 2].country,
                            hasPurchased: Provider.of<AvatarProvider>(context)
                                    .itemIds
                                    .contains(ClothesShop
                                        .availableItems[index * 2].id) &&
                                ClothesShop.availableItems[index * 2].id != 8,
                            matchesCurrentCountry: ClothesShop
                                        .availableItems[index * 2].country ==
                                    Provider.of<AvatarProvider>(context)
                                        .country ||
                                ClothesShop.availableItems[index * 2].country ==
                                    'all'),
                        if (index * 2 + 1 < ClothesShop.availableItems.length)
                          ShopItem(
                              key: ValueKey(
                                  ClothesShop.availableItems[index * 2 + 1].id),
                              itemId:
                                  ClothesShop.availableItems[index * 2 + 1].id,
                              name: ClothesShop
                                  .availableItems[index * 2 + 1].name,
                              price: ClothesShop
                                  .availableItems[index * 2 + 1].price,
                              assetURL: ClothesShop
                                  .availableItems[index * 2 + 1].assetURL,
                              country: ClothesShop
                                  .availableItems[index * 2 + 1].country,
                              description: ClothesShop
                                  .availableItems[index * 2 + 1].description,
                              hasPurchased: Provider.of<AvatarProvider>(context)
                                      .itemIds
                                      .contains(ClothesShop
                                          .availableItems[index * 2 + 1].id) &&
                                  ClothesShop
                                          .availableItems[index * 2 + 1].id !=
                                      8,
                              matchesCurrentCountry: ClothesShop
                                          .availableItems[index * 2 + 1]
                                          .country ==
                                      Provider.of<AvatarProvider>(context)
                                          .country ||
                                  ClothesShop.availableItems[index * 2 + 1]
                                          .country ==
                                      'all'),
                      ],
                    )
                  ]));
            }),
      );

    return Expanded(
      child: new ListView.builder(
          itemCount: VoucherShop.shelvesNumber,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                      child: Image.asset('assets/tray.png')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ShopItem(
                          key: ValueKey(
                              VoucherShop.availableItems[index * 2].id),
                          isVoucher: true,
                          description:
                              VoucherShop.availableItems[index * 2].description,
                          itemId: VoucherShop.availableItems[index * 2].id,
                          name: VoucherShop.availableItems[index * 2].name,
                          price: VoucherShop.availableItems[index * 2].price,
                          assetURL:
                              VoucherShop.availableItems[index * 2].assetURL,
                          country:
                              VoucherShop.availableItems[index * 2].country,
                          hasPurchased: Provider.of<AvatarProvider>(context)
                                  .itemIds
                                  .contains(VoucherShop
                                      .availableItems[index * 2].id) &&
                              VoucherShop.availableItems[index * 2].id != 8,
                          matchesCurrentCountry: VoucherShop
                                      .availableItems[index * 2].country ==
                                  Provider.of<AvatarProvider>(context)
                                      .country ||
                              VoucherShop.availableItems[index * 2].country ==
                                  'all'),
                      if (index * 2 + 1 < VoucherShop.availableItems.length)
                        ShopItem(
                            key: ValueKey(
                                VoucherShop.availableItems[index * 2 + 1].id),
                            isVoucher: true,
                            description: VoucherShop
                                .availableItems[index * 2 + 1].description,
                            itemId:
                                VoucherShop.availableItems[index * 2 + 1].id,
                            name:
                                VoucherShop.availableItems[index * 2 + 1].name,
                            price:
                                VoucherShop.availableItems[index * 2 + 1].price,
                            assetURL: VoucherShop
                                .availableItems[index * 2 + 1].assetURL,
                            country: VoucherShop
                                .availableItems[index * 2 + 1].country,
                            hasPurchased: Provider.of<AvatarProvider>(context)
                                    .itemIds
                                    .contains(VoucherShop
                                        .availableItems[index * 2 + 1].id) &&
                                VoucherShop.availableItems[index * 2 + 1].id !=
                                    8,
                            matchesCurrentCountry: VoucherShop
                                        .availableItems[index * 2 + 1]
                                        .country ==
                                    Provider.of<AvatarProvider>(context)
                                        .country ||
                                VoucherShop.availableItems[index * 2 + 1]
                                        .country ==
                                    'all'),
                    ],
                  )
                ]));
          }),
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
            backgroundColor: veryLightBlue,
            body: SafeArea(
              top: false,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Row(children: [
                              ...List.generate(
                                  9,
                                  (index) => Container(
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                9,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(40),
                                                bottomLeft:
                                                    Radius.circular(40)),
                                            color: index % 2 == 0
                                                ? lightRed
                                                : Colors.white,
                                            border: Border.all(
                                                width: 3,
                                                color: index % 2 == 0
                                                    ? lightRed
                                                    : Colors.white,
                                                style: BorderStyle.solid)),
                                        child: Center(child: Text('')),
                                      )),
                            ]),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  decoration: BoxDecoration(
                                      color: offWhite.withOpacity(0.6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Swag ',
                                          style: GoogleFonts.fredokaOne(
                                              fontSize: 12,
                                              color: Colors.black)),
                                      Switch(
                                        inactiveThumbColor: Colors.black,
                                        inactiveTrackColor: Colors.black,
                                        activeTrackColor: Colors.black,
                                        value: showingVoucher,
                                        onChanged: (value) {
                                          setState(() {
                                            showingVoucher = value;
                                            // print(isSwitched);
                                          });
                                        },
                                        activeColor: Colors.black,
                                      ),
                                      Text(' Vouchers',
                                          style: GoogleFonts.fredokaOne(
                                              fontSize: 12,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildShelves(),
                            SizedBox(height: 20),
                            Column(
                              children: <Widget>[
                                RaisedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("I'm Done",
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
                                            fontSize: 16,
                                            color: Colors.blueGrey))
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                  ],
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
