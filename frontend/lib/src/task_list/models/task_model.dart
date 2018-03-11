import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';

class TaskModel extends TaskListModel {
  final Object task;

  TaskModel(this.task): super(ModelType.Task);


  @override
  String toString() => '${super.toString()}: $task';
}