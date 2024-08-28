import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kashyap/Singleton/singleton.dart';
import 'package:kashyap/constants/app_constants.dart';
import 'package:kashyap/module/home/data/model/todo_model.dart';
import 'package:kashyap/utils/navigator_service.dart';
import 'package:meta/meta.dart';

part 'todohome_event.dart';

part 'todohome_state.dart';

class TodohomeBloc extends Bloc<TodohomeEvent, TodohomeState> {
  var fireStore = FirebaseFirestore.instance.collection('todo');
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController dueDateCtrl = TextEditingController();

  TodohomeBloc()
      : super(TodohomeInitial(isLoading: false, todoList: const [])) {
    on<TodoSuccessStateEvent>(_changeToSuccessState);
    on<ChangeToLoadingState>(_changeToLoadingState);
    on<TodoInitEvent>(_initTodo);
    on<AddTodoTask>(_addTodo);
    on<DeleteTodoTask>(_deleteTodo);
    on<UpdateTodoTask>(_updateTodoTask);
    on<EditTodoTask>(_editTodo);
    on<EditTodoTaskInit>(_editTodoInit);
  }

  EventHandler<TodoInitEvent, TodohomeState> get _initTodo =>
      (event, emit) async {
        add(
          ChangeToLoadingState(
            isLoading: (Singleton.instance.todoListObj.isEmpty) ? true : false,
            todoList: Singleton.instance.todoListObj,
          ),
        );
        fireStore
            .where('uid', isEqualTo: Singleton.instance.userID)
            .snapshots()
            .listen(
          (snapshot) {
            List<TodoModel> newList = [];
            var todoList = snapshot.docs
                .map((doc) => TodoModel.fromMap(doc.data(), doc.id))
                .toList();
            todoList.map(
              (e) {
                if (DateFormat("MM-dd-yyyy").format(e.createdAt) ==
                    DateFormat("MM-dd-yyyy").format(DateTime.now())) {
                  newList.add(e);
                }
              },
            ).toList();
            newList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            add(TodoSuccessStateEvent(todoList: newList));
            String encodedData =
                jsonEncode(newList.map((obj) => obj.toMapParse()).toList());
            Singleton.instance.setTodoListToLocal(encodedData);
          },
        );
      };

  EventHandler<UpdateTodoTask, TodohomeState> get _updateTodoTask =>
      (event, emit) {
        add(TodoSuccessStateEvent(isLoading: true));

        fireStore.doc('${event.docID}').update({
          'isCompleted': event.completed! ? 1 : 0,
        }).then(
          (value) {
            add(TodoSuccessStateEvent());
            showToast("Task updated");
          },
        ).onError(
          (error, stackTrace) {
            add(TodoSuccessStateEvent());
            showToast("Something went wrong");
          },
        );
      };

  EventHandler<EditTodoTask, TodohomeState> get _editTodo => (event, emit) {
        add(TodoSuccessStateEvent(isLoading: true));
        fireStore.doc('${event.docID}').update({
          'name': titleCtrl.text.trim(),
          'description': descCtrl.text.trim(),
          'dueDate': state.dueDate?.millisecondsSinceEpoch,
        }).then(
          (value) {
            add(TodoSuccessStateEvent(isNavigateBack: true));
            showToast("Task updated");
          },
        ).onError(
          (error, stackTrace) {
            add(TodoSuccessStateEvent());
            showToast("Something went wrong");
          },
        );
      };

  EventHandler<TodoSuccessStateEvent, TodohomeState>
      get _changeToSuccessState => (event, emit) {
            emit(TodoListingSuccessState(
                isLoading: event.isLoading ?? false,
                todoList: event.todoList ?? state.todoList,
                isNavigateBack: event.isNavigateBack ?? false));
          };

  EventHandler<ChangeToLoadingState, TodohomeState> get _changeToLoadingState =>
      (event, emit) {
        emit(TodohomeLoadingState(
            isLoading: event.isLoading ?? false,
            todoList: event.todoList ?? state.todoList));
      };

  EventHandler<AddTodoTask, TodohomeState> get _addTodo => (event, emit) async {
        add(TodoSuccessStateEvent(isLoading: true));
        final todo = TodoModel(
          name: titleCtrl.text.trim(),
          description: descCtrl.text.trim(),
          isCompleted: false,
          createdAt: DateTime.now(),
          dueDate: state.dueDate ?? DateTime.now(),
          uid: Singleton.instance.userID, // User ID (if applicable)
        );
        await fireStore
            // Replace with your actual collection name
            .add(todo.toMap()) // Convert your data to a Map
            .then((documentReference) {
          emit(TodoAddedState(todoList: state.todoList, isLoading: false));
          add(TodoSuccessStateEvent());
          showToast("Task added successfully!");
        }).catchError((error) {
          add(TodoSuccessStateEvent());
          showToast("Something went wrong!");
        });
      };

  EventHandler<DeleteTodoTask, TodohomeState> get _deleteTodo =>
      (event, emit) async {
        await fireStore.doc('${event.docID}').delete().then(
          (value) {
            showToast("Task deleted successfully!");
          },
        ).catchError((error) => showToast("Something went wrong!"));
      };

  EventHandler<EditTodoTaskInit, TodohomeState> get _editTodoInit =>
      (event, emit) {
        if (event.isEdit ?? false) {
          var editData = (event.editData as TodoModel);
          titleCtrl.text = editData.name;
          descCtrl.text = editData.description;
          state.dueDate = editData.dueDate;

          String showDate = DateFormat('MM-dd-yyyy').format(editData.dueDate);
          dueDateCtrl.text = showDate;
        }
      };
}
