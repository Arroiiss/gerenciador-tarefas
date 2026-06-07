import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_de_tarefas/providers/provedor_tarefas.dart';

void main() {
  group('Testes de Ordenação do TaskProvider', () {
    late TaskProvider provider;
    final today = DateTime.now();
    const time = TimeOfDay(hour: 10, minute: 0);

    setUp(() {
      provider = TaskProvider();
    });

    test('Tarefas devem ser ordenadas: Pendentes primeiro, depois Alfabética', () {
      provider.addTask('Zebra', today, time);
      provider.addTask('Abacaxi', today, time);
      provider.addTask('Banana', today, time);

      var tasks = provider.getTasksForDate(today);

      expect(tasks[0].title, 'Abacaxi');
      expect(tasks[1].title, 'Banana');
      expect(tasks[2].title, 'Zebra');

      provider.toggleTaskStatus(tasks[0].id);

      tasks = provider.getTasksForDate(today);

      expect(tasks[0].title, 'Banana');
      expect(tasks[1].title, 'Zebra');
      expect(tasks[2].title, 'Abacaxi');
      expect(tasks[2].isCompleted, true);
    });
  });
}
