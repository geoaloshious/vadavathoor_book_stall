import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/components/drop_down.dart';
import 'package:vadavathoor_book_stall/db/models/book_sale.dart';
import 'package:vadavathoor_book_stall/screens/sales/purchase_variant.dart';

class NewBookSaleItemWidget extends StatefulWidget {
  final List<ForNewSaleBookItem> books;
  final SaleItemBookModel bookDataToSave;
  final List<String> selectedBookIDs;
  final VoidCallback onClickDelete;
  final void Function(
      {String? bkId,
      String? prchID,
      String? add,
      String? remove,
      String? prc,
      String? dsPr,
      int? qty}) updateData;

  const NewBookSaleItemWidget(
      {super.key,
      required this.books,
      required this.bookDataToSave,
      required this.selectedBookIDs,
      required this.onClickDelete,
      required this.updateData});

  @override
  State<NewBookSaleItemWidget> createState() => _NewBookSaleItemState();
}

class _NewBookSaleItemState extends State<NewBookSaleItemWidget> {
  final TextEditingController _discountPriceController =
      TextEditingController();
  ForNewSaleBookItem selectedBook = emptyForNewSaleBookItem();
  int _quantity = 0;
  int inStockCount = 0;
  double originalPrice = 0;
  String discountPrice = '';

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
                      onValueChanged: (value) {
                        setState(() {
                          if (value != selectedBook.bookID) {
                            selectedBook = widget.books.firstWhere(
                                (i) => i.bookID == value,
                                orElse: emptyForNewSaleBookItem);

                            _quantity =
                                selectedBook.purchases.isNotEmpty ? 1 : 0;

                            _discountPriceController.clear();

                            widget.updateData(
                                bkId: selectedBook.bookID, qty: _quantity);
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
                  data: widget.books,
                  selected: widget.bookDataToSave.purchaseVariants
                      .where((pv) =>
                          pv.purchaseID ==
                          selectedBook.purchases[index].purchaseID)
                      .isNotEmpty,
                  updateData: ({String? dsPr, int? qty}) {
                    widget.updateData(
                        prchID: selectedBook.purchases[index].purchaseID,
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
