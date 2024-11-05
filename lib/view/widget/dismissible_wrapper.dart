import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme.dart';

class DismissibleWrapperWidget extends StatelessWidget {
  final Key objectKey;
  final Function() onDismissed;
  final Widget child;

  const DismissibleWrapperWidget({
    required this.objectKey,
    required this.onDismissed,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

    return Dismissible(
      key: objectKey,
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(tr.confirmDelete),
              actions: <Widget>[
                IconButton(
                  color: CustomColor.primary,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onDismissed();
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            );
          },
        );
      },
      background: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            color: CustomColor.warning.withOpacity(0.7),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ),
      ),
      child: child,
    );
  }
}
