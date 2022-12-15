import 'package:pasell/Views/Categories/CategoriesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProductCategories ...', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CategoriesPage(),
    ));

    final categoriesTitleFinder = find.text('Categories');
    final arrowIconFinder = find.byIcon(Icons.arrow_back_ios_rounded);
    expect(categoriesTitleFinder, findsOneWidget);
    expect(arrowIconFinder, findsOneWidget);
  });

  testWidgets("Testing for Product Categories Page", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CategoriesPage(),
    ));

    final iconButton = find.byType(IconButton);
    expect(iconButton, findsOneWidget);
  });
}
