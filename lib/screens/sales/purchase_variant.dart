import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/components/drop_down.dart';

class PurchaseVariantWidget extends StatefulWidget {
  final void Function({String? dsPr, int? qty}) updateData;

  const PurchaseVariantWidget({super.key, required this.updateData});

  @override
  State<PurchaseVariantWidget> createState() => _PurchaseVariantState();
}

class _PurchaseVariantState extends State<PurchaseVariantWidget> {
  final TextEditingController _discountPriceController =
      TextEditingController();
  ForNewSaleBookItem selectedBook = emptyForNewSaleBookItem();
  int _quantity = 0;
  int inStockCount = 0;
  double originalPrice = 0;
  String discountPrice = '';

  void incrementQuantity() {
    if (_quantity < inStockCount) {
      setState(() {
        _quantity++;
      });

      widget.updateData(qty: _quantity);
    }
  }

  void decrementQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });

      widget.updateData(qty: _quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: CustomDropdown(
                  items: widget.books.map((i) => i.toDropdownData()).toList(),
                  selectedValue: selectedBook.bookID,
                  label: 'Select Book',
                  hasError: false,
                  onValueChanged: (value) {
                    setState(() {
                      if (value != selectedBook.bookID) {
                        selectedBook = widget.books.firstWhere(
                            (i) => i.bookID == value,
                            orElse: emptyForNewSaleBookItem);

                        _quantity = selectedBook.purchases.isNotEmpty ? 1 : 0;

                        _discountPriceController.clear();

                        widget.updateData(
                            bkId: selectedBook.bookID, qty: _quantity);
                      }
                    });
                  },
                )),
            const SizedBox(width: 20),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Text('Price : $originalPrice'),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Discount price'),
                    controller: _discountPriceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    ],
                    onChanged: (value) {
                      widget.updateData(dsPr: value);
                    },
                  ))
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Quantity'),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        iconSize: 14,
                        onPressed: _quantity > 0 ? decrementQuantity : null,
                        color: _quantity > 0 ? Colors.blue : Colors.grey,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '$_quantity / $inStockCount',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        iconSize: 14,
                        onPressed:
                            _quantity < inStockCount ? incrementQuantity : null,
                        color: _quantity < inStockCount
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ],
                  ),
                )),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: widget.onClickDelete,
            ),
          ],
        ),
      ),
    );
  }
}
