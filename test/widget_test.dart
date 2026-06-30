import 'package:arilatiahflutter1/model35/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows login form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Masuk ke akun Anda'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });
}
