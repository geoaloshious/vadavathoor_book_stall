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
  TextEditingController _discountPriceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController(text: '0');
  bool didSetData = false;

  void incrementQuantity() {
    if (widget.data.selected) {
      int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

      if (quantity < widget.data.balanceStock) {
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!didSetData) {
      _discountPriceController =
          TextEditingController(text: widget.data.soldPrice.toString());
      _quantityController =
          TextEditingController(text: widget.data.quantitySold.toString());

      setState(() {
        didSetData = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: CheckboxListTile(
                title: Text(
                  widget.data.purchaseDate,
                  style: const TextStyle(fontSize: 14),
                ),
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
                      hintStyle: TextStyle(fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
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
                      color: Colors.white,
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
                                    if (numVal > widget.data.balanceStock) {
                                      numVal = widget.data.balanceStock;
                                      _quantityController.text =
                                          numVal.toString();
                                    }
                                    widget.updateData(qty: numVal);
                                  })),
                          Expanded(
                              child: Text('/ ${widget.data.balanceStock}')),
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
    );
  }
}
