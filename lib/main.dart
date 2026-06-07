import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:gerenciador_de_tarefas/providers/provedor_tarefas.dart";
import "package:gerenciador_de_tarefas/screens/tela_login.dart";
import "package:gerenciador_de_tarefas/screens/tela_calendario.dart";
import "package:gerenciador_de_tarefas/screens/tela_tarefas_mensais.dart";
import "package:flutter_localizations/flutter_localizations.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting("pt_BR", null).then((_) => runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const TaskVibeApp(),
    ),
  ));
}

class TaskVibeApp extends StatelessWidget {
  const TaskVibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gerenciador de Tarefas",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("pt", "BR"),
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orangeAccent,
          brightness: Brightness.dark,
          primary: Colors.orangeAccent,
          secondary: Colors.amberAccent,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white70),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        "/calendar": (context) => const CalendarScreen(),
        "/monthly": (context) => const MonthlyTasksScreen(),
      },
    );
  }
}

