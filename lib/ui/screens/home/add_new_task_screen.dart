import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/app_bar.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();

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
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 7,
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                  SizedBox(height: 16),
                  FilledButton(onPressed: () {}, child: Text('Add')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
