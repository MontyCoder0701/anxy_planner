import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/entity/todo.dart';
import '../../../../view_model/todo.dart';
import '../../../widget/dismissible_wrapper.dart';

class TodoListWidget extends StatelessWidget {
  final List<TodoEntity> items;
  final String title;

  const TodoListWidget({
    super.key,
    required this.items,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.read<TodoProvider>();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return DismissibleWrapperWidget(
              objectKey: Key(item.id.toString()),
              onDismissed: () => todoProvider.deleteOne(item),
              child: CheckboxListTile(
                activeColor: Colors.grey,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: item.isComplete ? Colors.grey : null,
                    decoration:
                        item.isComplete ? TextDecoration.lineThrough : null,
                  ),
                ),
                value: item.isComplete,
                onChanged: (bool? value) {
                  if (value != null) {
                    todoProvider.updateOne(item..isComplete = value);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
