class Item {
  final int id;
  final String name;
  final int price;
  final String assetURL;
  final String country;
  final String description;
  Item(
      {this.id,
      this.description = '',
      this.name,
      this.price,
      this.assetURL,
      this.country});
}
