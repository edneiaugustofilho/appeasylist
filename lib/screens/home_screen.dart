import 'package:appeasylist/models/checklist_model.dart';
import 'package:appeasylist/screens/checklist_detail_screen.dart';
import 'package:appeasylist/screens/create_checklist_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Checklist> checklistBox;

  @override
  void initState() {
    super.initState();
    checklistBox = Hive.box<Checklist>('checklists');
  }

  void _createNewList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateChecklistScreen()),
    );
  }

  void _deleteList(int index) {
    checklistBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Listas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: checklistBox.listenable(),
        builder: (context, Box<Checklist> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('Nenhuma lista criada ainda.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final checklist = box.getAt(index)!;

              return Card(
                child: ListTile(
                  title: Text(checklist.title),
                  subtitle: Text(
                    'Data: ${checklist.date.day}/${checklist.date.month}/${checklist.date.year}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ChecklistDetailScreen(checklist: checklist),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteList(index),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewList,
        child: Icon(Icons.add),
      ),
    );
  }
}
