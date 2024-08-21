import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/classes/books.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
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
                await deleteBook(selectedID);
                setData();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
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

      return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text(
                'Books',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (loggedIn)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      onPressAddOrEdit();
                    },
                    child: const Text('Add book',
                        style: TextStyle(color: Colors.white)))
            ]),
            const SizedBox(height: 20),
            Row(children: [
              const Expanded(
                  child: Text('Book',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Author',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Publisher',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Category',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Balance Stock',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              if (loggedIn) const SizedBox(width: 80)
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.2, color: Colors.blueGrey)))),
            Expanded(
                child: books.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (ctx2, index) => Row(children: [
                              Expanded(child: Text(books[index].bookName)),
                              Expanded(child: Text(books[index].authorName)),
                              Expanded(child: Text(books[index].publisherName)),
                              Expanded(child: Text(books[index].categoryName)),
                              Expanded(
                                  child: Text(
                                      books[index].balanceStock.toString())),
                              if (loggedIn)
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Edit',
                                    onPressed: () {
                                      onPressAddOrEdit(data: books[index]);
                                    }),
                              if (loggedIn)
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Delete',
                                    onPressed: () {
                                      onPressDelete(books[index].bookID);
                                    })
                            ]),
                        itemCount: books.length)
                    : const Text("No records found"))
          ]));
    });
  }
}
