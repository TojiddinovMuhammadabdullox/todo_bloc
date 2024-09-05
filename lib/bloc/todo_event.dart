import 'package:equatable/equatable.dart';
import 'package:todo/model/todo_model.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class AddTodo extends TodoEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final String id;

  const DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class EditTodo extends TodoEvent {
  final String id;
  final String title;
  final DateTime time;

  const EditTodo(this.id, this.title, this.time);

  @override
  List<Object?> get props => [id, title, time];
}

class ToggleTodoComplete extends TodoEvent {
  final String id;

  const ToggleTodoComplete(this.id);

  @override
  List<Object?> get props => [id];
}
