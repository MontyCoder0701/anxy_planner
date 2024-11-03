import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late final scaffoldMessenger = ScaffoldMessenger.of(context);

  final _formKey = GlobalKey<FormState>();

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
                    receivedLetters.isEmpty ? Text('받은 편지가 아직 없어요.') : null,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: receivedLetters.length,
                itemBuilder: (context, index) {
                  final item = receivedLetters[index];
                  return ListTile(
                    title: Text(
                      item.subject.replaceAll('\n', ' '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      item.content.replaceAll('\n', ' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      DateFormat('yy-MM-dd').format(item.createdAt),
                    ),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(item.subject),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  initialValue: item.content,
                                  maxLines: 10,
                                  readOnly: true,
                                ),
                              ],
                            ),
                            actions: [
                              IconButton(
                                onPressed: () async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('삭제힐까요?'),
                                        actions: <Widget>[
                                          IconButton(
                                            color: CustomColor.primary,
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();

                                              await letterProvider
                                                  .deleteOne(item);
                                              scaffoldMessenger
                                                  .hideCurrentSnackBar();
                                              scaffoldMessenger.showSnackBar(
                                                const SnackBar(
                                                  content: Text('삭제되었습니다.'),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.check),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          );
                        },
                      );
                    },
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
                subtitle: sendLettersCount == 0 ? Text('첫 편지를 보내보세요.') : null,
              ),
              if (sendLettersCount > 0) ...{
                ListTile(
                  title: Text('$sendLettersCount통이 준비되었습니다.'),
                  subtitle: Text('조금만 기다려요. 곧 만날거에요!'),
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
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              final newLetter = LetterEntity();
              return StatefulBuilder(
                builder: (context, StateSetter setStateDialog) {
                  return AlertDialog(
                    title: const Text('한달 후 나에게.'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            onChanged: (val) => newLetter.subject = val,
                            decoration:
                                const InputDecoration(hintText: '제목 ...'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '제목을 적어주세요';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            maxLines: 10,
                            onChanged: (val) => newLetter.content = val,
                            decoration: const InputDecoration(
                              hintText: '내용을 적어주세요 ...',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '내용을 적어주세요';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pop(context);
                            letterProvider.createOne(newLetter);
                          }
                        },
                        color: CustomColor.primary,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
