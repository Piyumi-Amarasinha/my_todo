import 'package:flutter/material.dart';

class TaskCategories extends StatefulWidget {
  final Function(String) onCategorySelected;

  const TaskCategories({
    Key? key,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<TaskCategories> createState() => _TaskCategoriesState();
}

class _TaskCategoriesState extends State<TaskCategories> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Work',
    'Personal',
    'Wishlist',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                widget.onCategorySelected(category);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFB39DDB) : Colors.deepPurple,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Example usage in your main screen:
class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          TaskCategories(
            onCategorySelected: (category) {
              // Handle category selection here
              print('Selected category: $category');
              // Filter tasks based on selected category
            },
          ),
          // Rest of your task list UI
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFF48FB1),
        onPressed: () {
          // Handle adding new task
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mine',
          ),
        ],
      ),
    );
  }
}