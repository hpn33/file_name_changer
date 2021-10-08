import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'level_one_card.dart';
import 'manager.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = useState(Manager()).value;

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
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final i in manager.assets.value) LevelOneCard(i),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar(Manager manager) {
    useListenable(manager);
    print(manager.assets.value.where((element) => element.useDir.value).length);
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
          Text(
            manager.assets.value.length.toString() +
                '|' +
                manager.assets.value
                    .where((element) =>
                        element.useDir.value &&
                        element.hasConditionOfChangeName)
                    .length
                    .toString(),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => manager.changeFileNames(),
            child: const Text('run Process ( change file Name )'),
          ),
        ],
      ),
    );
  }
}
