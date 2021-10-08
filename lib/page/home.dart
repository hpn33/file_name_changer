import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'file_data.dart';
import 'manager.dart';

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
      return HookBuilder(
        builder: (context) {
          useListenable(fileData.useDir);

          return Column(
            children: [
              Card(
                child: InkWell(
                  onTap: () {
                    fileData.useDir.value = !fileData.useDir.value;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          fileData.entity.path.toString(),
                          style: fileData.useDir.value
                              ? null
                              : const TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (final sub in fileData.subs)
                    Opacity(
                      opacity: fileData.useDir.value ? 1 : .3,
                      child: getFileCard(sub, fileData.useDir.value),
                    ),
                ],
              ),
            ],
          );
        },
      );
    }

    return Text(fileData.entity.toString());
  }

  Widget getFileCard(FileData sub, bool useDir) {
    if (sub.passfix == 'jpg') {
      return HookBuilder(
        builder: (context) {
          useListenable(sub.selected);

          return Card(
            margin: const EdgeInsets.all(8),
            child: SizedBox(
              width: 150,
              child: InkWell(
                onTap: useDir
                    ? () => sub.selected.value = !sub.selected.value
                    : null,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Image.file(File(sub.entity.path)),
                        Text(sub.name),
                      ],
                    ),
                    if (sub.selected.value)
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          width: 10,
                          height: 10,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: SizedBox(
        width: 150,
        child: Text(sub.name),
      ),
    );
  }
}
