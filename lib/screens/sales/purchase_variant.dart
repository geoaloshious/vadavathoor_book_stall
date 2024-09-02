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
  TextEditingController _sellingPriceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
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

  void calculateDiscount(double sellingPrice) {
    double prtg = 100 - ((sellingPrice / widget.data.originalPrice) * 100);
    setState(() {
      _discountController = TextEditingController(text: prtg.toString());
    });
  }

 void calculateSellingPrice(String percentage) {
  double discountPercentage = double.tryParse(percentage) ?? 0;
  double originalPrice = widget.data.originalPrice;
  
  double sellingPrice = originalPrice - (originalPrice * discountPercentage / 100);
  
  sellingPrice = double.parse(sellingPrice.toStringAsFixed(2));

  setState(() {
    _sellingPriceController = TextEditingController(text: sellingPrice.toString());
  });

  widget.updateData(dsPr: sellingPrice);
}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!didSetData && widget.data.quantitySold > 0) {
      setState(() {
        _sellingPriceController =
            TextEditingController(text: widget.data.soldPrice.toString());
        _quantityController =
            TextEditingController(text: widget.data.quantitySold.toString());

        didSetData = true;
      });

      calculateDiscount(widget.data.soldPrice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Expanded(
              flex: 3,
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
                      _sellingPriceController.clear();
                      widget.updateData(selected: value == true);
                    });
                  })),
          const SizedBox(width: 20),
          Row(children: [
            Text('Rate : ${widget.data.originalPrice}'),
            const SizedBox(width: 10),
            SizedBox(
                width: 100,
                child: TextField(
                    enabled: widget.data.selected,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'Discount %'),
                    controller: _discountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final number = double.tryParse(newValue.text) ?? 0;
                        if (number > 100) {
                          return oldValue;
                        }
                        return newValue;
                      })
                    ],
                    onChanged: calculateSellingPrice)),
            const SizedBox(width: 10),
            SizedBox(
                width: 130,
                child: TextField(
                    enabled: widget.data.selected,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'Amount'),
                    controller: _sellingPriceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final number = double.tryParse(newValue.text) ?? 0;
                        if (number > widget.data.originalPrice) {
                          return oldValue;
                        }
                        return newValue;
                      })
                    ],
                    onChanged: (value) {
                      calculateDiscount(double.tryParse(value) ?? 0);
                      widget.updateData(dsPr: double.tryParse(value) ?? 0);
                    }))
          ]),
          const SizedBox(width: 20),
          Expanded(
              flex: 2,
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
                                    FilteringTextInputFormatter.digitsOnly,
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      final number =
                                          int.tryParse(newValue.text) ?? 0;
                                      if (number > widget.data.balanceStock) {
                                        return oldValue;
                                      }
                                      return newValue;
                                    })
                                  ],
                                  onChanged: (value) {
                                    widget.updateData(
                                        qty: int.tryParse(value) ?? 0);
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
