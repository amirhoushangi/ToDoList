import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/edit/edit.dart';
import 'package:flutter_application_1/Screens/home/bloc/task_list_bloc.dart';
import 'package:flutter_application_1/Widgets.dart';
import 'package:flutter_application_1/data/data.dart';
import 'package:flutter_application_1/data/repo/repository.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditTaskScreen(
                          task: TaskEntity(),
                        )));
          },
          label: const Row(
            children: [
              Text('Add New Task'),
              SizedBox(width: 4),
              Icon(CupertinoIcons.add_circled, size: 20),
            ],
          )),
      body: BlocProvider<TaskListBloc>(
        create: (context) =>
            TaskListBloc(context.read<Repository<TaskEntity>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  themeData.colorScheme.primary,
                  themeData.colorScheme.onPrimaryFixedVariant,
                ])),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themeData.textTheme.headlineSmall!
                                .apply(color: themeData.colorScheme.onPrimary),
                          ),
                          Icon(
                            CupertinoIcons.share,
                            color: themeData.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 46,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: themeData.colorScheme.onPrimary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                              )
                            ]),
                        child: Builder(
                          builder: (context) {
                            return TextField(
                              onChanged: (value) {
                                context
                                    .read<TaskListBloc>()
                                    .add(TaskListSearch(value));
                              },
                              controller: controller,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.search,
                                    color: Color(0xffafbed0)),
                                label: Text('Search tasks...'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<Repository<TaskEntity>>(
                  builder: (context, model, child) {
                    context.read<TaskListBloc>().add(TaskListStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        if (state is TaskListSuccess) {
                          return TaskList(
                              items: state.items, themeData: themeData);
                        } else if (state is TaskListEmpty) {
                          return const EmptyState();
                        } else if (state is TaskListLoading ||
                            state is TaskListInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskListError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else {
                          throw Exception('state is not valid...');
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final dynamic items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: themeData.textTheme.headlineSmall!
                          .apply(fontSizeFactor: 0.9, fontWeightDelta: 2),
                    ),
                    Container(
                      width: 70,
                      height: 4,
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(1.5)),
                    )
                  ],
                ),
                MaterialButton(
                    color: const Color(0xffeaeff5),
                    textColor: secondryTextColor,
                    elevation: 0,
                    onPressed: () {
                      context.read<TaskListBloc>().add(TaskListDeleteAll());
                    },
                    child: const Row(
                      children: [
                        Text('Delete All'),
                        SizedBox(width: 4),
                        Icon(
                          CupertinoIcons.delete_solid,
                          size: 18,
                        ),
                      ],
                    )),
              ],
            );
          } else {
            final TaskEntity task = items[index - 1];
            return TaskItem(task: task);
          }
        });
  }
}

class TaskItem extends StatefulWidget {
  static const double height = 74;
  static const double borderRadius = 8;
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowpriority;
      case Priority.normal:
        priorityColor = normalpriority;
      case Priority.high:
        priorityColor = highpriority;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(task: widget.task),
            ),
          );
        },
        onLongPress: () {
          final taskRepository =
              Provider.of<Repository<TaskEntity>>(context, listen: false);
          taskRepository.delete(widget.task);
        },
        child: Container(
          height: TaskItem.height,
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TaskItem.borderRadius),
            color: themeData.colorScheme.onPrimary,
          ),
          child: Row(
            children: [
              MyCheckBox(
                value: widget.task.isCompleted,
                onTap: () {
                  setState(() {
                    widget.task.isCompleted = !widget.task.isCompleted;
                  });
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.task.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null),
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 6,
                height: TaskItem.height,
                decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(TaskItem.borderRadius),
                      bottomRight: Radius.circular(TaskItem.borderRadius),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
