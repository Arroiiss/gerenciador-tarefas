import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gerenciador_de_tarefas/main.dart';
import 'package:gerenciador_de_tarefas/providers/provedor_tarefas.dart';

void main() {
  testWidgets('Teste básico da tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TaskProvider()),
        ],
        child: const TaskVibeApp(),
      ),
    );

    expect(find.text('Seja bem-vindo!'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);

    await tester.tap(find.text('Realize seu cadastro'));
    await tester.pump();

    expect(find.text('Realize seu cadastro'), findsOneWidget);
    expect(find.text('CADASTRAR'), findsOneWidget);
  });
}
