import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/setting.dart';
import '../../../view_model/todo.dart';
import '../../theme.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.read<SettingProvider>();
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
            leading: Icon(
              settingProvider.isLight ? Icons.dark_mode : Icons.light_mode,
            ),
            title: const Text('테마 변경'),
            onTap: () => settingProvider.toggleThemeMode(),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('앱 데이터 정리하기'),
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('정리하시겠습니까?'),
                    content: const Text('오래된 데이터를 삭제해 앱이 가벼워집니다.'),
                    actions: <Widget>[
                      IconButton(
                        color: CustomColor.primary,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await todoProvider.deleteExpiredData();

                          if (context.mounted) {
                            Navigator.of(context).pop();
                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(content: Text('정리되었습니다.')),
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
            title: const Text('개발자 문의'),
            onTap: () => settingProvider.sendMailToDeveloper(),
          ),
        ],
      ),
    );
  }
}
