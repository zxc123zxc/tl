import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';

class ToggleCardEvent extends TaskCardEvent {
  final bool isExpanded;

  ToggleCardEvent(TaskListModel model, this.isExpanded): super(model);
}