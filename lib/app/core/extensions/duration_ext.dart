extension DurationExt on Duration {
  String text() {
    if (inHours > 0) {
      return '${inHours}h${inMinutes % 60}m';
    }
    return '${inMinutes}m';
  }
}
