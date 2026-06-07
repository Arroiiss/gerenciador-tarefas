import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:intl/intl.dart";
import "../providers/provedor_tarefas.dart";
import "../models/tarefa.dart";

class MonthlyTasksScreen extends StatelessWidget {
  const MonthlyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarefas do Mês", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final now = DateTime.now();
          final monthlyTasks = provider.tasks.where((task) {
            return task.date.month == now.month && task.date.year == now.year;
          }).toList();

          if (monthlyTasks.isEmpty) {
            return const Center(
              child: Text(
                "Nenhuma tarefa este mês",
                style: TextStyle(color: Colors.white38, fontSize: 18),
              ),
            );
          }

          final pending = monthlyTasks.where((t) => !t.isCompleted).toList();
          final completed = monthlyTasks.where((t) => t.isCompleted).toList();

          // Ordena pendentes por data de adição
          pending.sort((a, b) => a.date.compareTo(b.date));
          // Ordena concluídas por data de conclusão
          completed.sort((a, b) => (a.completedAt ?? DateTime.now()).compareTo(b.completedAt ?? DateTime.now()));

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (pending.isNotEmpty) ...[
                const _SectionHeader(title: "PENDENTES (Data de Adição)"),
                ...pending.map((t) => _TaskTile(task: t, isPending: true)),
              ],
              const SizedBox(height: 20),
              if (completed.isNotEmpty) ...[
                const _SectionHeader(title: "CONCLUÍDAS (Data de Conclusão)"),
                ...completed.map((t) => _TaskTile(task: t, isPending: false)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.orangeAccent,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final bool isPending;
  const _TaskTile({required this.task, required this.isPending});

  @override
  Widget build(BuildContext context) {
    final dateStr = isPending
      ? DateFormat("dd/MM/yyyy").format(task.date)
      : (task.completedAt != null ? DateFormat("dd/MM/yyyy").format(task.completedAt!) : "---");

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: isPending ? Colors.white : Colors.white60,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isPending ? "Adicionada em: $dateStr" : "Concluída em: $dateStr",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            isPending ? Icons.pending_actions : Icons.check_circle,
            color: isPending ? Colors.amber : Colors.greenAccent,
          ),
        ],
      ),
    );
  }
}

