import "package:flutter/material.dart";
import "../models/tarefa.dart";

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Busca as tarefas de uma data específica
  List<Task> getTasksForDate(DateTime date) {
    List<Task> filteredTasks = _tasks.where((task) {
      return task.date.year == date.year &&
             task.date.month == date.month &&
             task.date.day == date.day;
    }).toList();

    // Ordenação: Pendentes primeiro, depois concluídas. Ordem alfabética dentro dos grupos.
    filteredTasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return filteredTasks;
  }

  // Adiciona uma nova tarefa
  void addTask(String title, DateTime date, TimeOfDay time) {
    _tasks.add(Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      date: date,
      time: time,
    ));
    notifyListeners();
  }

  // Alterna o status da tarefa entre concluída e pendente
  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      if (_tasks[index].isCompleted) {
        _tasks[index].completedAt = DateTime.now();
      } else {
        _tasks[index].completedAt = null;
      }
      notifyListeners();
    }
  }

  // Exclui uma tarefa
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}

