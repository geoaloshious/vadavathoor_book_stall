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
  final TextEditingController _quantityController =
      TextEditingController(text: '0');
  ForNewSaleBookItem selectedBook = emptyForNewSaleBookItem();
  String discountPrice = '';

  void incrementQuantity() {
    if (widget.data.selected) {
      int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

      if (quantity < widget.data.inStockCount) {
        quantity++;
        _quantityController.text = quantity.toString();
        widget.updateData(qty: quantity);
      }
    }
  }

  void decrementQuantity() {
    if (widget.data.selected) {
      int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

      if (quantity > 0) {
        quantity--;
        _quantityController.text = quantity.toString();
        widget.updateData(qty: quantity);
      }
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
                      _quantityController.text = '0';
                      _discountPriceController.clear();
                      widget.updateData(selected: value == true);
                    });
                  },
                )),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
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
                            onPressed: decrementQuantity,
                            color: Colors.blue,
                          ),
                          Expanded(
                              child: Center(
                                  child: Row(children: [
                            Expanded(
                                child: TextField(
                                    controller: _quantityController,
                                    enabled: widget.data.selected,
                                    decoration: const InputDecoration(
                                        fillColor: Colors.white),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (value) {
                                      int numVal = int.tryParse(value) ?? 0;
                                      if (numVal > widget.data.inStockCount) {
                                        numVal = widget.data.inStockCount;
                                        _quantityController.text =
                                            numVal.toString();
                                      }
                                      widget.updateData(qty: numVal);
                                    })),
                            Expanded(
                                child: Text('/ ${widget.data.inStockCount}')),
                          ]))),
                          IconButton(
                              icon: const Icon(Icons.add),
                              iconSize: 14,
                              onPressed: incrementQuantity,
                              color: Colors.blue),
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
