import 'dart:io';

void main(List<String> args) {
  final filepath = args[0];
  final lines = File(filepath).readAsLinesSync();
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.contains('/* Pods_Runner.framework in Embed Frameworks */')) {
      lines.removeAt(i);
      i--;
    }
    if (line.contains('/* Embed Frameworks */')) {
      lines.removeAt(i);
      i--;
    }
    if (line.contains('/* Begin PBXCopyFilesBuildPhase section */')) {
      final startIndex = i;
      var endIndex = -1;
      for (var j = startIndex; j < lines.length; j++) {
        var currentLine = lines[j];
        if (currentLine.contains('/* End PBXCopyFilesBuildPhase section */')) {
          endIndex = j;
          break;
        }
      }
      lines.removeRange(startIndex, endIndex);
      i--;
    }
  }
  File(filepath).writeAsStringSync(lines.join('\n'));
}