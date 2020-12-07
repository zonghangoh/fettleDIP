import '../models/item.dart';

class ClothesShop {
  static List<Item> availableItems = [
    Item(
        id: 1,
        assetURL: 'assets/japaneseBlack.png',
        price: 100,
        name: 'Japanese Black',
        country: 'Japan'),
    Item(
        id: 2,
        assetURL: 'assets/japanesePink.png',
        price: 100,
        name: 'Japanese Pink',
        country: 'Japan'),
    Item(
        id: 3,
        assetURL: 'assets/hawaiiSuit.png',
        price: 100,
        name: 'Hawaii Suit',
        country: 'Hawaii'),
    Item(
        id: 4,
        assetURL: 'assets/ntuRed.png',
        price: 100,
        name: 'NTU Red',
        country: 'Singapore'),
    Item(
        id: 5,
        assetURL: 'assets/ntuBlue.png',
        price: 100,
        name: 'NTU Blue',
        country: 'Singapore'),
    Item(
        id: 6,
        assetURL: 'assets/iemWhite.png',
        price: 100,
        name: 'IEM White',
        country: 'all'),
    Item(
        id: 7,
        assetURL: 'assets/iemBlack.png',
        price: 100,
        name: 'IEM Black',
        country: 'all'),
  ];
  static int get shelvesNumber => (availableItems.length / 2).ceil();
}

class VoucherShop {
  static List<Item> availableItems = [
    Item(
        id: 8,
        assetURL: 'assets/ntucVoucher.png',
        price: 10000,
        name: 'NTUC Voucher',
        description: "\$10 worth of NTUC vouchers yay.",
        country: 'all'),
    Item(
        id: 9,
        assetURL: 'assets/bubbleTea.png',
        price: 1000,
        name: 'WaHo Bubble Tea',
        description:
            "\$2 off your next drink. Minimum spend \$4 before discount wow.",
        country: 'all'),
  ];
  static int get shelvesNumber => (availableItems.length / 2).ceil();
}
