import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/components/drop_down.dart';
import 'package:vadavathoor_book_stall/screens/sales/purchase_variant.dart';

class NewBookSaleItemWidget extends StatefulWidget {
  final List<ForNewSaleBookItem> books;
  final List<String> selectedBookIDs;
  final VoidCallback onClickDelete;
  final void Function(
      {String? bkId,
      String? prchID,
      bool? selected,
      double? prc,
      double? dsPr,
      int? qty}) updateData;

  const NewBookSaleItemWidget(
      {super.key,
      required this.books,
      required this.selectedBookIDs,
      required this.onClickDelete,
      required this.updateData});

  @override
  State<NewBookSaleItemWidget> createState() => _NewBookSaleItemState();
}

class _NewBookSaleItemState extends State<NewBookSaleItemWidget> {
  ForNewSaleBookItem selectedBook = emptyForNewSaleBookItem();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child: CustomDropdown(
                      items:
                          widget.books.map((i) => i.toDropdownData()).toList(),
                      selectedValue: selectedBook.bookID,
                      label: 'Select Book',
                      hasError: false,
                      excludeIDs: widget.selectedBookIDs,
                      onValueChanged: (value) {
                        setState(() {
                          if (value != selectedBook.bookID) {
                            selectedBook = widget.books
                                .firstWhere((i) => i.bookID == value,
                                    orElse: emptyForNewSaleBookItem)
                                .clone();

                            widget.updateData(bkId: selectedBook.bookID);
                          }
                        });
                      },
                    )),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  onPressed: widget.onClickDelete,
                ),
              ],
            ),
            Column(
              children: List.generate(selectedBook.purchases.length, (index) {
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
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
