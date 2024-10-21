class ForNewSalePurchaseVariant {
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

  ForNewSalePurchaseVariant clone() {
    return ForNewSalePurchaseVariant(
        purchaseID: purchaseID,
        purchaseDate: purchaseDate,
        balanceStock: balanceStock,
        originalPrice: originalPrice,
        soldPrice: soldPrice,
        quantitySold: quantitySold,
        selected: selected);
  }

  ForNewSalePurchaseVariant(
      {required this.purchaseID,
      required this.purchaseDate,
      required this.balanceStock,
      required this.originalPrice,
      required this.soldPrice,
      required this.quantitySold,
      required this.selected});
}

ForNewSaleItem emptyForNewSaleItem() =>
    ForNewSaleItem(itemID: '', itemName: '', purchases: []);

class ForNewSaleItem {
  String itemID;
  final String itemName;
  List<ForNewSalePurchaseVariant> purchases;

  Map<String, String> toDropdownData() {
    return {'id': itemID, 'name': itemName};
  }

  ForNewSaleItem clone() {
    return ForNewSaleItem(
        itemID: itemID,
        itemName: itemName,
        purchases: purchases.map((p) => p.clone()).toList());
  }

  ForNewSaleItem({
    required this.itemID,
    required this.itemName,
    required this.purchases,
  });
}

class UserModelForSales {
  String userID;
  String name;
  String batchID;
  String batchName;

  Map<String, String> toDropdownData() {
    return {'id': userID.toString(), 'name': '$name  (Batch: $batchName)'};
  }

  UserModelForSales(
      {required this.userID,
      required this.name,
      required this.batchID,
      required this.batchName});
}
