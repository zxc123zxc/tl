import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';

class FolderModel extends TaskListModel {
  FolderModel(): super(ModelType.Folder);


  @override
  String toString() => '${super.toString()} ';
}