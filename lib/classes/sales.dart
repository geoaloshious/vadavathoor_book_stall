class ForNewSaleBookPurchaseVariant {
  final String purchaseID;
  final String purchaseDate;
  final int quantity;
  final double originalPrice;
  final double soldPrice;
  final bool selected;

  ForNewSaleBookPurchaseVariant(
      {required this.purchaseID,
      required this.purchaseDate,
      required this.quantity,
      required this.originalPrice,
      required this.soldPrice,
      required this.selected});
}

ForNewSaleBookItem emptyForNewSaleBookItem() =>
    ForNewSaleBookItem(bookID: '', bookName: '', purchases: []);

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
