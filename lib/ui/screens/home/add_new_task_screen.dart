import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/widgets/SnackBarMessage.dart';
import 'package:task_manager/ui/widgets/app_bar.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../Controller/new_task_add_provider.dart';
import '../Controller/new_task_list_provider.dart';

class AddNewTaskScreen extends StatelessWidget {
  const AddNewTaskScreen({super.key});
  static const String routeName = '/add-new-task';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController titleTEController = TextEditingController();
    final TextEditingController descriptionTEController = TextEditingController();

    Future<void> addNewTask() async {
      bool isSuccess = await context.read<NewTaskAddProvider>().addNewTaskApi(
        titleTEController.text.trim(),
        descriptionTEController.text.trim(),
      );
      if (isSuccess == true) {
        context.read<NewTaskListProvider>().newTaskListFetch();
        titleTEController.clear();
        descriptionTEController.clear();
        ShowSnackBarMessage(context, 'Task added successfully');
      } else {
        ShowSnackBarMessage(context,
            context.read<NewTaskAddProvider>().getErrorMessage ?? 'Something went wrong');
      }
    }

    void onTapAddNewTask() {
      if (formKey.currentState?.validate() ?? false) {
        addNewTask();
      }
    }

    return Scaffold(
      appBar: TmAppbar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add New Task",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleTEController,
                    decoration: const InputDecoration(hintText: "Title"),
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionTEController,
                    maxLines: 7,
                    decoration: const InputDecoration(hintText: "Description"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<NewTaskAddProvider>(
                    builder: (context, provider, _) => Visibility(
                      visible: provider.addTaskInProgress == false,
                      replacement: Center(child: const CircularProgressIndicator()),
                      child: FilledButton(
                        onPressed: onTapAddNewTask,
                        child: const Text('Add'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}