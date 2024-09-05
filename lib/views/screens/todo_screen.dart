import 'package:intl/intl.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/bloc/todo_event.dart';
import 'package:todo/bloc/todo_state.dart';
import 'package:todo/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              return Dismissible(
                key: ValueKey(todo.id),
                direction: DismissDirection.startToEnd, // Swipe left to right
                onDismissed: (direction) {
                  context.read<TodoBloc>().add(DeleteTodo(todo.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${todo.title} deleted')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: ListTile(
                  title: Text(todo.title),
                  subtitle: Text(DateFormat.yMd().add_jm().format(todo.time)),
                  trailing: Checkbox(
                    value: todo.isComplete,
                    onChanged: (_) {
                      context.read<TodoBloc>().add(ToggleTodoComplete(todo.id));
                    },
                  ),
                  onLongPress: () {
                    _showEditTodoDialog(context, todo);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time (HH:mm)'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    timeController.text = time.format(context);
                  }
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final timeText = timeController.text;
                final now = DateTime.now();
                final parsedTime = DateFormat.Hm().parse(timeText);
                final todoTime = DateTime(now.year, now.month, now.day,
                    parsedTime.hour, parsedTime.minute);

                final todo = Todo(
                  id: DateTime.now().toString(),
                  title: title,
                  time: todoTime,
                );

                context.read<TodoBloc>().add(AddTodo(todo));
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(BuildContext context, Todo todo) {
    titleController.text = todo.title;
    timeController.text = DateFormat.Hm().format(todo.time);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time (HH:mm)'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(todo.time),
                  );
                  if (time != null) {
                    timeController.text = time.format(context);
                  }
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final timeText = timeController.text;
                final now = DateTime.now();
                final parsedTime = DateFormat.Hm().parse(timeText);
                final todoTime = DateTime(now.year, now.month, now.day,
                    parsedTime.hour, parsedTime.minute);

                context
                    .read<TodoBloc>()
                    .add(EditTodo(todo.id, title, todoTime));
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
