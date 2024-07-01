// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_api/services/todo_service.dart';
import 'package:todo_api/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  //For edit
  final Map? todo;

  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  //! controller to accessing the values
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;

      //todo --> Pre fill the edit form
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8.0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            isEdit ? 'Edit Todo' : 'Add Todo',
          ),
        ),
      ),

      //todo list --> scrollable
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),

          const SizedBox(height: 30),

          //Submit the form
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[400],
            ),
            onPressed:
                isEdit ? () => updateData(widget.todo!['_id']) : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? 'Update' : 'Submit',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! Map Body
  Map get body {
    // Get the data from the form
    final title = titleController.text;
    final description = descriptionController.text;

    // api request body
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }

  //! Submit data
  Future<void> submitData() async {
    final isSuccess = await TodoService.addTodo(body);

    // Show success or fail message based on the status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';

      showSuccessMessage(context, message: 'Creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  //! Update data
  Future<void> updateData(String id) async {
    // Get the data from the form
    final todo = widget.todo;
    if (todo == null) {
      print('You cannot call updated without todo data');
      return;
    }

    final id = todo['_id'];

    // Submit updated data to the server

    final isSuccess = await TodoService.updateTodo(id, body);

    // Show success or fail message based on the status
    if (isSuccess) {
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }
}
