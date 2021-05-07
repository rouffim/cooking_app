import 'dart:convert';

import 'package:cool_cooker/core/persistence/api/file_persistence.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';

class FilePersistenceImpl extends FilePersistence {

  @override
  Future<File> saveFile(String filename, String directory, String content) async {
    final path = await getPathOfDirectory(directory);
    final file = File('$path/$filename');
    // Write the file.
    return file.writeAsString(content);
  }

  @override
  Future<bool> removeFile(String filename, String directory) async {
    final path = await getPathOfDirectory(directory);
    final file = File('$path/$filename');
    await file.delete();
    return true;
  }


  @override
  Future<bool> removeAllFiles(String directory) async {
    final dir = await getDirectory(directory);

    for(var file in await dir.list(recursive: false).toList()) {
      await file.delete();
    }

    return true;
  }

  @override
  Future<String> readJsonFile(String filename, String directory) async {
    final path = await getPathOfDirectory(directory);
    return readJsonFileFromPath('$path/$filename');
  }

  @override
  Future<String> readJsonFiles(String directory) async {
    final dir = await getDirectory(directory);
    final List<String> contents = new List();
    List<FileSystemEntity> dirContents = dir.listSync();
    dirContents.removeWhere((file) => file.path.split("/").last.startsWith('_'));

    for(var file in dirContents) {
      String content = await readJsonFileFromPath(file.path);
      if(StringUtils.isNotBlank(content)) {
        contents.add(content);
      }
    }

    return jsonEncode(contents);
  }

  @override
  Future<bool> isFileExisting(String filename, String directory) async {
    final path = await getPathOfDirectory(directory);
    return new File('$path/$filename').exists();
  }


  Future<String> readJsonFileFromPath(String path) async {
    return new File(path).readAsString();
  }

  Future<String> getPathOfDirectory(String directory) async {
    return (await getDirectory(directory)).path;
  }

  Future<Directory> getDirectory(String directory) async {
    final path = await _localPath;
    final String directoryPath = '$path/$directory';
    final dir = new Directory(directoryPath);

    if(!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

}