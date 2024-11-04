import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ],
      ),
    );
  }
}
