import 'dart:async';

import 'package:angular/angular.dart';
import 'package:frontend/src/mvp_notes/note_list/note_model.dart';


@Component(
  selector: 'note-card',
  styleUrls: const <String>['note_card.css'],
  templateUrl: 'note_card.html',
  directives: const <Object>[],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class NoteCardComponent {
  final _clickCtrl = new StreamController<NoteModel>(sync: true);
  final _deleteClickCtrl = new StreamController<NoteModel>(sync: true);

  bool showIcons = false;

  @Input() NoteModel model;

  @Output() Stream<NoteModel> get cardClick => _clickCtrl.stream;
  @Output() Stream<NoteModel> get deleteClick => _deleteClickCtrl.stream;

  @HostListener('click')
  void onClick() => _clickCtrl.add(model);

  @HostListener('mouseenter')
  void onMouseEnter() => showIcons = true;

  @HostListener('mouseleave')
  void onMouseLeave() => showIcons = false;

  void onDeleteBtnClick() => _deleteClickCtrl.add(model);
}