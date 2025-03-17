import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskTile extends StatelessWidget {
  final String task;
  final bool isChecked;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(bool?) onCheckboxChanged;

  const TaskTile({
    super.key,
    required this.task,
    required this.isChecked,
    required this.onEdit,
    required this.onDelete,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            // Edit Button
            SlidableAction(
              onPressed: (context) => onEdit(),
              backgroundColor: const Color (0xFFCE93D8),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            // Delete Button
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: const Color (0xFFBA68C8),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E5F5),
            borderRadius: BorderRadius.circular(20),

            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: isChecked,
                onChanged: onCheckboxChanged,
                activeColor: Colors.deepPurple,
                checkColor: Colors.white,
                side: BorderSide(
                  color: Colors.deepPurple,
                  width: 0.5,
                ),
              ),


              // Task Name
              Expanded(
                child: Text(
                  task,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color:Colors.black,
                      decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                      decorationColor: Colors.deepPurple,
                      decorationThickness: 2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
