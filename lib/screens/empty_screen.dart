import 'package:flutter/material.dart';

class EmptyScreenWidget extends StatelessWidget {
  const EmptyScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        Icons.book,
        size: 100,
        color: Colors.grey,
      )
    ]);
  }
}
