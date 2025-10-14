import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/screens/home/new_task_screen.dart';

import '../../data/services/api_caller.dart';
import '../../data/utils/constant.dart';
import 'SnackBarMessage.dart';

class taskCard extends StatefulWidget {
  const taskCard({super.key, required this.taskStatus, required this.taskModel,required this.refreashParents});
  final TaskStatus taskStatus;
  final TaskModel taskModel;
 final VoidCallback refreashParents;
  @override
  State<taskCard> createState() => _taskCardState();
}

class _taskCardState extends State<taskCard> {
  bool _changeStatusInProgress = false;
  bool _deleteStatusInProgress = false;


  Color TaskTypeColor(TaskStatus taskType) {
    if (taskType == TaskStatus.New) {
      return Colors.blue;
    } else if (taskType == TaskStatus.Progress) {
      return Colors.purple;
    } else if (taskType == TaskStatus.Completed) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Future<void> _deleteTask() async {
    _deleteStatusInProgress = true;
    setState(() {});
    final ApiResponse apiResponse = await ApiCaller.getRequest(url: Urls.deleteTask(widget.taskModel.id));
    if (apiResponse.isSuccess == true) {
      _deleteStatusInProgress = false;
      widget.refreashParents();

      setState(() {});
    }else{
      _deleteStatusInProgress = false;

      setState(() {});
      ShowSnackBarMessage(context, apiResponse.errorMessage!);
    }
  }

  Future<void> _changeStatus(String status) async {
    if(status == widget.taskModel.status){
      return;
    }
    _changeStatusInProgress = true;
    setState(() {});
     final ApiResponse apiResponse = await ApiCaller.getRequest(url: Urls.changeTaskStatus(widget.taskModel.id, status));
     if (apiResponse.isSuccess == true) {
       _changeStatusInProgress = false;
        widget.refreashParents();
       Navigator.of(context).pop();
       setState(() {});
     }else{
       _changeStatusInProgress = false;
       Navigator.of(context).pop();
       setState(() {});
       ShowSnackBarMessage(context, apiResponse.errorMessage!);
     }

  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Colors.white,
      title: Text(widget.taskModel.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(widget.taskModel.description),
          Text(
            'Date: ${widget.taskModel.createdDate}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Chip(
                label: Text(
                  widget.taskModel.status,
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: TaskTypeColor(widget.taskStatus),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              Spacer(),
              Visibility(
                visible: _deleteStatusInProgress == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: IconButton(
                  onPressed: () {
                    _showDeleteTap();
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ),
              Visibility(
                visible: _changeStatusInProgress == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: IconButton(
                  onPressed: () {
                    _showChangeStatusDialog();
                  },
                  icon: Icon(Icons.edit, color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteTap(){
    showDialog(context: context, builder: (context)=>
        AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('No')),
            TextButton(onPressed: ()async{
              _deleteTask();
              Navigator.of(context).pop();

            }, child: Text('Yes')),
          ],
        )
    );
  }


  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Task Status'),
        content: Text('Are you sure you want to change the status of this task?'),
        actions: [

          ListTile(
            title: Text('New'),
            trailing: widget.taskModel.status == 'New' ? Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              _changeStatus('New');

            },
          ),
          ListTile(
            title: Text('Progress'),
            trailing: widget.taskModel.status == 'Progress' ? Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              _changeStatus('Progress');

            },
          ),
          ListTile(
            title: Text('Cancelled'),
            trailing: widget.taskModel.status == 'Cancelled' ? Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              _changeStatus('Cancelled');

            },
          ),
          ListTile(
            title: Text('Completed'),
            trailing: widget.taskModel.status == 'Completed' ? Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              _changeStatus('Completed');

            },
          )

        ],
      ),
    );
  }



}
