import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/get_new_task_provider.dart';
import 'package:task_manager_assignment/data/provider/progress_task_provider.dart';
import 'package:task_manager_assignment/data/provider/task_card_functionality_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.refreshParent,
  });

  final TaskModel taskModel;
  final VoidCallback refreshParent;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final TaskCardFunctionalityProvider _provider =
      TaskCardFunctionalityProvider();

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
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Row(
            children: [
              Chip(
                label: widget.taskModel.status == "New"
                    ? Text(
                        widget.taskModel.status,
                        style: TextStyle(color: Colors.black),
                      )
                    : widget.taskModel.status == "Completed"
                    ? Text(
                        widget.taskModel.status,
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        widget.taskModel.status,
                        style: TextStyle(color: Colors.black),
                      ),
                backgroundColor: widget.taskModel.status == "New"
                    ? Colors.greenAccent
                    : widget.taskModel.status == "Progress"
                    ? Colors.blue
                    : widget.taskModel.status == "Cancelled"
                    ? Colors.red
                    : widget.taskModel.status == "Completed"
                    ? Colors.cyanAccent
                    : Colors.red, // ==========
                labelStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  _deleteTask();
                },
                icon: Icon(Icons.delete, color: Colors.grey),
              ),
              IconButton(
                onPressed: () {
                  _showChangeStatusDialog();
                },
                icon: Icon(Icons.edit),
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _changeStatus('New');
                },
                title: Text('New'),
                trailing: widget.taskModel.status == 'New'
                    ? Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _changeStatus('Progress');
                },
                title: Text('Progress'),
                trailing: widget.taskModel.status == 'Progress'
                    ? Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _changeStatus('Cancelled');
                },
                title: Text('Cancelled'),
                trailing: widget.taskModel.status == 'Cancelled'
                    ? Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _changeStatus('Completed');
                },
                title: Text('Completed'),
                trailing: widget.taskModel.status == 'Completed'
                    ? Icon(Icons.done)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  // task status change method
  Future<void> _changeStatus(String status) async {
    if (status == widget.taskModel.status) {
      return;
    }

    Navigator.pop(context);

    final bool isSuccess = await _provider.changeStatus(
      widget.taskModel.id,
      status,
    );

    if (isSuccess) {
      widget.refreshParent();
    } else {
      showSnackBarMessage(context, _provider.errorMessage.toString());
    }
  }

  // task delete method
  Future<void> _deleteTask() async {
    final bool isSuccess = await _provider.deleteTask(widget.taskModel.id);

    if (isSuccess) {
      widget.refreshParent();
    } else {
      showSnackBarMessage(context, _provider.errorMessage.toString());
    }
  }
}
