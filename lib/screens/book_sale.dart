import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/functions/book_sale.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';

class BookSale extends StatefulWidget {
  const BookSale({super.key});

  @override
  State<BookSale> createState() => _BookSaleState();
}

class _BookSaleState extends State<BookSale> {
  final _bookNameController = TextEditingController();
  final _bookpriceController = TextEditingController();
  final _personNameController = TextEditingController();
  final _personBatchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    updateBookSaleList();

    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Book name',
                          ),
                          controller: _bookNameController),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Book price'),
                        controller: _bookpriceController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Person name'),
                        controller: _personNameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Person batch'),
                        controller: _personBatchController,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      // addBookPurchase(PurchaseModel(
                      //     bookName: _bookNameController.text,
                      //     bookPrice: _bookpriceController.text,
                      //     personName: _personNameController.text,
                      //     personBatch: _personBatchController.text));
                    },
                    child: const Text('Submit')),
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: purchaseNotifier,
                      builder: (ctx, purchases, child) {
                        return ListView.builder(
                            itemBuilder: (ctx2, index) {
                              // return Row(
                              //   children: [
                              //     Text(
                              //         'Book Name: ${purchases[index].bookID}, Book price: ${purchases[index].bookPrice}'),
                              //     IconButton(
                              //         onPressed: () {
                              //           print(jsonEncode(purchases[index]));
                              //           if (purchases[index].id != null) {
                              //             deleteBookPurchase(
                              //                 purchases[index].id!);
                              //           }
                              //         },
                              //         icon: Icon(Icons.delete))
                              //   ],
                              // );
                            },
                            itemCount: purchases.length);
                      }),
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
