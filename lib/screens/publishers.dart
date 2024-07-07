import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';

class Publishers extends StatefulWidget {
  const Publishers({super.key});

  @override
  State<Publishers> createState() => _PublishersState();
}

class _PublishersState extends State<Publishers> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  void add() {
    if (_nameController.text != '') {
      addPublisher(_nameController.text, _addressController.text);

      _nameController.clear();
      _addressController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    updatePublishersList();

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Name'),
                      controller: _nameController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Address'),
                      controller: _addressController,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: add, child: const Text('Submit')),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: publishersNotifier,
                    builder: (ctx, publishers, child) {
                      return ListView.builder(
                          itemBuilder: (ctx2, index) {
                            return Row(
                              children: [
                                Text(
                                    'Name: ${publishers[index].publisherName}, Address: ${publishers[index].publisherAddress}'),
                              ],
                            );
                          },
                          itemCount: publishers.length);
                    }),
              )
            ],
          )),
    );
  }
}
