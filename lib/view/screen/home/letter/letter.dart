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
        children: <Widget>[
          ListBody(
            children: [
              ListTile(
                iconColor: CustomColor.primary,
                textColor: CustomColor.primary,
                leading: Icon(Icons.inbox),
                title: Text(
                  '나에게 받은 편지함',
                  style: CustomTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text('안녕 나야'),
                subtitle: Text('미래의 나야, 잘지냈니? ...'),
                onTap: () {},
              ),
            ],
          ),
          Divider(),
          ListBody(
            children: [
              ListTile(
                iconColor: CustomColor.primary,
                textColor: CustomColor.primary,
                leading: Icon(Icons.move_to_inbox_rounded),
                title: Text(
                  '한달 후 보낼 편지함',
                  style: CustomTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text('3통이 준비되었습니다.'),
                subtitle: Text('기다리면 곧 만날거에요.'),
              ),
            ],
          ),
        ],
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
