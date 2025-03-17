import 'package:flutter/material.dart';
import 'widgets/task_tile.dart';
import 'widgets/categories.dart';
import 'widgets/bottom_navigation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> _tasks = [];
  final List<bool> _taskCompletion = []; // Track task completion state
  String _selectedCategory = 'All';
  int _currentIndex = 1;

  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
      _taskCompletion.add(false); // New task is initially unchecked
    });
    Navigator.pop(context);
  }

  void _editTask(int index, String newTask) {
    setState(() {
      _tasks[index] = newTask;
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
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                  _taskCompletion.removeAt(index);
                });
                Navigator.pop(context);
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
      taskController.text = _tasks[index];
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 1),
                  ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5,
                ),
                child: Text(index == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary.withOpacity(0.75),
        title: const Text(
          'Tasks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            fontStyle: FontStyle.italic,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Add the TaskCategories widget
          Center(
            child: TaskCategories(
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                  // Here you can filter tasks based on the selected category
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(

            child: _tasks.isEmpty

                ? const Center(child: Text('No tasks added yet!'))

                : ListView.builder(

                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      const SizedBox(height: 20);
                      return TaskTile(
                        task: _tasks[index],
                        isChecked: _taskCompletion[index],
                        onEdit: () => _showTaskBottomSheet(index: index),
                        onDelete: () => _deleteTask(index),
                        onCheckboxChanged: (bool? value) {
                          setState(() {
                            _taskCompletion[index] = value!;
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () => _showTaskBottomSheet(),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // Handle tab changes here
      ),
    );
  }
}
