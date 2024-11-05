import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme.dart';

class DismissibleWrapperWidget extends StatelessWidget {
  final Key objectKey;
  final Function() onDismissed;
  final Function()? onEdit;
  final Widget child;

  const DismissibleWrapperWidget({
    required this.objectKey,
    this.onEdit,
    required this.onDismissed,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

    return Dismissible(
      key: objectKey,
      direction: onEdit == null
          ? DismissDirection.endToStart
          : DismissDirection.horizontal,
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
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
        }

        if (direction == DismissDirection.startToEnd) {
          return await onEdit?.call();
        }

        return null;
      },
      background: _buildBackground(DismissDirection.startToEnd),
      secondaryBackground: _buildBackground(DismissDirection.endToStart),
      child: child,
    );
  }

  Widget _buildBackground(DismissDirection direction) {
    final color = direction == DismissDirection.startToEnd
        ? CustomColor.primary.withOpacity(0.7)
        : CustomColor.warning.withOpacity(0.7);

    final icon =
        direction == DismissDirection.startToEnd ? Icons.edit : Icons.close;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: color,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
