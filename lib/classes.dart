class BookPurchaseListItemModel {
  final String purchaseID;
  final String bookID;
  final String bookName;
  final int purchaseDate;
  final String formattedPurchaseDate;

  final double bookPrice;
  final int quantityPurchased;
  final int balanceStock;

  BookPurchaseListItemModel(
      {required this.purchaseID,
      required this.bookID,
      required this.bookName,
      required this.purchaseDate,
      required this.formattedPurchaseDate,
      required this.quantityPurchased,
      required this.bookPrice,
      required this.balanceStock});
}

class SaleListItemModel {
  final String saleID;
  final String customerName;
  final String books;
  final String createdDate;
  final String modifiedDate;
  final double grandTotal;
  final String paymentMode;

  SaleListItemModel(
      {required this.saleID,
      required this.customerName,
      required this.books,
      required this.createdDate,
      required this.modifiedDate,
      required this.grandTotal,
      required this.paymentMode});
}
