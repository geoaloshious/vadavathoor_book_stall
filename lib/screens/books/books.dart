import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/classes/books.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';
import 'package:vadavathoor_book_stall/screens/books/book_modal.dart';

class BooksWidget extends StatefulWidget {
  const BooksWidget({super.key});

  @override
  State<BooksWidget> createState() => _BooksState();
}

class _BooksState extends State<BooksWidget> {
  List<BookListItemModel> books = [];
  List<BookListItemModel> filteredBooks = [];

  int currentPage = 0;
  final int itemsPerPage = 50;
  String searchQuery = '';
  int sortColumnIndex = 0;
  Map<int, bool> sortOrder = {
    0: true,
    1: true,
    2: true,
    3: true,
    4: true,
  };

  void onPressAddOrEdit({BookListItemModel? data}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Size screenSize = MediaQuery.of(context).size;

          return Dialog(
              child: Container(
                  constraints: BoxConstraints(maxWidth: screenSize.width * 0.6),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                          child: BookModalWidget(
                              data: data, updateUI: setData)))));
        });
  }

  onPressDelete(String selectedID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      deleteBook(selectedID).then((res) {
                        Navigator.of(context).pop();

                        if (res['message'] == null) {
                          setData();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text(res['message']!),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'))
                                    ]);
                              });
                        }
                      });
                    },
                    child: const Text('Delete'))
              ]);
        });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredBooks = books.where((book) {
        return book.bookName.toLowerCase().contains(query.toLowerCase()) ||
            book.authorName.toLowerCase().contains(query.toLowerCase()) ||
            book.publisherName.toLowerCase().contains(query.toLowerCase()) ||
            book.categoryName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      currentPage = 0;
    });
  }

  void sortBooks(int columnName) {
    setState(() {
      sortOrder[columnName] = !sortOrder[columnName]!;
      bool ascending = sortOrder[columnName]!;

      switch (columnName) {
        case 0:
          filteredBooks.sort((a, b) => ascending
              ? a.bookName.compareTo(b.bookName)
              : b.bookName.compareTo(a.bookName));
          break;
        case 1:
          filteredBooks.sort((a, b) => ascending
              ? a.authorName.compareTo(b.authorName)
              : b.authorName.compareTo(a.authorName));
          break;
        case 2:
          filteredBooks.sort((a, b) => ascending
              ? a.publisherName.compareTo(b.publisherName)
              : b.publisherName.compareTo(a.publisherName));
          break;
        case 3:
          filteredBooks.sort((a, b) => ascending
              ? a.categoryName.compareTo(b.categoryName)
              : b.categoryName.compareTo(a.categoryName));
          break;
        case 4:
          filteredBooks.sort((a, b) => ascending
              ? a.balanceStock.compareTo(b.balanceStock)
              : b.balanceStock.compareTo(a.balanceStock));
          break;
      }

      sortColumnIndex = columnName;
    });
  }

  void setData() async {
    final temp = await getBookList();
    setState(() {
      books = temp;
      filteredBooks = books;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (cntx, user, _) {
      final loggedIn = user.user.userID != '';

      final totalPages = (filteredBooks.length / itemsPerPage).ceil();
      final startIndex = currentPage * itemsPerPage;
      final endIndex = startIndex + itemsPerPage < filteredBooks.length
          ? startIndex + itemsPerPage
          : filteredBooks.length;

      return Stack(children: [
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          width: 300,
                          child: TextField(
                              onChanged: updateSearchQuery,
                              decoration: const InputDecoration(
                                  labelText: 'Search',
                                  border: OutlineInputBorder()))),
                      Row(children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: currentPage > 0
                              ? () {
                                  setState(() {
                                    currentPage--;
                                  });
                                }
                              : null,
                        ),
                        Text('Page ${currentPage + 1} of ${totalPages}',
                            style: const TextStyle(fontSize: 14)),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: currentPage < totalPages - 1
                              ? () {
                                  setState(() {
                                    currentPage++;
                                  });
                                }
                              : null,
                        ),
                      ]),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                        sortColumnIndex: sortColumnIndex,
                        sortAscending: sortOrder[sortColumnIndex]!,
                        columns: [
                          DataColumn(
                            label: const Text('Book'),
                            onSort: (columnIndex, _) => sortBooks(0),
                          ),
                          DataColumn(
                            label: const Text('Author'),
                            onSort: (columnIndex, _) => sortBooks(1),
                          ),
                          DataColumn(
                            label: const Text('Publisher'),
                            onSort: (columnIndex, _) => sortBooks(2),
                          ),
                          DataColumn(
                            label: const Text('Category'),
                            onSort: (columnIndex, _) => sortBooks(3),
                          ),
                          DataColumn(
                            label: const Text('Balance Stock'),
                            onSort: (columnIndex, _) => sortBooks(4),
                          ),
                          if (loggedIn) const DataColumn(label: Text(''))
                        ],
                        rows: filteredBooks
                            .sublist(startIndex, endIndex)
                            .map((book) => DataRow(cells: [
                                  DataCell(Text(book.bookName)),
                                  DataCell(Text(book.authorName)),
                                  DataCell(Text(book.publisherName)),
                                  DataCell(Text(book.categoryName)),
                                  DataCell(Text(book.balanceStock.toString())),
                                  if (loggedIn)
                                    DataCell(Row(children: [
                                      IconButton(
                                          icon: const Icon(Icons.edit),
                                          tooltip: 'Edit',
                                          onPressed: () {
                                            onPressAddOrEdit(data: book);
                                          }),
                                      IconButton(
                                          icon: const Icon(Icons.delete),
                                          tooltip: 'Delete',
                                          onPressed: () {
                                            onPressDelete(book.bookID);
                                          })
                                    ]))
                                ]))
                            .toList()),
                  ),
                ],
              )),
        ),
        if (loggedIn)
          Positioned(
              bottom: 30,
              right: 20,
              child: FloatingActionButton.extended(
                  onPressed: () {
                    onPressAddOrEdit();
                  },
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  label: const Text('Add book',
                      style: TextStyle(color: Colors.white))))
      ]);
    });
  }
}
