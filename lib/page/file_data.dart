import 'dart:io';

class FileData {
  final FileSystemEntity entity;

  FileData(this.entity);

  FileSystemEntityType get type => entity.statSync().type;

  final subs = <FileData>[];

  void exploreSub() {
    final dir = Directory(entity.path);

    if (!dir.isAbsolute) {
      return;
    }

    dir.listSync().forEach((sub) {
      if (sub.statSync().type == FileSystemEntityType.file) {
        subs.add(FileData(sub));
      }
    });
  }

  void changeFileNameToFolderName() {
    var i = 0;

    for (final sub in subs) {
      final path = (sub.entity.path.split('\\')..removeLast()).join('\\');
      final folderName = entity.path.split('\\').last;
      final passfix = sub.entity.path.split('.').last;

      final newName = path + "\\" + folderName + '-$i' + '.' + passfix;

      sub.entity.renameSync(newName);

      i++;
    }
  }
}
