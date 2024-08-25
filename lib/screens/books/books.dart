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

  void setData() async {
    final temp = await getBookList();
    setState(() {
      books = temp;
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

      return Stack(children: [
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          child: DataTable(
              columns: [
                const DataColumn(label: Text('Book')),
                const DataColumn(label: Text('Author')),
                const DataColumn(label: Text('Publisher')),
                const DataColumn(label: Text('Category')),
                const DataColumn(label: Text('Balance Stock')),
                if (loggedIn) const DataColumn(label: Text(''))
              ],
              rows: books
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
