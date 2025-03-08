import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> _tasks = []; // List to store tasks

  void _addTask(String task) {
    setState(() {
      _tasks.add(task); // Add new task to the list
    });
    Navigator.pop(context); // Close the bottom sheet after adding task
  }

  void _editTask(int index, String newTask) {
    setState(() {
      _tasks[index] = newTask; // Update the task
    });
    Navigator.pop(context);
  }

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel deletion
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index); // Remove the task from the list
                });
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showTaskBottomSheet({int? index}) {
    TextEditingController taskController = TextEditingController();

    if (index != null) {
      taskController.text = _tasks[index]; // Pre-fill if editing
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                index == null ? 'Enter New Task' : 'Edit Task',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Task Name',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (taskController.text.isNotEmpty) {
                    if (index == null) {
                      _addTask(taskController.text);
                    } else {
                      _editTask(index, taskController.text);
                    }
                  }
                },
                child: Text(index == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Tasks')),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks added yet!'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _tasks[index],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showTaskBottomSheet(index: index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(index), // Show confirmation box
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskBottomSheet(),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
