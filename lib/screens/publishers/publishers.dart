import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/db/models/book_publisher.dart';
import 'package:vadavathoor_book_stall/screens/publishers/edit_publisher.dart';

class Publishers extends StatefulWidget {
  const Publishers({super.key});

  @override
  State<Publishers> createState() => _PublishersState();
}

class _PublishersState extends State<Publishers> {
  final _nameController = TextEditingController();
  List<PublisherModel> publishers = [];

  void add() async {
    final name = _nameController.text.trim();
    if (name != '') {
      await addPublisher(name);
      _nameController.clear();
      setData();
    }
  }

  onPressEdit(PublisherModel selectedPublisher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;

        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              minHeight: screenSize.height * 0.2,
              maxWidth: screenSize.width * 0.4,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: EditPublisherWidget(
                    data: selectedPublisher,
                    updateUI: () {
                      setData();
                      Navigator.of(context).pop();
                    }),
              ),
            ),
          ),
        );
      },
    );
  }

  onPressDelete(String selectedPublisherID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content:
              const Text('Are you sure you want to delete this publisher?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await editPublisher(
                    publisherID: selectedPublisherID,
                    status: DBRowStatus.deleted);
                setData();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void setData() async {
    final temp = await getPublishers();
    setState(() {
      publishers = temp;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(children: [
            Expanded(
                child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Publisher Name'),
                    controller: _nameController)),
            const SizedBox(width: 20),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                onPressed: add,
                child: const Text('Add', style: TextStyle(color: Colors.white)))
          ]),
          const SizedBox(height: 20),
          const Row(children: [
            Text('Publishers',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
          ]),
          const SizedBox(height: 20),
          const Row(
            children: [
              Text('Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(width: 80)
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.2, color: Colors.blueGrey)))),
          Expanded(
              child: publishers.isNotEmpty
                  ? ListView.builder(
                      itemCount: publishers.length,
                      itemBuilder: (context, index) => Row(children: [
                            Expanded(
                                child: Text(publishers[index].publisherName)),
                            IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit',
                                onPressed: () {
                                  onPressEdit(publishers[index]);
                                }),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete',
                                onPressed: () {
                                  onPressDelete(publishers[index].publisherID);
                                })
                          ]))
                  : const Text("No records found"))
        ]));
  }
}
