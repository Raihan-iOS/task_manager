import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/ui/widgets/SnackBarMessage.dart';
import 'package:task_manager/ui/widgets/app_bar.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/utils/constant.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  static const String routeName = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppbar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add New Task",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: InputDecoration(hintText: "Title"),
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 7,
                    decoration: InputDecoration(hintText: "Description"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Visibility(
                    visible: _addNewTaskInProgress == false,
                    replacement: CircularProgressIndicator(),
                    child: FilledButton(onPressed: () {
                      _addNewTask();
                    }, child: Text('Add')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _onTapAddNewTask() {
    if (_formKey.currentState?.validate() ?? false) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    String title = _titleTEController.text.trim();
    String description = _descriptionTEController.text.trim();
    Map<String,dynamic> requestBody = {
      "title":title,
      "description": description,
      "status":"New"
    };
    ApiResponse apiResponse = await ApiCaller.postRequest(url: Urls.createTask,body:requestBody);
   if (apiResponse.isSuccess == true){
     _clearFormData();
     ShowSnackBarMessage(context, 'Task added successfully');
     _addNewTaskInProgress = false;
     setState(() {});

   }else{
     ShowSnackBarMessage(context, apiResponse?.errorMessage ?? 'Something went wrong');
     _addNewTaskInProgress = false;
     setState(() {});
   }
  }
  void _clearFormData() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
