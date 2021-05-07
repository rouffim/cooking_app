import 'dart:io';

abstract class FilePersistence {
  Future<File> saveFile(String filename, String directory, String content);
  Future<bool> removeFile(String filename, String directory);
  Future<bool> removeAllFiles(String directory);
  Future<bool> isFileExisting(String filename, String directory);
  Future<String> readJsonFile(String filename, String directory);
  Future<String> readJsonFiles(String directory);
}