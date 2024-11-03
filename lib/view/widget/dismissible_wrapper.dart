import 'package:flutter/material.dart';

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
    return Dismissible(
      key: objectKey,
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('삭제할까요?'),
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            color: CustomColor.warning,
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ),
      ),
      child: child,
    );
  }
}
