import 'package:flutter/material.dart';

class EditModalWidget extends StatefulWidget {
  final String name;
  final String title;
  final void Function(String name) saveData;

  const EditModalWidget(
      {super.key,
      required this.name,
      required this.title,
      required this.saveData});

  @override
  State<EditModalWidget> createState() => _EditModalState();
}

class _EditModalState extends State<EditModalWidget> {
  TextEditingController _nameController = TextEditingController();

  Map<String, bool> inputErrors = {};

  void _saveData() async {
    final name = _nameController.text.trim();

    Map<String, bool> tempInputErrors = {};

    if (name.isEmpty) {
      tempInputErrors['name'] = true;
    }

    if (tempInputErrors.isEmpty) {
      widget.saveData(name);
    } else {
      setState(() {
        inputErrors = tempInputErrors;
      });
    }
  }

  void setData() {
    _nameController = TextEditingController(text: widget.name);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Edit ${widget.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Close',
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '${widget.title} Name',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: inputErrors['name'] == true
                          ? const BorderSide(color: Colors.red, width: 1)
                          : const BorderSide(color: Colors.grey, width: 1)),
                ),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'name': false};
                  });
                },
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _saveData, child: const Text('Submit')),
      ],
    );
  }
}
