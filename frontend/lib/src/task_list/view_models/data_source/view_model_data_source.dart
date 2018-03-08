import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

abstract class ViewModelDataSource {
  /// Return iterable region of whole tree-list
  Iterable<TaskListViewModel> getRange(int start, int end);

  /// Maps models to view-models
  Iterable<TaskListViewModel> map(Iterable<TaskListModelBase> models);

  int get length;
}