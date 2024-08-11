class ForNewSaleBookPurchaseVariant {
  final String purchaseID;
  final String purchaseDate;
  final int inStockCount;
  final double originalPrice;
  bool selected;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'purchaseDate': purchaseDate,
      'inStockCount': inStockCount,
      'originalPrice': originalPrice,
      'selected': selected
    };
  }

  ForNewSaleBookPurchaseVariant clone() {
    return ForNewSaleBookPurchaseVariant(
        purchaseID: purchaseID,
        purchaseDate: purchaseDate,
        inStockCount: inStockCount,
        originalPrice: originalPrice,
        selected: selected);
  }

  ForNewSaleBookPurchaseVariant(
      {required this.purchaseID,
      required this.purchaseDate,
      required this.inStockCount,
      required this.originalPrice,
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

  Map<String, dynamic> toJson() {
    return {
      'bookID': bookID,
      'bookName': bookName,
      'purchases': purchases.map((p) => p.toJson()),
    };
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
