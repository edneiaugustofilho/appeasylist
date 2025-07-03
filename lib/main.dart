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

class MyEasyListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyEasyList',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
