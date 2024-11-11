import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../view_model/local.dart';
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
    final tr = AppLocalizations.of(context);

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showLicensePage(
                context: context,
                applicationVersion: settingProvider.version,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('One Moon', style: CustomTypography.titleMedium),
                  Text(tr.appInfo),
                ],
              ),
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
            title: Text(tr.toggleTheme),
            onTap: () => settingProvider.toggleThemeMode(),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: Text(tr.cleanupData),
            enabled: todoProvider.isExpiredTodosExists,
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(tr.confirmCleanup),
                    content: Text(tr.cleanupDataDescription),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: CustomColor.primary,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await todoProvider.deleteExpiredTodos();

                          if (context.mounted) {
                            Navigator.of(context).pop();
                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text(tr.dataCleaned)),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text(tr.contactDeveloper),
            onTap: () => settingProvider.sendMailToDeveloper(
              subject: tr.emailToDeveloperSubject,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(tr.experimental),
            subtitle: Text(tr.experimentalSubtitle),
          ),
          ListTile(
            leading: Icon(Icons.file_upload_outlined),
            title: Text(tr.exportDataToDrive),
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(tr.exportDataToDrive),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(tr.exportDataDescription1),
                        Text(tr.exportDataDescription2),
                      ],
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: CustomColor.primary,
                        onPressed: () async {
                          try {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PopScope(
                                  canPop: false,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            );

                            final result = await DataPersistenceManager
                                .backupToGoogleDrive();
                            if (!context.mounted) {
                              return;
                            }

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            if (result) {
                              scaffoldMessenger.hideCurrentSnackBar();
                              scaffoldMessenger.showSnackBar(
                                SnackBar(content: Text(tr.exportDataComplete)),
                              );
                            }
                          } on PlatformException catch (e) {
                            switch (e.code) {
                              case 'network_error':
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                scaffoldMessenger.hideCurrentSnackBar();
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(tr.noNetworkConnection),
                                  ),
                                );
                              default:
                                rethrow;
                            }
                          } catch (e) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text(tr.unknownError)),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.save_alt),
            title: Text(tr.restoreDataFromDrive),
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(tr.restoreDataFromDrive),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(tr.importDataDescription1),
                        Text(
                          tr.importDataDescription2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColor.warning,
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: CustomColor.primary,
                        onPressed: () async {
                          try {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PopScope(
                                  canPop: false,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            );

                            final result = await DataPersistenceManager
                                .restoreFromGoogleDrive();
                            if (!context.mounted) {
                              return;
                            }

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            if (result) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return PopScope(
                                    canPop: false,
                                    child: AlertDialog(
                                      title: Text(tr.restartApp),
                                      content: Text(tr.restartAppDescription),
                                    ),
                                  );
                                },
                              );
                            }
                          } on NoBackupFileException catch (_) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text(tr.noBackupFile)),
                            );
                          } on PlatformException catch (e) {
                            switch (e.code) {
                              case 'network_error':
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                scaffoldMessenger.hideCurrentSnackBar();
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(tr.noNetworkConnection),
                                  ),
                                );
                              default:
                                rethrow;
                            }
                          } catch (e) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text(tr.unknownError)),
                            );
                          }
                        },
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
