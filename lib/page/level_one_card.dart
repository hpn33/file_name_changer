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
                      topBar(),
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

  Widget topBar() {
    return InkWell(
      onTap: fileData.useDir.value
          ? () => fileData.useDir.value = !fileData.useDir.value
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  fileData.folderName,
                  style: fileData.useDir.value
                      ? null
                      : const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '* file count should be 2/' + fileData.subs.length.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        fileData.subs.length == 2 ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                HookBuilder(builder: (context) {
                  useListenable(fileData);

                  return Text(
                    '* just one file should be selected',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:
                          fileData.subs.where((e) => e.selected.value).length ==
                                  1
                              ? Colors.green
                              : Colors.grey,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getFileCard(FileData sub, bool useDir) {
    if (sub.passfix == 'jpg') {
      return HookBuilder(
        builder: (context) {
          useListenable(sub.selected);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
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
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
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
