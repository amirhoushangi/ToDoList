import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/data.dart';
import 'package:flutter_application_1/data/repo/repository.dart';
import 'package:flutter_application_1/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;

  EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: Text('Edit Task', style: themeData.textTheme.headlineSmall!),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            widget.task.name = _controller.text;
            widget.task.priority = widget.task.priority;
            final repository =
                Provider.of<Repository<TaskEntity>>(context, listen: false);
            repository.createOrUpdate(widget.task);

            Navigator.of(context).pop();
          },
          label: const Row(
            children: [
              Text(
                'Save Changes',
              ),
              Icon(
                CupertinoIcons.check_mark,
                size: 18,
              ),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.high;
                        });
                      },
                      label: 'High',
                      color: highpriority,
                      isSelected: widget.task.priority == Priority.high,
                    )),
                SizedBox(width: 8),
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.normal;
                        });
                      },
                      label: 'Normal',
                      color: normalpriority,
                      isSelected: widget.task.priority == Priority.normal,
                    )),
                SizedBox(width: 8),
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.low;
                        });
                      },
                      label: 'Low',
                      color: lowpriority,
                      isSelected: widget.task.priority == Priority.low,
                    )),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  label: Text(
                'Add a task for today...',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.apply(fontSizeFactor: 1.2),
              )),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;
  PriorityCheckBox(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 8,
              bottom: 0,
              top: 0,
              child: Center(
                child: PriorityCheckBoxShape(
                  value: isSelected,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const PriorityCheckBoxShape(
      {super.key, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              size: 12,
              color: themeData.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
