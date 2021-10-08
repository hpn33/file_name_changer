import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'file_data.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = useState(Manager()).value;

    useEffect(() {
      manager.init();
    }, []);

    return Material(
      color: Colors.grey,
      child: Column(
        children: [
          appBar(manager),
          detailView(manager),
        ],
      ),
    );
  }

  Expanded detailView(Manager manager) {
    useListenable(manager.assets);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (final i in manager.assets.value) levelOneCard(i),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar(Manager manager) {
    useListenable(manager.path);

    return Material(
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () {
              FilePicker.platform
                  .getDirectoryPath()
                  .then((value) => manager.setPath(value));
            },
          ),
          Center(child: Text(manager.path.value)),
          const Spacer(),
          ElevatedButton(
            onPressed: () => manager.changeFileNames(),
            child: const Text('run Process ( change file Name )'),
          ),
        ],
      ),
    );
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
      element.changeFileNameToFolderName();
    }

    _explorDir();
  }

  void init() => _explorDir();
}
