import 'package:list/src/task_list/models/list_view/list_view_impl.dart';
import 'package:list/src/task_list/models/task_model.dart';
import 'package:list/src/task_list/task_list_component/utils/viewport_models_list.dart';
import 'package:test/test.dart';

void main() {
  List<TaskModel> createModels(int length) {
    final list = new List<TaskModel>();
    for(int i = 0; i < length; ++i) {
      final vm = new TaskModel(i.toString());
      list.add(vm);
    }

    return list;
  }

  group('ViewportModels tests', () {
    test('#setViewport() ', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      viewport.setViewport(25, 30);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['25', '26', '27', '28', '29']));
    });

    test('#takeFrontWhile() ', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      viewport.setViewport(25, 30);
      int count = 3;
      viewport.takeFrontWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['25', '26', '27', '28', '29', '30', '31', '32']));
    });

    test('#takeBackWhile() ', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      viewport.setViewport(25, 30);
      int count = 3;
      viewport.takeBackWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['22', '23', '24', '25', '26', '27', '28', '29']));
    });

    test('#removeFrontWhile() ', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      viewport.setViewport(25, 30);
      int count = 3;
      viewport.removeFrontWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['25', '26']));
    });

    test('#removeBackWhile() ', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      viewport.setViewport(25, 30);
      int count = 3;
      viewport.removeBackWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['28', '29']));
    });

  });

  group('ViewportModels inner state validation tests', () {
    test('#takeFrontWhile() from initial state ', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      int count = 3;
      viewport.takeFrontWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['0', '1', '2']));
    });

    test('#takeFrontWhile() from initial state take twice', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      int count = 3;
      viewport.takeFrontWhile((i) => count-- > 0);

      count = 3;
      viewport.takeFrontWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['0', '1', '2', '3', '4', '5']));
    });

    test('#takeFrontWhile() from initial state take 6 items, then remove back 3', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      int count = 6;
      viewport.takeFrontWhile((i) => count-- > 0);

      count = 3;
      viewport.removeBackWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['3', '4', '5']));
    });

    test('#takeFrontWhile() from initial state take 6, then remove first 3', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      int count = 6;
      viewport.takeFrontWhile((i) => count-- > 0);

      count = 3;
      viewport.removeFrontWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['0', '1', '2']));
    });

    test('#takeFrontWhile() from initial state take twice', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      int count = 6;
      viewport.takeFrontWhile((i) => count-- > 0);

      count = 3;
      viewport.removeBackWhile((i) => count-- > 0);

      count = 2;
      viewport.takeBackWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['1', '2', '3', '4', '5']));
    });

    test('#takeFrontWhile() from initial state take until start', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      final viewport = new ViewportModelsList(listView);

      int count = 6;
      viewport.takeFrontWhile((i) => count-- > 0);

      count = 3;
      viewport.removeBackWhile((i) => count-- > 0);

      count = 2;
      viewport.takeBackWhile((i) => count-- > 0);

      count = 2;
      viewport.takeBackWhile((i) => count-- > 0);

      final strings = viewport.models.map((i) => (i as TaskModel).task as String).toList();
      expect(strings, orderedEquals(const ['0', '1', '2', '3', '4', '5']));
    });

  });

}