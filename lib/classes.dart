class BookPurchaseListItemModel {
  final String purchaseID;
  final String publisherID;
  final String publisherName;
  final String categoryID;
  final String categoryName;
  final int purchaseDate;
  final String formattedPurchaseDate;
  final String bookID;
  final String bookName;
  final double bookPrice;
  final int quantityPurchased;

  BookPurchaseListItemModel({
    required this.purchaseID,
    required this.publisherID,
    required this.publisherName,
    required this.categoryID,
    required this.categoryName,
    required this.purchaseDate,
    required this.formattedPurchaseDate,
    required this.bookID,
    required this.bookName,
    required this.quantityPurchased,
    required this.bookPrice,
  });
}

class SaleListItemModel {
  final String saleID;
  final String bookName;
  final int quantity;
  final String date;
  final double grandTotal;
  final String paymentMode;

  SaleListItemModel(
      {required this.saleID,
      required this.bookName,
      required this.quantity,
      required this.date,
      required this.grandTotal,
      required this.paymentMode});
}
