import 'dart:io';

import 'package:flutter/foundation.dart';

import 'file_data.dart';

class Manager extends ChangeNotifier {
  final path = ValueNotifier('.');
  final assets = ValueNotifier(<FileData>[]);

  int get countOfAll => assets.value.length;
  int get countOfCondida => assets.value
      .where(
          (element) => element.useDir.value && element.hasConditionOfChangeName)
      .length;

  Manager() {
    path.addListener(_explorDir);

    _explorDir();
  }

  void _explorDir() {
    assets.value = [];

    final dir = Directory(path.value);

    dir.listSync().forEach((i) {
      assets.value = [...assets.value, FileData(i, this)..exploreSub()];
    });
  }

  void setPath(String? pth) {
    if (pth != null) {
      path.value = pth;
    }
  }

  void changeFileNames() {
    for (var element in assets.value) {
      element.changeFileNameToFolderName();
    }
  }

  void selectAll() {
    for (var element in assets.value) {
      element.useDir.value = true;
    }
  }

  void deselectAll() {
    for (var element in assets.value) {
      element.useDir.value = false;
    }
  }
}
