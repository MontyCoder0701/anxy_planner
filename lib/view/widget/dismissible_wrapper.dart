import 'package:flutter/material.dart';

import '../theme.dart';

class DismissibleWrapperWidget extends StatelessWidget {
  final Key objectKey;
  final Function() onDelete;
  final Function()? onEdit;
  final Widget child;

  const DismissibleWrapperWidget({
    required this.objectKey,
    this.onEdit,
    required this.onDelete,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: objectKey,
      direction: onEdit == null
          ? DismissDirection.endToStart
          : DismissDirection.horizontal,
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          return await onDelete.call();
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
        ? CustomColor.primary.withValues(alpha: 0.7)
        : CustomColor.warning.withValues(alpha: 0.7);

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
