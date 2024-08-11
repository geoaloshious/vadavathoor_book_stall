import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';

class PurchaseVariantWidget extends StatefulWidget {
  final ForNewSaleBookPurchaseVariant data;
  final void Function({bool? selected, double? dsPr, int? qty}) updateData;

  const PurchaseVariantWidget(
      {super.key, required this.data, required this.updateData});

  @override
  State<PurchaseVariantWidget> createState() => _PurchaseVariantState();
}

class _PurchaseVariantState extends State<PurchaseVariantWidget> {
  final TextEditingController _discountPriceController =
      TextEditingController();
  ForNewSaleBookItem selectedBook = emptyForNewSaleBookItem();
  int _quantity = 0;
  String discountPrice = '';

  void incrementQuantity() {
    if (_quantity < widget.data.inStockCount) {
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
                child: CheckboxListTile(
                  title: Text(widget.data.purchaseDate),
                  value: widget.data.selected,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      _quantity = 0;
                      _discountPriceController.clear();
                      widget.updateData(selected: value == true);
                    });
                  },
                )),
            const SizedBox(width: 20),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Text('Price : ${widget.data.originalPrice}'),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                    enabled: widget.data.selected,
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
                      widget.updateData(dsPr: double.tryParse(value) ?? 0);
                    },
                  ))
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
                flex: 3,
                child: AbsorbPointer(
                    absorbing: !widget.data.selected,
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
                                '$_quantity / ${widget.data.inStockCount}',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            iconSize: 14,
                            onPressed: _quantity < widget.data.inStockCount
                                ? incrementQuantity
                                : null,
                            color: _quantity < widget.data.inStockCount
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
