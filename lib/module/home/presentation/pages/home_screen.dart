import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kashyap/Singleton/singleton.dart';
import 'package:kashyap/constants/app_color.dart';
import 'package:kashyap/custom_widgets/app_button.dart';
import 'package:kashyap/custom_widgets/custom_dialog.dart';
import 'package:kashyap/module/home/presentation/Bloc/todohome_bloc.dart';
import 'package:kashyap/routes/routes.dart';
import 'package:kashyap/utils/navigator_service.dart';
import 'package:kashyap/utils/size_utils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../data/model/todo_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => TodohomeBloc()..add(TodoInitEvent()),
      child: HomeScreen(),
    );
  }

  List filtersList = [
    {
      'title': 'Completed Task',
      'value': Singleton.instance.isFilterCompletedTask
    },
    {
      'title': 'Due Date',
      'value': Singleton.instance.isFilterByDueDate,
    },
    {
      'title': 'Default',
      'value': Singleton.instance.isDefault,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.sectionText,
          title: const Text("To do List"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                customAlert(
                  isCenterAction: true,
                  context: context,
                  cancelButtonTExt: "No",
                  title: Text(
                    "Are you sure you want to Logout",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onSubmit: () async {
                    NavigatorService.goBack();
                    try {
                      await FirebaseAuth.instance.signOut();
                      Singleton.instance.logout();
                      // Navigate to your login screen or handle successful logout as needed
                    } on FirebaseAuthException catch (e) {
                      Singleton.instance.logout();
                      print('Error signing out: ${e.code}');
                      // Handle errors appropriately, e.g., display an error message to the user
                    }
                  },
                );
              },
              icon: Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.blackFont,
              ),
            ),
            BlocBuilder<TodohomeBloc, TodohomeState>(
              builder: (context1, state) {
                return IconButton(
                  onPressed: () {
                    showDialog(
                      useSafeArea: true,
                      barrierDismissible: false,
                      useRootNavigator: false,
                      barrierColor: Colors.black.withOpacity(0.5),
                      // Optional: For initial dimming

                      context: context,
                      builder: (context2) {
                        return BlocProvider.value(
                          value: BlocProvider.of<TodohomeBloc>(context),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Dialog(
                              insetPadding: const EdgeInsets.all(20),
                              child: eventTypeList(context: context),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.filter_alt_sharp,
                    color: AppColors.blackFont,
                  ),
                );
              },
            )
          ],
        ),
        body:
            BlocBuilder<TodohomeBloc, TodohomeState>(builder: (context, state) {
          if (state is TodoListingSuccessState &&
              (state.todoList ?? []).isEmpty) {
            return ModalProgressHUD(
                inAsyncCall: state.isLoading ?? false,
                child: const Center(child: Text("No Data Found!")));
          } else {
            return todoListView(state);
          }
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: floatingActionBtn());
  }

  Widget floatingActionBtn() {
    return FloatingActionButton(
      shape: const StadiumBorder(),
      backgroundColor: AppColors.sectionText,
      onPressed: () {
        NavigatorService.pushNamed(AppRoutes.todoForm);
      },
      child: const Icon(Icons.add),
    );
  }

  eventTypeList({BuildContext? context}) {
    return BlocBuilder<TodohomeBloc, TodohomeState>(
      builder: (context, state) {
        return Padding(
          padding: getPadding(all: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Spacer(),
                  Spacer(),
                  Text(
                    "Filter Task",
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        NavigatorService.goBack();
                      },
                      icon: Icon(Icons.close))
                ],
              ),
              SizedBox(height: getVerticalSize(20)),
              Flexible(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filtersList.length,
                  itemBuilder: (context2, index) {
                    return InkWell(
                      onTap: () {
                        filtersList
                            .map(
                              (e) => e['value'] = false,
                            )
                            .toList();
                        filtersList[index]['value'] = true;
                        //
                        if (index == 0) {
                          Singleton.instance.isFilterCompletedTask = true;
                          Singleton.instance.isFilterByDueDate = false;
                          Singleton.instance.isDefault = false;
                        }
                        if (index == 1) {
                          Singleton.instance.isFilterByDueDate = true;
                          Singleton.instance.isFilterCompletedTask = false;
                          Singleton.instance.isDefault = false;
                        }
                        if (index == 2) {
                          Singleton.instance.isFilterByDueDate = false;
                          Singleton.instance.isFilterCompletedTask = false;
                          Singleton.instance.isDefault = true;
                        }
                        context
                            .read<TodohomeBloc>()
                            .add(TodoSuccessStateEvent());
                      },
                      child: Card(
                        color: AppColors.buttonBgColor,
                        margin: getMargin(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("${filtersList[index]['title']}"),
                                ],
                              ),
                              Padding(
                                padding: getPadding(right: 10),
                                child: Icon(
                                  (filtersList[index]['value']
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off_rounded),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: getVerticalSize(20)),
              AppButton(
                color: AppColors.sectionText,
                onTap: () {
                  NavigatorService.goBack();
                },
                buttonText: 'Apply',
              )
            ],
          ),
        );
      },
    );
  }

  Widget todoListView(TodohomeState state) {
    var newList = state.todoList ?? [];
    if (Singleton.instance.isFilterByDueDate) {
      var newList = state.todoList ?? [];

      newList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (Singleton.instance.isFilterCompletedTask) {
      List<TodoModel> data = [];
      state.todoList?.map(
        (e) {
          if (e.isCompleted) {
            data.add(e);
          }
        },
      ).toList();
      newList = data;
    } else if (Singleton.instance.isDefault) {
      var newList = state.todoList ?? [];
      if (newList.isNotEmpty) {
        newList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    }
    return ModalProgressHUD(
      inAsyncCall: state.isLoading ?? false,
      child: ListView.builder(
        itemCount: newList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var todoDetails = newList[index];
          return Padding(
            padding: getPadding(all: 8),
            child: Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red, // Background color on swipe
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              direction: DismissDirection.endToStart,
              secondaryBackground: Container(
                color: Colors.red, // Background color on swipe
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: getPadding(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {}
                context
                    .read<TodohomeBloc>()
                    .add(DeleteTodoTask(docID: todoDetails.id));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Due On: " +
                                DateFormat("dd-MMM-yyyy")
                                    .format(todoDetails!.dueDate),
                          ),
                          AppButton(
                            height: 30,
                            color: Colors.transparent,
                            padding: getPadding(left: 5, right: 5),
                            onTap: () {
                              NavigatorService.pushNamed(AppRoutes.todoForm,
                                  arguments: todoDetails);
                            },
                            child: Icon(Icons.edit),
                          )
                        ],
                      ),
                      Text(
                        todoDetails?.name ?? "",
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      if ((todoDetails?.description ?? "")
                          .isNotEmpty) // Only show description if it exists
                        Text(
                          (todoDetails?.description ?? ""),
                          maxLines: 20,
                          // Limit to two lines with ellipsis overflow
                          overflow: TextOverflow.ellipsis,
                        ),
                      // Spacer(), // Add some vertical space
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  fillColor: WidgetStateProperty.all(
                                      todoDetails!.isCompleted
                                          ? Colors.green
                                          : Colors.white),
                                  value: todoDetails.isCompleted,
                                  onChanged: (value) {
                                    customAlert(
                                      isCenterAction: true,
                                      context: context,
                                      cancelButtonTExt: "No",
                                      title: Text(
                                        value ?? false
                                            ? "Are you sure you want to mark as completed"
                                            : "Are you sure you want to mark as Not Complete",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onSubmit: () {
                                        NavigatorService.goBack();
                                        context.read<TodohomeBloc>().add(
                                            UpdateTodoTask(
                                                completed: value,
                                                docID: todoDetails?.id));
                                      },
                                    );
                                  }),
                              // Handle checkbox change if needed
                              Text(todoDetails!.isCompleted
                                  ? 'Completed'
                                  : 'Not Completed'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
