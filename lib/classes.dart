class PurchaseListItemModel {
  final String purchaseID;
  final String itemID;
  final String itemName;
  final int purchaseDate;
  final String formattedPurchaseDate;
  final double price;
  final int quantityPurchased;
  final int balanceStock;

  PurchaseListItemModel(
      {required this.purchaseID,
      required this.itemID,
      required this.itemName,
      required this.purchaseDate,
      required this.formattedPurchaseDate,
      required this.quantityPurchased,
      required this.price,
      required this.balanceStock});
}

class SaleListItemModel {
  final String saleID;
  final String billNo;
  final String customerName;
  final String books;
  final String stationaryItems;
  final String createdDate;
  final String modifiedDate;
  final double grandTotal;
  final String paymentMode;

  SaleListItemModel(
      {required this.saleID,
      required this.billNo,
      required this.customerName,
      required this.books,
      required this.stationaryItems,
      required this.createdDate,
      required this.modifiedDate,
      required this.grandTotal,
      required this.paymentMode});
}
