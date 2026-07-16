import 'package:cinemind/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CineMind shows the authentication screen', (tester) async {
    await tester.pumpWidget(const CineMindApp());

    expect(find.text('CineMind'), findsOneWidget);
    expect(find.byType(EditableText), findsNWidgets(2));
  });
}
