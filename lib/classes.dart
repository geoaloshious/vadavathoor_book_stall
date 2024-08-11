BookPurchaseListItemModel emptyBookPurchaseListItem() =>
    BookPurchaseListItemModel(
        purchaseID: '',
        publisherID: '',
        publisherName: '',
        purchaseDate: 0,
        formattedPurchaseDate: '',
        bookID: '',
        bookName: '',
        quantityPurchased: 0,
        bookPrice: 0);

class BookPurchaseListItemModel {
  final String purchaseID;
  final String publisherID;
  final String publisherName;
  final int purchaseDate;
  final String formattedPurchaseDate;
  final String bookID;
  final String bookName;
  final double bookPrice;
  final int quantityPurchased;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'publisherID': publisherID,
      'publisherName': publisherName,
      'purchaseDate': purchaseDate,
      'formattedPurchaseDate': formattedPurchaseDate,
      'bookID': bookID,
      'bookName': bookName,
      'quantityPurchased': quantityPurchased,
      'bookPrice': bookPrice,
    };
  }

  BookPurchaseListItemModel({
    required this.purchaseID,
    required this.publisherID,
    required this.publisherName,
    required this.purchaseDate,
    required this.formattedPurchaseDate,
    required this.bookID,
    required this.bookName,
    required this.quantityPurchased,
    required this.bookPrice,
  });
}

class SaleListItemModel {
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

  SaleListItemModel({
    required this.bookName,
    required this.quantity,
    required this.date,
    required this.grandTotal,
  });
}
