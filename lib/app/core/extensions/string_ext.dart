import 'package:aco_plus/app/core/components/archive/archive_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

extension StringExt on String {
  String get toCompare =>
      replaceAll(
        ' ',
        '',
      ).toLowerCase().removeSpecialCharacters().toNonDiacritics();

  String getInitials() {
    List<String> nameParts = split(' ');
    String initials = "";

    if (nameParts.isNotEmpty) {
      for (String part in nameParts) {
        if (part.isNotEmpty) {
          initials += part[0];
        }
      }
    }

    return initials.toUpperCase();
  }

  String get phone => replaceAll(
    ' ',
    '',
  ).replaceAll('-', '').replaceAll('(', '').replaceAll(')', '');

  String toFileName({String id = '', String type = ''}) =>
      (id.isNotEmpty ? '${id}_' : '') +
      toNonDiacritics().removeSpecialCharacters(excludes: '_') +
      (type.isNotEmpty ? '.$type' : '');

  String toNonDiacritics() {
    String diacritics =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    String nonDiacritics =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    return splitMapJoin(
      '',
      onNonMatch:
          (char) =>
              char.isNotEmpty && diacritics.contains(char)
                  ? nonDiacritics[diacritics.indexOf(char)]
                  : char,
    );
  }

  String removeSpecialCharacters({String excludes = ''}) {
    final specials =
        """`~!@#\\ \$%^&*()_-+={[}}|:;"'<,>.?/""".characters.toList();
    for (var e in excludes.characters.toList()) {
      specials.remove(e);
    }
    String name = '';
    for (var e in split('')) {
      if (!specials.contains(e)) {
        name += e;
      }
    }
    return name;
  }

  String toMoney() =>
      MoneyMaskedTextController(initialValue: double.parse(this)).text;

  String removeDecimal() => endsWith('.0') ? split('.').first : this;

  ArchiveType getArchiveTypeMimeType() {
    switch (this) {
      case 'application/pdf':
        return ArchiveType.pdf;
      case 'image/png':
        return ArchiveType.image;
      case 'image/jpg':
        return ArchiveType.image;
      case 'image/jpeg':
        return ArchiveType.image;
      case 'image/gif':
        return ArchiveType.image;
      case 'video/mp4':
        return ArchiveType.video;
      case 'video/mov':
        return ArchiveType.video;
      default:
        return ArchiveType.other;
    }
  }

  String getExtFromFirebaseURL() => split('?')[0].split('.').last;
}
