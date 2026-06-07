import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/task.dart';
import 'widgets/task_tile.dart';
import 'widgets/categories.dart';
import 'widgets/bottom_navigation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Task> _tasks = [];
  String _selectedCategory = 'All';

  static const List<String> _categoryOptions = [
    'Work',
    'Personal',
    'Wishlist',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson) as List<dynamic>;
      setState(() {
        _tasks = decoded
            .map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'tasks',
      jsonEncode(_tasks.map((t) => t.toJson()).toList()),
    );
  }

  List<Task> get _filteredTasks {
    if (_selectedCategory == 'All') return _tasks;
    return _tasks.where((t) => t.category == _selectedCategory).toList();
  }

  Map<String, List<Task>> get _groupedTasks {
    final Map<String, List<Task>> grouped = {};
    for (final task in _filteredTasks) {
      grouped.putIfAbsent(task.category, () => []).add(task);
    }
    return grouped;
  }

  void _addTask(String name, String category) {
    setState(() {
      _tasks.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        category: category,
      ));
    });
    _saveTasks();
  }

  void _editTask(String id, String name, String category) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.name = name;
      task.category = category;
    });
    _saveTasks();
  }

  void _deleteTask(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _tasks.removeWhere((t) => t.id == id));
              _saveTasks();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleTask(String id, bool value) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = value;
    });
    _saveTasks();
  }

  void _showTaskDialog({Task? task}) {
    final nameController = TextEditingController(text: task?.name ?? '');
    String selectedCategory = task?.category ?? _categoryOptions.first;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.task_alt,
                            color: Colors.deepPurple, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        task == null ? 'Add New Task' : 'Edit Task',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      hintText: 'What do you need to do?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.edit_note,
                          color: Colors.deepPurple),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter a task name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.label_outline,
                          color: Colors.deepPurple),
                    ),
                    items: _categoryOptions
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _categoryColor(c),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(c),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => selectedCategory = v);
                      }
                    },
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Colors.deepPurple),
                          ),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.deepPurple)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (task == null) {
                                _addTask(nameController.text.trim(),
                                    selectedCategory);
                              } else {
                                _editTask(task.id,
                                    nameController.text.trim(), selectedCategory);
                              }
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            task == null ? 'Add Task' : 'Update',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.blue;
      case 'Personal':
        return Colors.green;
      case 'Wishlist':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTasks;
    final completedCount = filtered.where((t) => t.isCompleted).length;
    final totalCount = filtered.length;
    final grouped = _groupedTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$completedCount/$totalCount done',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar + category filter — attached to app bar
          Container(
            color: Colors.deepPurple,
            child: Column(
              children: [
                if (totalCount > 0)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: completedCount / totalCount,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 5,
                      ),
                    ),
                  ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F0FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: TaskCategories(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (cat) {
                      setState(() => _selectedCategory = cat);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Task list
          Expanded(
            child: totalCount == 0
                ? _buildEmptyState()
                : _buildTaskList(grouped),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskDialog(),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Task',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 1,
        onTap: (_) {},
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rounded,
            size: 90,
            color: Colors.deepPurple.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            _tasks.isEmpty ? 'No tasks yet' : 'No $_selectedCategory tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _tasks.isEmpty
                ? 'Tap Add Task to get started'
                : 'Add a task to this category',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(Map<String, List<Task>> grouped) {
    if (_selectedCategory == 'All') {
      final List<dynamic> items = [];
      for (final entry in grouped.entries) {
        items.add(entry.key);
        items.addAll(entry.value);
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item is String) {
            return _buildCategoryHeader(item, grouped[item]!);
          }
          return _buildTaskTile(item as Task);
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: _filteredTasks.length,
      itemBuilder: (context, index) => _buildTaskTile(_filteredTasks[index]),
    );
  }

  Widget _buildCategoryHeader(String category, List<Task> tasks) {
    final completed = tasks.where((t) => t.isCompleted).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: _categoryColor(category),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            category,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$completed/${tasks.length}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(Task task) {
    return TaskTile(
      task: task,
      onEdit: () => _showTaskDialog(task: task),
      onDelete: () => _deleteTask(task.id),
      onToggle: (v) => _toggleTask(task.id, v ?? false),
    );
  }
}
