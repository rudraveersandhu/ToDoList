import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task.dart';
import '../models/taskViewModel.dart';


class AddEditTaskView extends StatefulWidget {
  final Task? task;

  AddEditTaskView({this.task});

  @override
  _AddEditTaskViewState createState() => _AddEditTaskViewState();
}

class _AddEditTaskViewState extends State<AddEditTaskView> {
  final TaskViewModel taskViewModel = Get.find();
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  Priority _priority = Priority.Medium;
  DateTime _dueDate = DateTime.now().add(Duration(days: 1));

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    } else {
      _title = '';
      _description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.task != null;
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Title
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              SizedBox(height: 16.0),
              // Description
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              SizedBox(height: 16.0),
              // Priority
              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: Priority.values.map((Priority priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Priority? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              // Due Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Due Date: ${_dueDate.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDueDate,
              ),
              SizedBox(height: 16.0),
              // Save Button
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(isEditing ? 'Update Task' : 'Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate),
      );

      if (pickedTime != null) {
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }


  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.task != null) {
        // Edit Task
        taskViewModel.editTask(
          widget.task!.id,
          _title,
          _description,
          _priority,
          _dueDate,
        );
      } else {
        // Add Task
        taskViewModel.addTask(
          _title,
          _description,
          _priority,
          _dueDate,
        );
      }
      Get.back();
    }
  }
}
