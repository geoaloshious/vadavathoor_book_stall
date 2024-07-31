class BookPurchaseListItemModel {
  final String purchaseID;
  final String publisherID;
  final String publisherName;
  final String purchaseDate;
  final String bookID;
  final String bookName;
  final String bookPrice;
  final String quantity;
  final String createdDate;
  final String modifiedDate;

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
      'modifiedDate': modifiedDate
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
    required this.modifiedDate,
  });
}
