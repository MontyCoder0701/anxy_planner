import 'package:flutter/material.dart';

import '../../../theme.dart';

class LetterScreen extends StatefulWidget {
  const LetterScreen({super.key});

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: CustomColor.primary.withOpacity(0.7),
        elevation: 0,
        onPressed: () {},
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
