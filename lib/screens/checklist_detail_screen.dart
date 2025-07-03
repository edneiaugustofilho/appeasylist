import 'package:appeasylist/models/checklist_model.dart';
import 'package:flutter/material.dart';

class ChecklistDetailScreen extends StatefulWidget {
  final Checklist checklist;

  const ChecklistDetailScreen({required this.checklist, super.key});

  @override
  State<ChecklistDetailScreen> createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  late Checklist checklist;

  @override
  void initState() {
    super.initState();
    checklist = widget.checklist;
  }

  void _toggleItemDone(int index, bool? value) {
    setState(() {
      checklist.items[index].isDone = value ?? false;
      checklist.save(); // atualiza no Hive
    });
  }

  Future<void> _editTitle() async {
    final controller = TextEditingController(text: checklist.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Editar título'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Digite o novo título'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: Text('Salvar'),
              ),
            ],
          ),
    );

    if (newTitle != null && newTitle.isNotEmpty) {
      setState(() {
        checklist.title = newTitle;
        checklist.save();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(checklist.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editTitle,
            tooltip: 'Editar título',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReorderableListView.builder(
          itemCount: checklist.items.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = checklist.items.removeAt(oldIndex);
              checklist.items.insert(newIndex, item);
              checklist.save();
            });
          },
          itemBuilder: (context, index) {
            final item = checklist.items[index];
            return CheckboxListTile(
              key: ValueKey(item.description + index.toString()),
              title: Text(item.description),
              value: item.isDone,
              onChanged: (value) => _toggleItemDone(index, value),
            );
          },
        ),
      ),
    );
  }
}
