import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:list/src/task_list/card_components/default/task/default_task_card.dart';
import 'package:list/src/task_list/card_components/narrow/task/narrow_task_card.dart';
import 'package:list/src/task_list/card_components/title_change_card_event.dart';
import 'package:list/src/task_list/card_components/toggle_card_event.dart';
import 'package:list/src/task_list/models/model_tree_manager/list_view.dart';
import 'package:list/src/task_list/card_type.dart';
import 'package:list/src/task_list/utils/viewport_models.dart';
import 'package:list/src/task_list/view_models/data_source/tree_view_model_data_source.dart';
import 'package:list/src/task_list/view_models/data_source/view_model_data_source.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

@Component(
  selector: 'task-list',
  styleUrls: const <String>['task_list_component.scss.css'],
  templateUrl: 'task_list_component.html',
  directives: const <Object>[
    CORE_DIRECTIVES,
    DefaultTaskCard,
    NarrowTaskCard,
    NgTemplateOutlet
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListComponent implements AfterViewInit, OnChanges {
  static const int _taskBatchSize = 40;

  final _toggleCtrl = new StreamController<ToggleCardEvent>(sync: true);

  final Element _hostElement;
  final ChangeDetectorRef _cdr;

  _ViewportElement _viewportElement;
  _ScrollWrapperElement _scrollWrapper;
  ViewportModels _viewportModels;
  ViewModelDataSource _dataSource;

  @Input() ListView dataSource;
  @Input() CardType cardType = CardType.Default;

  @Output() Stream<ToggleCardEvent> get cardToggle => _toggleCtrl.stream;

  @ViewChild('viewport') ElementRef viewportElRef;
  @ViewChild('wrapper') ElementRef wrapper;

  TaskListComponent(this._hostElement, this._cdr);


  Iterable<TaskListViewModel> get models => _viewportModels.models;

  bool get isDefaultCard => cardType == CardType.Default;

  bool get isNarrowCard => cardType == CardType.Narrow;


  void onToggle(ToggleCardEvent event) {
    _toggleCtrl.add(event);
    _viewportModels.refresh();
    _cdr.markForCheck();
    _cdr.detectChanges();
  }

  void onTitleChange(TitleChangeCardEvent event) {
    print('title changed: ${event.model}');
  }


  int trackFunction(int index, TaskListViewModel model) {
    return model.text.hashCode;
  }


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    if(changes.containsKey('dataSource')) {
      _init();
      final ds = changes['dataSource'].currentValue as ListView;
      final card = (changes.containsKey('cardType') ? changes['cardType'].currentValue : cardType) as CardType;

      _dataSource = new TreeViewModelDataSource(ds);

      _viewportModels = new ViewportModels(_taskBatchSize, _dataSource);
      _viewportModels.setViewportStart(0);

      //_viewportModels.setup(_dataSource);
      _viewportElement.setup(cardType, _taskBatchSize);
      _scrollWrapper.setup(_dataSource, card);


      // update scroll position
      _hostElement.scrollTop = 0;
    }

    if(changes.containsKey('cardType') && !changes.containsKey('dataSource')) {
      final cardType = changes['cardType'].currentValue as CardType;
      _scrollWrapper.setup(_dataSource, cardType);
    }
  }

  @override
  void ngAfterViewInit() {
    _hostElement.addEventListener('scroll', _handleScrollEvent);
  }


  _ScrollInfo _getIndexByScroll(int scrollPx) {
    final index = (scrollPx / cardType.taskCardHeight).floor();
    final rest = scrollPx % cardType.taskCardHeight;

    return new _ScrollInfo(index, rest);
  }

  void _handleScrollEvent(Event e) {
    final scrollTop = _hostElement.scrollTop;

    final scrollInfo = _getIndexByScroll(scrollTop);

    final vpAnchor = scrollTop - scrollInfo.rest;
    final vpModelIndex = scrollInfo.index;
    print('scrollInfo: $scrollInfo, vpAnch: $vpAnchor');

    _viewportElement.offset = vpAnchor;
    _viewportModels.setViewportStart(vpModelIndex);

    _cdr.markForCheck();
    _cdr.detectChanges();
  }

  void _init() {
    _viewportElement = new _ViewportElement(viewportElRef.nativeElement as Element);
    _scrollWrapper = new _ScrollWrapperElement(wrapper.nativeElement as Element);
    //_viewportModels = new ViewportModels(_taskBatchSize);
  }
}

class _ViewportElement {
  final Element _viewportElement;
  int _offset = 0;
  int _h = 0;

  _ViewportElement(this._viewportElement);


  void setup(CardType cardType, int tasksInVp) {
    _h = cardType.taskCardHeight * tasksInVp;
    offset = 0;
  }

  int get height => _h;

  int get offset => _offset;

  set offset(int value) {
    _offset = value;
    _viewportElement.style.transform = 'translate(0px, ${value}px)';
  }
}

class _ScrollWrapperElement {
  final Element _scrollWrapper;
  int _h = 0;

  _ScrollWrapperElement(this._scrollWrapper);


  int get height => _h;

  void setup(ViewModelDataSource dataSource, CardType cardType) {
    _h = dataSource.length * cardType.taskCardHeight;
    _scrollWrapper.style.height = '${_h}px';
  }
}

class _ScrollInfo {
  final int index;
  final int rest;

  _ScrollInfo(this.index, this.rest);

  @override
  String toString() => '$index + $rest px';
}