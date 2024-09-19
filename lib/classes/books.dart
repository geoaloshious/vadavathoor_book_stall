class BookListItemModel {
  final String bookID;
  final String bookName;
  final String authorID;
  final String authorName;
  final String publisherID;
  final String publisherName;
  final String categoryID;
  final String categoryName;
  final int balanceStock;

  BookListItemModel(
      {required this.bookID,
      required this.bookName,
      required this.authorID,
      required this.authorName,
      required this.publisherID,
      required this.publisherName,
      required this.categoryID,
      required this.categoryName,
      required this.balanceStock});
}

class StationaryListItemModel {
  final String itemID;
  final String itemName;
  final int balanceStock;

  StationaryListItemModel(
      {required this.itemID,
      required this.itemName,
      required this.balanceStock});
}
