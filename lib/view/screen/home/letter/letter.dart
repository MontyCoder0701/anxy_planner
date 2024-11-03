import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/entity/letter.dart';
import '../../../../view_model/letter.dart';
import '../../../theme.dart';

class LetterScreen extends StatefulWidget {
  const LetterScreen({super.key});

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen> {
  late final letterProvider = context.watch<LetterProvider>();

  List<LetterEntity> get receivedLetters => letterProvider.receivedLetters;

  int get sendLettersCount => letterProvider.sendLettersCount;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      letterProvider.getMany();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Column(
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
                subtitle:
                    Text(receivedLetters.isEmpty ? '받은 편지가 아직 없습니다.' : ''),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: receivedLetters.length,
                itemBuilder: (context, index) {
                  final item = receivedLetters[index];
                  return ListTile(
                    title: Text(item.subject),
                    subtitle: Text(
                      item.subject,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {},
                  );
                },
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
                subtitle: Text(receivedLetters.isEmpty ? '첫 편지를 보내보세요.' : ''),
              ),
              if (sendLettersCount > 0) ...{
                ListTile(
                  title: Text('$sendLettersCount통이 준비되었습니다.'),
                ),
              },
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
