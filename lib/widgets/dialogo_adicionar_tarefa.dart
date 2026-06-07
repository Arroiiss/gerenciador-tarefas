import "package:flutter/material.dart";

class AddTaskDialog extends StatefulWidget {
  final DateTime selectedDate;
  const AddTaskDialog({super.key, required this.selectedDate});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _controller = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.orangeAccent,
                onPrimary: Colors.black,
                surface: Color(0xFF1E1E1E),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Nova Tarefa", style: TextStyle(color: Colors.orangeAccent)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "O que precisa ser feito?",
              hintStyle: TextStyle(color: Colors.white38),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orangeAccent)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.orangeAccent),
              const SizedBox(width: 10),
              Text(
                "Hora: " + _selectedTime.hour.toString().padLeft(2, "0") + ":" + _selectedTime.minute.toString().padLeft(2, "0"),
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              TextButton(
                onPressed: _pickTime,
                child: const Text("ALTERAR", style: TextStyle(color: Colors.orangeAccent)),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCELAR", style: TextStyle(color: Colors.white60)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, {"title": _controller.text, "time": _selectedTime});
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
          child: const Text("ADICIONAR", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

