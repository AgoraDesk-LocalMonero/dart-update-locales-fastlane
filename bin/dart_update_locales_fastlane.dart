import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_2_files_json_to_arb/updater/update.dart';

Future<void> main(List<String> arguments) async {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addFlag(kTranslationsDir)
    ..addFlag(kFastlaneDir)
    ..addFlag(kFlavor)
    ..addFlag(kOS);

  ArgResults argResults = parser.parse(arguments);
  update(argResults);
}
