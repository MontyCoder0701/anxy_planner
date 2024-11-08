import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../model/entity/todo.dart';
import '../../../../view_model/todo.dart';
import '../../../theme.dart';

class MoonstepScreen extends StatefulWidget {
  const MoonstepScreen({super.key});

  @override
  State<MoonstepScreen> createState() => _MoonstepScreenState();
}

class _MoonstepScreenState extends State<MoonstepScreen> {
  late final tr = AppLocalizations.of(context);
  late final todoProvider = context.watch<TodoProvider>();

  Map<int, List<TodoEntity>> get moonstepTodos =>
      todoProvider.moonStepTodosByMonth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ListTile(
                iconColor: CustomColor.primary,
                textColor: CustomColor.primary,
                leading: Icon(Icons.brightness_2_rounded),
                title: Text(
                  tr.moonStepsTitle,
                  style: CustomTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(tr.moonStepsSubtitle),
              ),
              SizedBox(height: 10.0),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: moonstepTodos.length,
                separatorBuilder: (context, index) => SizedBox(height: 10.0),
                itemBuilder: (context, index) {
                  final month = moonstepTodos.keys.elementAt(index);
                  final todos = moonstepTodos[month] ?? [];

                  return Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: CustomColor.primary.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.MMMM(tr.localeName)
                                .format(DateTime(0, month)),
                            style: CustomTypography.titleMedium,
                          ),
                          SizedBox(height: 6.0),
                          ...todos.map(
                            (todo) => Wrap(
                              children: [
                                Text('• '),
                                Text(todo.title),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
