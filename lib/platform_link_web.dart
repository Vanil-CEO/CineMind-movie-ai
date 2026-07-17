// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

Future<bool> openExternalUrl(String url) async {
  html.window.open(url, '_blank', 'noopener,noreferrer');
  return true;
}

String? readLocalValue(String key) => html.window.localStorage[key];

void saveLocalValue(String key, String value) {
  html.window.localStorage[key] = value;
}

void removeLocalValue(String key) {
  html.window.localStorage.remove(key);
}
