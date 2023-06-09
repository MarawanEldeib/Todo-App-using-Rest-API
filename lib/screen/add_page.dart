import 'package:flutter/material.dart';
import 'package:todo_app/services/todo_service.dart';
import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key,this.todo,});


  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo =widget.todo;
    if(widget.todo != null) {
      isEdit= true;
      final title = todo!['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( isEdit ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData :submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(isEdit ? 'Update' :'Submit'),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    //Get the data from form
    final todo = widget.todo;
    if(todo == null) {
      print('You can not call updated without todo data');
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;

    //Submit updated data to the server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final isSuccess = await TodoService.updateTodo(id, body);

    //show success or fail message based on status
    if (isSuccess) {
      showSucessMessage(context, message:'Updation Success');
    } else {
      showErrorMessage(context, message:'Updation Failed');
    }
  }


  Future<void> submitData() async {

    //Submit data to the server
    final isSuccess = await TodoService.addTodo(body);
    //show success or fail message based on status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSucessMessage(context, message:'Creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Map get body{
//Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return{
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
