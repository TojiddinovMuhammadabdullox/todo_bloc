import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final bool isComplete;
  final DateTime time;

  Todo({
    required this.id,
    required this.title,
    this.isComplete = false,
    required this.time,
  });

  Todo copyWith({String? title, bool? isComplete, DateTime? time}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isComplete: isComplete ?? this.isComplete,
      time: time ?? this.time,
    );
  }

  @override
  List<Object?> get props => [id, title, isComplete, time];
}
