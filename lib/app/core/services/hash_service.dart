import 'dart:math';

class HashService {
  static List<String> createds = [];

  static String get get {
    final hash = _getRandomString(25);
    if (createds.contains(hash)) {
      return HashService.get;
    } else {
      return hash;
    }
  }

  static String get getShort {
    final hash = _getRandomString(5);
    if (createds.contains(hash)) {
      return HashService.get;
    } else {
      return hash;
    }
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  static String _getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ),
  );
}
