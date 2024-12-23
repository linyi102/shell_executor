import 'dart:convert';
import 'dart:io';

import 'package:shell_executor/src/utils/colorful_string.dart';

Future<ProcessResult> $(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  Map<String, String>? environment,
}) async {
  stdout.writeln('\n${DateTime.now()}'.green());
  stdout.writeln('> $executable ${arguments.join(' ')}');
  final result = await ShellExecutor.global.exec(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    environment: environment,
    runInShell: true,
  );
  if (result.exitCode != 0) {
    stderr.writeln('\nCommand exited with non-zero exit code'.red());
    exit(1);
  }
  return result;
}

class ShellExecutor {
  static ShellExecutor global = ShellExecutor();

  Future<ProcessResult> exec(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool runInShell = false,
  }) async {
    final Process process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: runInShell,
    );

    String? stdoutStr;
    String? stderrStr;

    process.stdout.listen((event) {
      String msg = _convertToString(event);
      stdoutStr = '${stdoutStr ?? ''}$msg';
      stdout.write(msg);
    });
    process.stderr.listen((event) {
      String msg = _convertToString(event);
      stderrStr = '${stderrStr ?? ''}$msg';
      stderr.write(msg.red());
    });
    int exitCode = await process.exitCode;
    return ProcessResult(process.pid, exitCode, stdoutStr, stderrStr);
  }

  String _convertToString(List<int> bytes) {
    return utf8.decode(bytes, allowMalformed: true);
  }

  ProcessResult execSync(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool runInShell = false,
  }) {
    final ProcessResult processResult = Process.runSync(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: runInShell,
    );
    return processResult;
  }
}
