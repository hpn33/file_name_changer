import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final path = useState('.');
    final assets = useState(<FileData>[]);

    useEffect(() {
      getAssetsOnDirect(path.value, assets);
    }, []);

    return Material(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.folder_open),
                onPressed: () {
                  // FilePicker.platform
                  //     .pickFiles()
                  //     .then((value) => path.value = value!.files.toString());

                  FilePicker.platform.getDirectoryPath().then((value) {
                    path.value = value ?? '.';

                    getAssetsOnDirect(path.value, assets);
                  });
                },
              ),
              Center(child: Text(path.value)),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final i in assets.value) levelOneCard(i),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getAssetsOnDirect(
    String path,
    ValueNotifier<List<FileData>> assets,
  ) {
    assets.value = [];

    final dir = Directory(path);

    dir.listSync().forEach((i) {
      assets.value = [...assets.value, FileData(i)..exploreSub()];
    });
  }

  Widget levelOneCard(FileData fileData) {
    if (fileData.type == FileSystemEntityType.directory) {
      return Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [Text(fileData.entity.path.toString())],
              ),
            ),
          ),
          Row(
            children: [
              for (final sub in fileData.subs)
                Card(
                  margin: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 150,
                    child: Text(sub.entity.toString()),
                  ),
                ),
            ],
          ),
        ],
      );
    }

    return Text(fileData.entity.toString());
  }
}

class FileData {
  final FileSystemEntity entity;

  FileData(this.entity);

  FileSystemEntityType get type => entity.statSync().type;

  final subs = <FileData>[];

  void exploreSub() {
    final dir = Directory(entity.path);

    dir.listSync().forEach((i) {
      if (i.statSync().type == FileSystemEntityType.file) subs.add(FileData(i));
    });
  }
}
