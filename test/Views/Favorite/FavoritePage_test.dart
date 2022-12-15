import 'package:pasell/Views/Favorite/FavoritePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FavoritePage ...', (tester) async {
    tester.pumpWidget(MaterialApp(
      home: Scaffold(body: FavoritePage()),
    ));

    find.byType(Stack);
  });
}
