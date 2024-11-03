import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/entity/todo.dart';
import '../../../../view_model/todo.dart';
import '../../../theme.dart';

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
    final todoProvider = context.watch<TodoProvider>();

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
            return Dismissible(
              key: Key(item.id.toString()),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('삭제하시겠습니까?'),
                      actions: <Widget>[
                        IconButton(
                          color: CustomColor.primary,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            todoProvider.deleteOne(item);
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
