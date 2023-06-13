import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generators/app_generator.dart';
import 'generators/json_builder.dart';
import 'generators/use_case_resolver.dart';

/// Builder for the WidgetbookUseCase annotation.
/// Creates a .usecase.widgetbook.json file for each .dart file containing a
/// WidgetbookStory annotation
Builder useCaseBuilder(BuilderOptions options) {
  return JsonLibraryBuilder(
    UseCaseResolver(),
    generatedExtension: '.usecase.widgetbook.json',
    formatOutput: _formatOutput,
  );
}

/// Builder for the WidgetbookApp annotation.
/// Creates exactly one .g.dart file next to the file containing
/// the [App] annotation.
Builder appBuilder(BuilderOptions options) {
  const ignoredLintRules = {
    'unused_import',
    'prefer_relative_imports',
    'directives_ordering',
  };

  final headerParts = [
    '// coverage:ignore-file',
    '// ignore_for_file: type=lint',
    '// ignore_for_file: ${ignoredLintRules.join(", ")}',
    '\n$defaultFileHeader',
  ];

  return LibraryBuilder(
    AppGenerator(),
    generatedExtension: '.directories.g.dart',
    header: headerParts.join('\n'),
  );
}

/// Formats .json files generated by the builders above so that the files
/// become valid.
String _formatOutput(String input) {
  return input.replaceAll('\n]\n\n[\n', ',\n');
}
