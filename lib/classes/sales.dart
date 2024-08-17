class ForNewSaleBookPurchaseVariant {
  final String purchaseID;
  final String purchaseDate;
  final int balanceStock;
  final double originalPrice;
  final double soldPrice;
  final int quantitySold;
  bool selected;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'purchaseDate': purchaseDate,
      'balanceStock': balanceStock,
      'originalPrice': originalPrice,
      'soldPrice': soldPrice,
      'quantitySold': quantitySold,
      'selected': selected
    };
  }

  ForNewSaleBookPurchaseVariant clone() {
    return ForNewSaleBookPurchaseVariant(
        purchaseID: purchaseID,
        purchaseDate: purchaseDate,
        balanceStock: balanceStock,
        originalPrice: originalPrice,
        soldPrice: soldPrice,
        quantitySold: quantitySold,
        selected: selected);
  }

  ForNewSaleBookPurchaseVariant(
      {required this.purchaseID,
      required this.purchaseDate,
      required this.balanceStock,
      required this.originalPrice,
      required this.soldPrice,
      required this.quantitySold,
      required this.selected});
}

ForNewSaleBookItem emptyForNewSaleBookItem() =>
    ForNewSaleBookItem(bookID: '', bookName: '', purchases: []);

class ForNewSaleBookItem {
  String bookID;
  final String bookName;
  List<ForNewSaleBookPurchaseVariant> purchases;

  Map<String, String> toDropdownData() {
    return {'id': bookID, 'name': bookName};
  }

  ForNewSaleBookItem clone() {
    return ForNewSaleBookItem(
        bookID: bookID,
        bookName: bookName,
        purchases: purchases.map((p) => p.clone()).toList());
  }

  ForNewSaleBookItem({
    required this.bookID,
    required this.bookName,
    required this.purchases,
  });
}
