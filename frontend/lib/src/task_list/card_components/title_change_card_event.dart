import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';

class TitleChangeCardEvent extends TaskCardEvent {
  final String title;

  TitleChangeCardEvent(TaskListModel model, this.title): super(model);
}