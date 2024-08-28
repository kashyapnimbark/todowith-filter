part of 'todohome_bloc.dart';

@immutable
sealed class TodohomeState {
  bool? isLoading;
  List<TodoModel>? todoList;
  bool? autoValidate;
  bool? isNavigateBack;
  DateTime? dueDate;

  TodohomeState({
    this.isLoading = false,
    this.todoList = const [],
    this.autoValidate = false,
    this.isNavigateBack = false,
    this.dueDate = null,
  });
}

final class TodohomeInitial extends TodohomeState {
  TodohomeInitial({
    super.isLoading = null,
    super.todoList = null,
    super.dueDate = null,
    super.autoValidate = false,
    super.isNavigateBack = false,
  });
}

final class TodohomeLoadingState extends TodohomeState {
  TodohomeLoadingState({
    super.isLoading = null,
    super.todoList = null,
    super.dueDate = null,
    super.autoValidate = false,
    super.isNavigateBack = false,
  });
}

final class TodoAddedState extends TodohomeState {
  TodoAddedState({
    super.isLoading = null,
    super.todoList = null,
    super.dueDate = null,

    super.autoValidate = false,
    super.isNavigateBack = false,
  });
}

final class TodoListingSuccessState extends TodohomeState {
  TodoListingSuccessState({
    super.isLoading = null,
    super.todoList = null,
    super.dueDate = null,
    super.autoValidate = false,
    super.isNavigateBack = false,
  });
}
