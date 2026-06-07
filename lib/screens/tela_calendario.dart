import "package:flutter/material.dart";
import "package:table_calendar/table_calendar.dart";
import "package:provider/provider.dart";
import "package:intl/intl.dart";
import "../providers/provedor_tarefas.dart";
import "../widgets/dialogo_adicionar_tarefa.dart";
import "tela_lista_tarefas.dart";

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // Abre o seletor de mês e ano
  void _showMonthYearPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text("Selecionar Mês e Ano", style: TextStyle(color: Colors.orangeAccent)),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Ano", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),        
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: List.generate(11, (index) {
                    int year = DateTime.now().year - 5 + index;
                    bool isSelected = _focusedDay.year == year;
                    return ChoiceChip(
                      label: Text(year.toString()),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _focusedDay = DateTime(year, _focusedDay.month, 1);
                        });
                        Navigator.pop(context);
                        _showMonthYearPicker(); // Reabre para selecionar o mês após mudar o ano
                      },
                      selectedColor: Colors.orangeAccent,
                      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
                    );
                  }),
                ),
                const Divider(color: Colors.white24, height: 30),
                const Text("Mês", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),        
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    String monthName = DateFormat("MMM", "pt_BR").format(DateTime(2022, index + 1));
                    bool isSelected = _focusedDay.month == index + 1;
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _focusedDay = DateTime(_focusedDay.year, index + 1, 1);
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.orangeAccent : Colors.white10,
                        foregroundColor: isSelected ? Colors.black : Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(monthName.toUpperCase()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Agenda", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.orangeAccent),
            onPressed: () => Navigator.pushNamed(context, "/monthly"),
            tooltip: "Tarefas do Mês",
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCustomHeader(),
          _buildCalendar(),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: TaskListScreen(selectedDate: _selectedDay ?? _focusedDay),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }

  // Cabeçalho personalizado com navegação de mês e ano
  Widget _buildCustomHeader() {
    String monthName = DateFormat("MMMM", "pt_BR").format(_focusedDay);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.orangeAccent),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
              });
            },
          ),
          GestureDetector(
            onTap: _showMonthYearPicker,
            child: Text(
              "${monthName.toUpperCase()} ${_focusedDay.year}",
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.orangeAccent),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
              });
            },
          ),
        ],
      ),
    );
  }

  // Widget do calendário
  Widget _buildCalendar() {
    return TableCalendar(
      locale: "pt_BR",
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2040, 12, 31),
      focusedDay: _focusedDay,
      headerVisible: false,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: Colors.white),
        weekendTextStyle: TextStyle(color: Colors.white60),
      ),
    );
  }

  // Mostra o diálogo para adicionar nova tarefa
  void _showAddTaskDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddTaskDialog(selectedDate: _selectedDay ?? _focusedDay),
    );

    if (result != null && result["title"] != null && mounted) {
      final String taskTitle = result["title"];
      context.read<TaskProvider>().addTask(
        taskTitle,
        _selectedDay ?? _focusedDay,
        result["time"],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tarefa " + taskTitle + " adicionada!"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }
}

