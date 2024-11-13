import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/utils/export_excel.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/purchase_modal.dart';

import '../../classes.dart';

class BookPurchase extends StatefulWidget {
  const BookPurchase({super.key});

  @override
  State<BookPurchase> createState() => _BookPurchaseState();
}

class _BookPurchaseState extends State<BookPurchase> {
  List<PurchaseListItemModel> purchases = [];
  List<PurchaseListItemModel> filtered = [];

  int currentPage = 0;
  final int itemsPerPage = 50;
  String searchQuery = '';
  int sortColumnIndex = 3;
  Map<int, bool> sortOrder = {0: true, 1: true, 2: true, 3: true};

  void onPressAddOrEdit({PurchaseListItemModel? data}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Size screenSize = MediaQuery.of(context).size;

          return Dialog(
              child: Container(
                  constraints: BoxConstraints(maxWidth: screenSize.width * 0.5),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                          //#pending - while scrolling, header and submit should be sticky
                          child: BookPurchaseModalWidget(
                              data: data, updateUI: setData)))));
        });
  }

  void _deletePurchase(String purchaseID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Confirm Delete'),
              content:
                  const Text('Are you sure you want to delete this purchase?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      deleteBookPurchase(purchaseID).then((res) {
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
      filtered = purchases.where((p) {
        return p.itemName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      currentPage = 0;
    });
  }

  void sortBooks({required int columnName, bool? ascending}) {
    setState(() {
      if (ascending == null) {
        sortOrder[columnName] = !sortOrder[columnName]!;
        ascending = sortOrder[columnName];
      } else {
        sortOrder[columnName] = ascending!;
      }

      switch (columnName) {
        case 0:
          filtered.sort((a, b) => ascending!
              ? a.itemName.compareTo(b.itemName)
              : b.itemName.compareTo(a.itemName));
          break;
        case 2:
          filtered.sort((a, b) => ascending!
              ? a.price.compareTo(b.price)
              : b.price.compareTo(a.price));
          break;
        case 3:
          filtered.sort((a, b) => ascending!
              ? a.purchaseDate.compareTo(b.purchaseDate)
              : b.purchaseDate.compareTo(a.purchaseDate));
          break;
      }

      sortColumnIndex = columnName;
    });
  }

  void setData() async {
    final tempData = await getBookPurchaseList();
    setState(() {
      purchases = tempData;
      filtered = tempData;
    });
    sortBooks(columnName: sortColumnIndex, ascending: false);
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

      final totalPages = (filtered.length / itemsPerPage).ceil();
      final startIndex = currentPage * itemsPerPage;
      final endIndex = startIndex + itemsPerPage < filtered.length
          ? startIndex + itemsPerPage
          : filtered.length;

      return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Purchases',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Row(children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey),
                            onPressed: () {
                              exportExcel(
                                  context: context, purchases: purchases);
                            },
                            child: const Text('Export Excel',
                                style: TextStyle(color: Colors.white))),
                        const SizedBox(width: 10),
                        if (loggedIn)
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey),
                              onPressed: () {
                                onPressAddOrEdit();
                              },
                              child: const Text('New purchase',
                                  style: TextStyle(color: Colors.white)))
                      ])
                    ]),
                const SizedBox(height: 10),
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
                      Text('Page ${currentPage + 1} of $totalPages',
                          style: const TextStyle(fontSize: 14)),
                      IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: currentPage < totalPages - 1
                              ? () {
                                  setState(() {
                                    currentPage++;
                                  });
                                }
                              : null),
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
                          onSort: (columnIndex, _) => sortBooks(columnName: 0),
                        ),
                        const DataColumn(
                            label: SizedBox(
                          width: 150,
                          child: Text(
                            'Balance Stock/Purchased Quantity',
                            softWrap: true,
                          ),
                        )),
                        DataColumn(
                          label: const Text('Price'),
                          onSort: (columnIndex, _) => sortBooks(columnName: 2),
                        ),
                        DataColumn(
                          label: const Text('Purchase date'),
                          onSort: (columnIndex, _) => sortBooks(columnName: 3),
                        ),
                        if (loggedIn) const DataColumn(label: Text(''))
                      ],
                      rows: filtered
                          .sublist(startIndex, endIndex)
                          .map((book) => DataRow(cells: [
                                DataCell(Text(book.itemName)),
                                DataCell(Text(
                                    '${book.balanceStock} / ${book.quantityPurchased}')),
                                DataCell(Text(book.price.toString())),
                                DataCell(Text(book.formattedPurchaseDate)),
                                if (loggedIn)
                                  DataCell(Row(children: [
                                    if (loggedIn)
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
                                          _deletePurchase(book.purchaseID);
                                        })
                                  ]))
                              ]))
                          .toList()),
                ),
              ],
            ),
          ));
    });
  }
}
