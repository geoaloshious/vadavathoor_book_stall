import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/components/drop_down.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/sales.dart';
import 'package:vadavathoor_book_stall/screens/sales/purchase_variant.dart';

class SaleItemBookWidget extends StatefulWidget {
  final Map<String, Map<String, Map<String, Object>>> allBooksWithPurchases;
  final List<BookModel> allBooks;
  final SaleItemModel savedData;
  final List<String> selectedBookIDs;
  final VoidCallback onClickDelete;
  final void Function(
      {String? bkId,
      String? prchID,
      bool? selected,
      double? prc,
      double? dsPr,
      int? qty}) updateData;

  const SaleItemBookWidget(
      {super.key,
      required this.allBooksWithPurchases,
      required this.allBooks,
      required this.savedData,
      required this.selectedBookIDs,
      required this.onClickDelete,
      required this.updateData});

  @override
  State<SaleItemBookWidget> createState() => _SaleItemBookState();
}

class _SaleItemBookState extends State<SaleItemBookWidget> {
  ForNewSaleBookItem selectedBook = emptyForNewSaleBookItem();
  bool didSetData = false;

  void onChangeBook(String bookID) {
    final tempPurchases =
        widget.allBooksWithPurchases[bookID]?.keys.map((purchaseID) {
      final p = widget.allBooksWithPurchases[bookID]?[purchaseID];

      return ForNewSaleBookPurchaseVariant(
          purchaseID: purchaseID,
          purchaseDate: p?['date'] as String,
          balanceStock: p?['balanceStock'] as int,
          originalPrice: p?['price'] as double,
          soldPrice: 0,
          quantitySold: 0,
          selected: false);
    }).toList();

    setState(() {
      selectedBook.bookID = bookID;
      if (tempPurchases != null) {
        selectedBook.purchases = tempPurchases;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!didSetData &&
        widget.savedData.itemID != '' &&
        widget.allBooksWithPurchases.keys.isNotEmpty) {
      final List<ForNewSaleBookPurchaseVariant> tempPurchases = [];

      final bookPurchases =
          widget.allBooksWithPurchases[widget.savedData.itemID];

      if (bookPurchases != null) {
        for (String purchaseID in bookPurchases.keys) {
          final p = bookPurchases[purchaseID];
          if (p != null) {
            final savedPV = widget.savedData.purchaseVariants
                .where((i) => i.purchaseID == purchaseID)
                .firstOrNull;

            tempPurchases.add(ForNewSaleBookPurchaseVariant(
                purchaseID: purchaseID,
                purchaseDate: p['date'] as String,
                balanceStock:
                    (p['balanceStock'] as int) + (savedPV?.quantity ?? 0),
                originalPrice: p['price'] as double,
                soldPrice: savedPV?.soldPrice ?? 0,
                quantitySold: savedPV?.quantity ?? 0,
                selected: savedPV != null));
          }
        }
      }

      setState(() {
        selectedBook.bookID = widget.savedData.itemID;
        selectedBook.purchases = tempPurchases;

        didSetData = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(children: [
                Expanded(
                    flex: 5,
                    child: CustomDropdown(
                        items: widget.allBooks
                            .map((i) => i.toDropdownData())
                            .toList(),
                        selectedValue: selectedBook.bookID,
                        label: 'Select Book',
                        hasError: false,
                        excludeIDs: widget.selectedBookIDs,
                        onValueChanged: (value) {
                          setState(() {
                            if (value != selectedBook.bookID) {
                              onChangeBook(value);
                              widget.updateData(bkId: selectedBook.bookID);
                            }
                          });
                        })),
                const SizedBox(width: 8),
                IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: widget.onClickDelete)
              ]),
              if (selectedBook.purchases.isNotEmpty) const SizedBox(height: 10),
              Column(
                  children:
                      List.generate(selectedBook.purchases.length, (index) {
                return PurchaseVariantWidget(
                    key: Key(index.toString()),
                    data: selectedBook.purchases[index],
                    updateData: ({bool? selected, double? dsPr, int? qty}) {
                      if (selected != null) {
                        setState(() {
                          selectedBook.purchases[index].selected = selected;
                        });
                      }

                      widget.updateData(
                          prchID: selectedBook.purchases[index].purchaseID,
                          selected: selected,
                          prc: selected == true
                              ? selectedBook.purchases[index].originalPrice
                              : null,
                          dsPr: dsPr,
                          qty: qty);
                    });
              }))
            ])));
  }
}
