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
const kOS = 'os';

void update(ArgResults argResults) async {
  List<String> args = argResults.rest;
  final flavor = args[2];
  final os = args[3];

  stderr.writeln('working directory - ${argResults.arguments}');
  if (args.isEmpty) {
    _printErrors(ErrorType.noParameters);
  } else {
    final List<FileSystemEntity> translationsFiles = await _dirContents(Directory(args[0]));
    final List<FileSystemEntity> fastlaneFiles = await _dirContents(Directory(args[1]));
    final List<Directory> fastlaneDirs = fastlaneFiles.whereType<Directory>().toList();
    final List<String> fastlaneDirsPaths = fastlaneDirs.map((e) => e.path).toList();

    for (final dirName in _dirNameFileName.keys) {
      final pathToTranslationFile =
          translationsFiles.firstWhere((e) => e.path.split('/').last == _dirNameFileName[dirName]).path;

      final Map<String, dynamic> translationsMap = await _readFileAsMap(pathToTranslationFile);

      final dirPath = '${Directory(args[1]).path}/$dirName';
      final Map<String, String> fileNameTranslatedString;

      if (flavor == 'agoradesk') {
        if (os == 'ios') {
          fileNameTranslatedString = _fileNameTranslatedStringAdIos;
        } else {
          fileNameTranslatedString = _fileNameTranslatedStringAdAndroid;
        }
      } else {
        if (os == 'ios') {
          fileNameTranslatedString = _fileNameTranslatedStringLmIos;
        } else {
          fileNameTranslatedString = _fileNameTranslatedStringLmAndroid;
        }
      }
      for (final filename in fileNameTranslatedString.keys) {
        try {
          String translatedStr = translationsMap[fileNameTranslatedString[filename]];
          await _writeToFile(content: translatedStr, path: '$dirPath/$filename');
        } catch (e) {
          print(
              '[+++error - translation string missing] - ${fileNameTranslatedString[filename]} in the file $pathToTranslationFile');
        }
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

final Map<String, String> _fileNameTranslatedStringAdIos = {
  'description.txt': "app250Sbapple8722Sbapp8722Sbstore8722Sbdescription250Sbagoradesk",
  'name.txt': "app250Sbapple8722Sbapp8722Sbstore8722Sbtitle250Sbagoradesk",
  'subtitle.txt': "app_apple_app_store_subtitle_agoradesk",
};
final Map<String, String> _fileNameTranslatedStringLmIos = {
  'description.txt': "app250Sbapple8722Sbapp8722Sbstore8722Sbdescription250Sblocalmonero",
  'name.txt': "app250Sbapple8722Sbapp8722Sbstore8722Sbtitle250Sblocalmonero",
  'subtitle.txt': "app_apple_app_store_subtitle_localmonero",
};
final Map<String, String> _fileNameTranslatedStringAdAndroid = {
  'full_description.txt': "app250Sbgoogle8722Sbplay8722Sbstore8722Sbdescription250Sbagoradesk",
  'title.txt': "app250Sbgoogle8722Sbplay8722Sbstore8722Sbtitle250Sbagoradesk",
  'short_description.txt': "app_google_play_store_short_description_agoradesk",
};
final Map<String, String> _fileNameTranslatedStringLmAndroid = {
  'full_description.txt': "app250Sbgoogle8722Sbplay8722Sbstore8722Sbdescription250Sblocalmonero",
  'title.txt': "app250Sbgoogle8722Sbplay8722Sbstore8722Sbtitle250Sblocalmonero",
  'short_description.txt': "app_google_play_store_short_description_localmonero",
};

