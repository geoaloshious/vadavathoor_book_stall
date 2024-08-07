class ForNewSaleBookPurchaseVariant {
  final String purchaseID;
  final int purchaseDate;
  final int quantity;
  final double price;

  ForNewSaleBookPurchaseVariant(
      {required this.purchaseID,
      required this.purchaseDate,
      required this.quantity,
      required this.price});
}

ForNewSaleBookItem emptyForNewSaleBookItem() => ForNewSaleBookItem(
    bookID: '',
    bookName: '',
    purchases: []);

class ForNewSaleBookItem {
  final String bookID;
  final String bookName;
  final List<ForNewSaleBookPurchaseVariant> purchases;

  Map<String, String> toDropdownData() {
    return {'id': bookID, 'name': bookName};
  }

  ForNewSaleBookItem({
    required this.bookID,
    required this.bookName,
    required this.purchases,
  });
}
