import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

///
/// app.apple-app-store-keywords.localmonero
/// app.apple-app-store-keywords.agoradesk
/// app.google-play-store-description.localmonero
/// app.google-play-store-title.localmonero
/// app.apple-app-store-description.localmonero
/// app.apple-app-store-title.localmonero
///

const kTranslationsDir = 'stringsDir';
const kFastlaneDir = 'updatedDir';
const kFlavor = 'flavor';

void update(ArgResults argResults) async {
  List<String> args = argResults.rest;
  final flavor = args[2];

  stderr.writeln('working directory - ${argResults.arguments}');
  if (args.isEmpty) {
    _printErrors(ErrorType.noParameters);
  } else {
    final List<FileSystemEntity> translationsFiles = await _dirContents(Directory(args[0]));
    final List<FileSystemEntity> fastlaneFiles = await _dirContents(Directory(args[1]));
    final List<Directory> fastlaneDirs = fastlaneFiles.whereType<Directory>().toList();
    final List<String> fastlaneDirsPaths = fastlaneDirs.map((e) => e.path).toList();

    for (final dirName in _dirNameFileName.keys) {
      print('++++++++++++++++++++++++++++1 ${_dirNameFileName[dirName]}');
      final pathToTranslationFile =
          translationsFiles.firstWhere((e) => e.path.split('/').last == _dirNameFileName[dirName]).path;

      print('++++++++++++++++++++++++++++2');
      final Map<String, dynamic> translationsMap = await _readFileAsMap(pathToTranslationFile);


      final dirPath = '${Directory(args[1]).path}/$dirName';
      print('++++++++++++++++++++++++++++3 - $kFlavor');
      final Map<String, String> fileNameTranslatedString;

      if (flavor == 'agoradesk') {
        fileNameTranslatedString = _fileNameTranslatedStringAD;
      } else {
        fileNameTranslatedString = _fileNameTranslatedStringLM;
      }
      for (final filename in fileNameTranslatedString.keys) {
        String translatedStr = translationsMap[fileNameTranslatedString[filename]];
        await _writeToFile(content: translatedStr, path: '$dirPath/$filename');
      }
    }
  }
}

Future<List<FileSystemEntity>> _dirContents(Directory dir) {
  var files = <FileSystemEntity>[];
  var completer = Completer<List<FileSystemEntity>>();
  var lister = dir.list(recursive: false);
  lister.listen((file) => files.add(file), onDone: () => completer.complete(files));
  return completer.future;
}

enum ErrorType { noParameters, noFiles }

Future<String> _readFileAsString(String filePath) async {
  final content = await File(filePath).readAsString();
  return content;
}

Future<Map<String, dynamic>> _readFileAsMap(String filePath) async {
  final input = await File(filePath).readAsString();
  final map = jsonDecode(input);
  return map;
}

Future _writeToFile({
  required String content,
  required String path,
}) async {
  print('>>>>>>> $path');
  final f = await File(path).create(recursive: true);
  await f.writeAsString(content);
}

void _printErrors(ErrorType type) {
  switch (type) {
    case ErrorType.noParameters:
      stderr.writeln('''
    Error - no or wrong parameters. 
    Please input parameters:
      --jsonToArb or --arbToJson
      --path "path_to_the_directory_with_files"
    ''');
      break;

    case ErrorType.noFiles:
      stderr.writeln('''
    Error - no files in the given directory. 
    Please input parameters:
      --jsonToArb or --arbToJson
      --path "path_to_the_directory_with_files"
    ''');
      break;
  }
}

final Map<String, String> _dirNameFileName = {
  'default': 'app_en.arb',
  'ar-SA': 'app_ar.arb',
  'cs': 'app_cs.arb',
  'de-DE': 'app_de.arb',
  'en-US': 'app_en.arb',
  'es-ES': 'app_es.arb',
  'fr-FR': 'app_fr.arb',
  'hu': 'app_hu.arb',
  'it': 'app_it.arb',
  'ja': 'app_ja.arb',
  'ko': 'app_ko.arb',
  'nl-NL': 'app_nl.arb',
  'pl': 'app_pl.arb',
  'pt-BR': 'app_pt-br.arb',
  'ro': 'app_ro.arb',
  'ru': 'app_ru.arb',
  // 'sk': 'app_sk.arb',
  // 'sv': 'app_sv.arb',
  'tr': 'app_tr.arb',
  // 'zh-Hans': 'app_zh-cn.arb',
  'zh-Hant': 'app_zh-tw.arb',
};

final Map<String, String> _fileNameTranslatedStringAD = {
  'description.txt': "app250Sbapple8722Sbapp8722Sbstore8722Sbdescription250Sbagoradesk",
  'name.txt': "app250Sbapple8722Sbapp8722Sbstore8722Sbtitle250Sbagoradesk",
};
final Map<String, String> _fileNameTranslatedStringLM = {
  'description.txt': "app250Sbapple8722Sbapp8722Sbstore8722Sbdescription250Sblocalmonero",
  'name.txt': "app250Sbapple8722Sbapp8722Sbstore8722Sbtitle250Sblocalmonero",
};
