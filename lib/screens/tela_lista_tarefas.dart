import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/provedor_tarefas.dart";
import "../models/tarefa.dart";

class TaskListScreen extends StatelessWidget {
  final DateTime selectedDate;

  const TaskListScreen({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final allTasks = provider.getTasksForDate(selectedDate);

        final pendingTasks = allTasks.where((t) => !t.isCompleted).toList();
        pendingTasks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

        final completedTasks = allTasks.where((t) => t.isCompleted).toList();
        completedTasks.sort((a, b) => (a.completedAt ?? DateTime.now()).compareTo(b.completedAt ?? DateTime.now()));

        if (allTasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note, size: 80, color: Colors.white10),
                SizedBox(height: 20),
                Text(
                  "Nenhuma tarefa para este dia",
                  style: TextStyle(color: Colors.white38, fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            if (pendingTasks.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("PENDENTES", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
              ...pendingTasks.map((task) => _buildTaskItem(context, task, provider)),
            ],
            if (completedTasks.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("CONCLUÍDAS", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
              ...completedTasks.map((task) => _buildTaskItem(context, task, provider)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task, TaskProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: task.isCompleted ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: task.isCompleted ? Colors.transparent : Colors.orangeAccent.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: () => provider.toggleTaskStatus(task.id),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isCompleted ? Colors.orangeAccent : Colors.transparent,
              border: Border.all(color: Colors.orangeAccent, width: 2),
            ),
            child: task.isCompleted ? const Icon(Icons.check, size: 18, color: Colors.black) : null,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: task.isCompleted ? Colors.white38 : Colors.white,
            fontSize: 16,
            decoration: null,
          ),
        ),
        subtitle: Text(
          "Hora: " + task.time.hour.toString().padLeft(2, "0") + ":" + task.time.minute.toString().padLeft(2, "0"),
          style: TextStyle(color: task.isCompleted ? Colors.white24 : Colors.white54, fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
          onPressed: () => provider.deleteTask(task.id),
        ),
      ),
    );
  }
}

