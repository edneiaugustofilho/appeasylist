import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/checklist_model.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive
  await Hive.initFlutter();

  // Registra os modelos (Checklist e ChecklistItem)
  Hive.registerAdapter(ChecklistAdapter());
  Hive.registerAdapter(ChecklistItemAdapter());

  // Abre a box principal onde as listas serão armazenadas
  await Hive.openBox<Checklist>('checklists');

  runApp(MyEasyListApp());
}

class MyEasyListApp extends StatefulWidget {
  @override
  State<MyEasyListApp> createState() => _MyEasyListAppState();
}

class _MyEasyListAppState extends State<MyEasyListApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyEasyList',
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        themeMode: _themeMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
