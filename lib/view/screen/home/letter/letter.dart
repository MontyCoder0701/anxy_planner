import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../model/entity/letter.dart';
import '../../../../view_model/letter.dart';
import '../../../theme.dart';
import '../../../widget/dismissible_wrapper.dart';

class LetterScreen extends StatefulWidget {
  const LetterScreen({super.key});

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen> {
  late final letterProvider = context.watch<LetterProvider>();
  late final scaffoldMessenger = ScaffoldMessenger.of(context);
  late final tr = AppLocalizations.of(context);

  final _formKey = GlobalKey<FormState>();

  List<LetterEntity> get receivedLetters => letterProvider.receivedLetters;

  int get sendLettersCount => letterProvider.sendLettersCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                ListTile(
                  iconColor: CustomColor.primary,
                  textColor: CustomColor.primary,
                  leading: Icon(Icons.markunread_mailbox),
                  title: Text(
                    tr.sendLetterboxTitle,
                    style: CustomTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: sendLettersCount == 0
                      ? Text(tr.sendLetterboxSubtitle)
                      : null,
                ),
                if (sendLettersCount > 0) ...{
                  ListTile(
                    title: Text('$sendLettersCount ${tr.preparedLettersCount}'),
                    subtitle: Text(tr.awaitingLettersMessage),
                  ),
                },
                Divider(),
                ListTile(
                  iconColor: CustomColor.primary,
                  textColor: CustomColor.primary,
                  leading: Icon(Icons.inbox),
                  title: Text(
                    tr.receivedLetterboxTitle,
                    style: CustomTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: receivedLetters.isEmpty
                      ? Text(tr.noReceivedLetters)
                      : null,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: receivedLetters.length,
                  itemBuilder: (context, index) {
                    final item = receivedLetters[index];

                    return DismissibleWrapperWidget(
                      objectKey: Key(item.id.toString()),
                      onDismissed: () => letterProvider.deleteOne(item),
                      child: ListTile(
                        textColor: item.isOpened ? Colors.grey : null,
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
                          if (!item.isOpened) {
                            letterProvider.updateOne(item..isOpened = true);
                          }

                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(item.subject),
                                content: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    initialValue: item.content,
                                    maxLines: 15,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                actions: [
                                  Text(tr.fromLastMonth),
                                  const Icon(Icons.hourglass_bottom),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
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
                    title: Text(tr.writeToMyself),
                    content: Form(
                      key: _formKey,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              onChanged: (val) => newLetter.subject = val,
                              decoration: InputDecoration(
                                hintText: '${tr.subjectRequired}..',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr.subjectRequired;
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              maxLines: 10,
                              maxLength: 500,
                              onChanged: (val) => newLetter.content = val,
                              decoration: InputDecoration(
                                hintText: '${tr.contentRequired}..',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr.contentRequired;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Text(tr.fromCurrentSelf),
                      IconButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pop(context);
                            letterProvider.createOne(newLetter);

                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(tr.letterSent),
                              ),
                            );
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
        child: const Icon(Icons.edit, size: 30),
      ),
    );
  }
}
