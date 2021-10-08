import 'dart:io';

import 'package:flutter/foundation.dart';

class FileData extends ChangeNotifier {
  final FileSystemEntity entity;
  final FileData? parent;

  FileData(this.entity, {this.parent}) {
    selected.addListener(() {
      if (parent != null) {
        parent?.notifyListeners();
      }
    });
  }

  FileSystemEntityType get type => entity.statSync().type;
  String get name => entity.path.split('\\').last;
  String get folderName => '\\' + entity.path.split('\\').last;
  String get passfix => entity.path.split('.').last;

  bool get hasJustTwoSub => subs.length == 2;
  bool get hasJustOneSelected =>
      subs.where((element) => element.selected.value).length == 1;

  bool get hasConditionOfChangeName => hasJustTwoSub && hasJustOneSelected;

  final subs = <FileData>[];
  final selected = ValueNotifier(false);
  final useDir = ValueNotifier(true);

  void exploreSub() {
    subs.clear();

    final dir = Directory(entity.path);

    if (!dir.isAbsolute) {
      return;
    }

    dir.listSync().forEach((sub) {
      if (sub.statSync().type == FileSystemEntityType.file) {
        subs.add(FileData(sub, parent: this));
      }
    });

    notifyListeners();
  }

  void changeFileNameToFolderName() {
    if (!useDir.value || !hasConditionOfChangeName) {
      return;
    }

    for (final sub in subs) {
      final path = (sub.entity.path.split('\\')..removeLast()).join('\\');
      final folderName = entity.path.split('\\').last;
      final passfix = sub.entity.path.split('.').last;

      final newName = path +
          "\\" +
          (sub.selected.value ? 'c' : '') +
          folderName +
          '.' +
          passfix;

      sub.entity.renameSync(newName);
    }

    exploreSub();
  }
}
