import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../model/repository/local.dart';
import '../../../view_model/setting.dart';
import '../../../view_model/todo.dart';
import '../../theme.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.watch<SettingProvider>();
    final todoProvider = context.read<TodoProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('앱 버전'),
                Text(settingProvider.version),
              ],
            ),
          ),
          ListTile(
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                settingProvider.isLight ? Icons.dark_mode : Icons.light_mode,
                key: ValueKey(settingProvider.isLight),
              ),
            ),
            title: const Text('테마 바꾸기'),
            onTap: () => settingProvider.toggleThemeMode(),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('숨어있는 데이터 정리하기'),
            enabled: todoProvider.isExpiredTodosExists,
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('데이터를 정리할까요?'),
                    content: const Text('숨어있는 데이터를 삭제해 앱이 가벼워질거에요.'),
                    actions: <Widget>[
                      IconButton(
                        color: CustomColor.primary,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await todoProvider.deleteExpiredTodos();

                          if (context.mounted) {
                            Navigator.of(context).pop();
                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(content: Text('데이터가 정리되었습니다.')),
                            );
                          }
                        },
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: const Text('개발자에게 문의하기'),
            onTap: () => settingProvider.sendMailToDeveloper(),
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: const Text('라이센스 보기'),
            onTap: () => showLicensePage(context: context),
          ),
          Divider(),
          ListTile(title: Text('실험실'), subtitle: Text('아직 실험중인 기능이에요.')),
          ListTile(
            leading: Icon(Icons.file_upload_outlined),
            title: const Text('데이터 옮기기'),
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('데이터 옮기기'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('내 데이터를 암호화해서 파일로 드릴게요.'),
                        const Text('원하는 곳에 저장해서 옮겨보아요.'),
                      ],
                    ),
                    actions: <Widget>[
                      IconButton(
                        color: CustomColor.primary,
                        onPressed: () async {
                          final result = await LocalRepository.export();
                          if (!context.mounted) {
                            return;
                          }

                          Navigator.of(context).pop();

                          if (result.status == ShareResultStatus.success) {
                            Navigator.of(context).pop();
                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '데이터를 저장했어요. '
                                  '이 파일로 복구가 가능해요.',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.save_alt),
            title: const Text('예전 데이터 받아오기'),
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('데이터 받아오기'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('옮겼던 데이터를 다시 받아와요.'),
                        const Text('예전에 저장했던 데이터를 다시 사용해요.'),
                        Text(
                          '내 데이터는 덮어씌워져요.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColor.warning,
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      IconButton(
                        color: CustomColor.primary,
                        onPressed: () async {
                          try {
                            final result = await LocalRepository.import();
                            if (!context.mounted) {
                              return;
                            }

                            Navigator.of(context).pop();
                            if (!result) {
                              return;
                            }

                            Navigator.of(context).pop();
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return PopScope(
                                  canPop: false,
                                  child: AlertDialog(
                                    title: const Text('앱을 재시작 해주세요.'),
                                    content: const Text('내 예전 데이터가 적용됩니다.'),
                                  ),
                                );
                              },
                            );
                          } on ArgumentError {
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '데이터 옮기기 기능으로 제대로 다운한 파일이 아니에요. '
                                  '파일 양식을 확인해주세요.',
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '알 수 없는 받아오기 문제가 발생했어요. '
                                  '개발자에게 문의해주세요.',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
