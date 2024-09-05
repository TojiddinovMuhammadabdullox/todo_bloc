import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/model/todo_model.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<AddTodo>((event, emit) {
      final updatedTodos = List<Todo>.from(state.todos)..add(event.todo);
      emit(TodoState(todos: updatedTodos));
    });

    on<DeleteTodo>((event, emit) {
      final updatedTodos =
          state.todos.where((todo) => todo.id != event.id).toList();
      emit(TodoState(todos: updatedTodos));
    });

    on<EditTodo>((event, emit) {
      final updatedTodos = state.todos.map((todo) {
        if (todo.id == event.id) {
          return todo.copyWith(title: event.title, time: event.time);
        }
        return todo;
      }).toList();
      emit(TodoState(todos: updatedTodos));
    });

    on<ToggleTodoComplete>((event, emit) {
      final updatedTodos = state.todos.map((todo) {
        if (todo.id == event.id) {
          return todo.copyWith(isComplete: !todo.isComplete);
        }
        return todo;
      }).toList();
      emit(TodoState(todos: updatedTodos));
    });
  }
}
