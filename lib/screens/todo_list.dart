//stf
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_api/screens/add_page.dart';
import 'package:todo_api/services/todo_service.dart';
import 'package:todo_api/utils/snackbar_helper.dart';
import 'package:todo_api/widget/todo_card.dart';
import '../routes/custom_page_routes.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  //! Calling the method
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8.0,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Todo List'),
        ),
      ),
      //! display todo list
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: Visibility(
          visible: items.isNotEmpty,
          replacement: Center(
            child: Text(
              'No Todo Item',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              //* parameters
              final item = items[index] as Map;

              return TodoCard(
                index: index,
                item: item,
                deleteById: deleteById,
                navigateEdit: navigateToEditPage,
              );
            },
          ),
        ),
      ),
      //! Add button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: navigateToAddPage,
        label: const Text(
          'Add Todo',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  //! To navigate to Add_page
  Future<void> navigateToAddPage() async {
    // final route = MaterialPageRoute(
    //   builder: (context) => const AddTodoPage(),
    // );

    final route = CustomPageRoute(
      child: const AddTodoPage(),
    );

    await Navigator.push(context, route);

    // Auto loading after navigating todo list
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //! To navigate to Edit_page
  Future<void> navigateToEditPage(Map item) async {
    // final route = MaterialPageRoute(
    //   builder: (context) => const AddTodoPage(),
    // );

    final route = CustomPageRoute(
      child: AddTodoPage(todo: item),
    );

    await Navigator.push(context, route);

    // Auto loading after navigating todo list
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //! Delete by Id
  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);

    if (isSuccess) {
      //Remove from the list
      final filtered = items.where((element) => element['_id'] != id).toList();

      setState(() {
        items = filtered;
      });
    } else {
      //Show error
      showErrorMessage(context, message: "Deletion Failed");
    }
  }

  //! Api to get all todos
  Future<void> fetchTodo() async {
    final isSuccess = await TodoService.fetchTodos();
    //Display data
    if (isSuccess != null) {
      setState(() {
        items = isSuccess;
      });
    } else {
      showErrorMessage(context, message: "Something went wrong");
    }

    setState(() {
      isLoading = false;
    });
  }
}
