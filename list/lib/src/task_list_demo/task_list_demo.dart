import 'package:angular/angular.dart';
import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/card_components/default/task/default_task_card.dart';
import 'package:list/src/task_list/models/model_tree_manager/model_tree_manager.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/models/task_model.dart';
import 'package:list/src/task_list/models/tree_view/tree_view.dart';
import 'package:list/src/task_list/task_list_component/task_list_component.dart';
import 'package:list/src/task_list/card_type.dart';

@Component(
    selector: 'task-list-demo',
    templateUrl: 'task_list_demo.html',
    styleUrls: const <String>['task_list_demo.css'],
    directives: const <Object>[
      CORE_DIRECTIVES,
      DefaultTaskCard,
      TaskListComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListDemo {
  ModelTreeManager _treeManager;

  TreeView treeView;
  CardType cardType;

  TaskListDemo() {
    final tree = new LinkedTree<TaskListModelBase>();
    for(int i = 0; i < 5; ++i) {
      final task = new TaskModel('$i');
      task.isExpanded = true;

      for(int j = 0; j < 5; ++j) {
        final subTask = new TaskModel('$i ; $j');
        task.addChild(subTask);
      }

      tree.addFirst(task);
    }
    _treeManager = new ModelTreeManager(tree);

    treeView = _treeManager.getTreeView();
    cardType = CardType.Default;
  }

  void changeDataSource() {
//    final list = new List<TaskListViewModel>();
//    for(var i = 0; i < 100; ++i) {
//      list.add(new TaskListViewModel('!!!: $i'));
//    }
//
//    dataSource = new InMemoryViewModelDataSource(list);
  }

  void changeCardType() {
    if(cardType == CardType.Default) {
      cardType = CardType.Narrow;
    } else {
      cardType = CardType.Default;
    }
  }
}