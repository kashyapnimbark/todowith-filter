part of 'todohome_bloc.dart';

@immutable
sealed class TodohomeEvent {}

class TodoInitEvent extends TodohomeEvent {
  TodoInitEvent();
}

class AddTodoTask extends TodohomeEvent {
  AddTodoTask();
}

class EditTodoTask extends TodohomeEvent {
  String? docID;

  EditTodoTask({this.docID});
}

class EditTodoTaskInit extends TodohomeEvent {
  dynamic editData;
  bool? isEdit = false;

  EditTodoTaskInit({this.isEdit, this.editData});
}

class DeleteTodoTask extends TodohomeEvent {
  String? docID;

  DeleteTodoTask({this.docID});
}

class UpdateTodoTask extends TodohomeEvent {
  String? docID;
  bool? completed;
  DateTime? dueDate;

  UpdateTodoTask({this.docID, this.completed, this.dueDate});
}

class TodoSuccessStateEvent extends TodohomeEvent {
  bool? isLoading;
  bool? isNavigateBack;
  List<TodoModel>? todoList;
  DateTime? dueDate;

  TodoSuccessStateEvent(
      {this.isLoading, this.todoList, this.dueDate, this.isNavigateBack});
}

class ChangeToLoadingState extends TodohomeEvent {
  bool? isLoading;
  bool? isNavigateBack;
  List<TodoModel>? todoList;
  DateTime? dueDate;

  ChangeToLoadingState(
      {this.isLoading, this.todoList, this.dueDate, this.isNavigateBack});
}
