import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'file_data.dart';

class LevelOneCard extends HookWidget {
  final FileData fileData;
  const LevelOneCard(this.fileData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return levelOneCard();
  }

  Widget levelOneCard() {
    if (fileData.type == FileSystemEntityType.directory) {
      return HookBuilder(
        builder: (context) {
          useListenable(fileData.useDir);

          return Opacity(
            opacity: fileData.useDir.value ? 1 : .6,
            child: Stack(
              children: [
                Card(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: fileData.useDir.value
                            ? () =>
                                fileData.useDir.value = !fileData.useDir.value
                            : null,
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
                      const Divider(),
                      Row(
                        children: [
                          for (final sub in fileData.subs)
                            getFileCard(sub, fileData.useDir.value),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!fileData.useDir.value)
                  Positioned.fill(
                    child: InkWell(
                      onTap: () {
                        fileData.useDir.value = !fileData.useDir.value;
                      },
                      child: const Center(
                        child: Text(
                          'reuse',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: SizedBox(
              width: useDir ? 150 : 70,
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
