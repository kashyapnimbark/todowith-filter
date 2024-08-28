import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kashyap/constants/app_constants.dart';
import 'package:kashyap/custom_widgets/app_button.dart';
import 'package:kashyap/custom_widgets/app_textfield_with_label.dart';
import 'package:kashyap/module/home/data/model/todo_model.dart';
import 'package:kashyap/module/home/presentation/Bloc/todohome_bloc.dart';
import 'package:kashyap/utils/navigator_service.dart';
import 'package:kashyap/utils/size_utils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../constants/app_color.dart';

class TodoForm extends StatelessWidget {
  dynamic editData;
  bool? isEdit = false;

  TodoForm({this.editData, this.isEdit});

  static Widget builder(BuildContext context) {
    var editData = ModalRoute.of(context)?.settings.arguments;
    bool? isEdit = false;

    if (editData != null) {
      isEdit = true;
    }
    return BlocProvider(
        create: (context) => TodohomeBloc()
          ..add(EditTodoTaskInit(
            isEdit: (isEdit ?? false),
            editData: (isEdit ?? false) ? editData as TodoModel : Null,
          )),
        child: TodoForm(
          isEdit: isEdit,
          editData: isEdit ? editData as TodoModel : Null,
        ));
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sectionText,
        title: Text(isEdit! ? "Edit Todo Task" : "Add Todo Task"),
        centerTitle: true,
      ),
      body:
          BlocConsumer<TodohomeBloc, TodohomeState>(listener: (context, state) {
        if (state is TodoAddedState) {
          NavigatorService.goBack();
        }
        if (state.isNavigateBack ?? false) {
          NavigatorService.goBack();
        }
      }, builder: (context, state) {
        var bloc = context.read<TodohomeBloc>();
        return ModalProgressHUD(
          inAsyncCall: state.isLoading ?? false,
          child: Padding(
            padding: getPadding(all: 20),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: state.autoValidate!
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(children: [
                  AppTextFieldWithLabel(
                    maxLength: 80,
                    controller: bloc.titleCtrl,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        bloc.titleCtrl.text.trim();
                        return 'Title is required.';
                      }
                      return null;
                    },
                    // controller: name,
                    labelText: 'Title',
                    hintText: 'Enter title',
                    onChanged: (string) {},
                  ),
                  AppTextFieldWithLabel(
                    maxLength: 250,
                    controller: bloc.descCtrl,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        bloc.descCtrl.text.trim();
                        return 'Description is required.';
                      }
                      return null;
                    },
                    // controller: name,
                    labelText: 'Description',
                    minLines: 3,
                    maxLines: 7,
                    hintText: 'Enter description',
                    onChanged: (string) {},
                  ),
                  AppTextFieldWithLabel(
                    borderColor: AppColors.textFieldBorder,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please select due date.';
                      }
                      return null;
                    },
                    readOnly: true,
                    controller: bloc.dueDateCtrl,
                    labelText: "From Date",
                    suffixIcon: Icon(
                      Icons.date_range_outlined,
                      color: AppColors.textFieldBorder,
                    ),
                    onTap: () async {
                      hideKeyboard();

                      var date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2031),
                        initialDate: state.dueDate ?? DateTime.now(),
                      );
                      if (date != null) {
                        // – kk:mm dd-MM-yyyy'
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        state.dueDate = date;

                        String showDate = DateFormat('MM-dd-yyyy').format(date);
                        bloc.dueDateCtrl.text = showDate;
                      }
                    },
                    hintText: "Select Due Date",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AppButton(
                    color: AppColors.sectionText,
                    onTap: () {
                      state.autoValidate = true;

                      if (formKey.currentState!.validate()) {
                        if (isEdit ?? false) {
                          context.read<TodohomeBloc>().add(
                              EditTodoTask(docID: (editData as TodoModel).id));
                        } else {

                          context.read<TodohomeBloc>().add(AddTodoTask());
                        }
                      }
                    },
                    textColor: AppColors.blackFont,
                    buttonText: 'Submit',
                  )
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
