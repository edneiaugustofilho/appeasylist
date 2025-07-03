
import 'package:appeasylist/models/checklist_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CreateChecklistScreen extends StatefulWidget {
  const CreateChecklistScreen({super.key});

  @override
  State<CreateChecklistScreen> createState() => _CreateChecklistScreenState();
}

class _CreateChecklistScreenState extends State<CreateChecklistScreen> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<TextEditingController> _itemControllers = [];

  void _addItemField() {
    setState(() {
      _itemControllers.add(TextEditingController());
    });
  }

  void _saveChecklist() {
    final title = _titleController.text.trim();
    if (title.isEmpty || _itemControllers.isEmpty) return;

    final items = _itemControllers
        .map((c) => ChecklistItem(description: c.text.trim()))
        .where((item) => item.description.isNotEmpty)
        .toList();

    if (items.isEmpty) return;

    final checklist = Checklist(title: title, date: _selectedDate, items: items);
    final box = Hive.box<Checklist>('checklists');
    box.add(checklist);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Lista'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título da lista'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Data selecionada: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const Divider(),
              const Text('Itens da lista', style: TextStyle(fontWeight: FontWeight.bold)),
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _itemControllers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: ValueKey(_itemControllers[index]),
                    title: TextField(
                      controller: _itemControllers[index],
                      decoration: const InputDecoration(hintText: 'Descrição do item'),
                    ),
                    trailing: const Icon(Icons.drag_handle),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = _itemControllers.removeAt(oldIndex);
                    _itemControllers.insert(newIndex, item);
                  });
                },
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _addItemField,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar item'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChecklist,
                child: const Text('Salvar Lista'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
