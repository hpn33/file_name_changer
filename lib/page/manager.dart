import 'dart:io';

import 'package:flutter/foundation.dart';

import 'file_data.dart';

class Manager {
  final path = ValueNotifier('.');
  final assets = ValueNotifier(<FileData>[]);

  Manager() {
    path.addListener(_explorDir);
  }

  void _explorDir() {
    assets.value = [];

    final dir = Directory(path.value);

    dir.listSync().forEach((i) {
      assets.value = [...assets.value, FileData(i)..exploreSub()];
    });
  }

  void setPath(String? pth) {
    if (pth != null) {
      path.value = pth;
    }
  }

  void changeFileNames() {
    for (var element in assets.value) {
      if (element.subs.length != 2 &&
          element.subs.where((element) => element.selected.value).length != 1) {
        continue;
      }

      element.changeFileNameToFolderName();
    }

    _explorDir();
  }

  void init() => _explorDir();
}
