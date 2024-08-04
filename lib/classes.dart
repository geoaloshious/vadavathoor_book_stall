class BookPurchaseListItemModel {
  final String purchaseID;
  final String publisherID;
  final String publisherName;
  final String purchaseDate;
  final String bookID;
  final String bookName;
  final String bookPrice;
  final int quantity;
  final String createdDate;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'publisherID': publisherID,
      'publisherName': publisherName,
      'purchaseDate': purchaseDate,
      'bookID': bookID,
      'bookName': bookName,
      'quantity': quantity,
      'bookPrice': bookPrice,
      'createdDate': createdDate,
    };
  }

  BookPurchaseListItemModel({
    required this.purchaseID,
    required this.publisherID,
    required this.publisherName,
    required this.purchaseDate,
    required this.bookID,
    required this.bookName,
    required this.quantity,
    required this.bookPrice,
    required this.createdDate,
  });
}

class BookSaleListItemModel {
  final String bookName;
  final int quantity;
  final String date;
  final double grandTotal;

  Map<String, dynamic> toJson() {
    return {
      'bookName': bookName,
      'quantity': quantity,
      'date': date,
      'grandTotal': grandTotal
    };
  }

  BookSaleListItemModel({
    required this.bookName,
    required this.quantity,
    required this.date,
    required this.grandTotal,
  });
}
