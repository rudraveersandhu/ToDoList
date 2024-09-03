import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:paper_card/paper_card.dart';
import '../models/taskViewModel.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';
import 'addEditTaskView.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class HomeView extends StatelessWidget {
  final TaskViewModel taskViewModel = Get.put(TaskViewModel());
  final EasyInfiniteDateTimelineController _controller =
  EasyInfiniteDateTimelineController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(CupertinoIcons.line_horizontal_3),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AddEditTaskView());
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.blue.shade300,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                          children: [
                          Icon(CupertinoIcons.add,
                          color: Colors.white,),
                          Text("Add Task",style: TextStyle(
                            color: Colors.white
                          ),
                          ),
                          ],
                         ),
                        )),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [.7, 1],
                    colors: [
                      Colors.blue.shade50,
                      Colors.blue.shade100,
                    ],
                  ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 1 ,bottom: 20,right: 1),
                child: Column(
                  children: [
                    EasyInfiniteDateTimeLine(
                      controller: _controller,
                      firstDate: DateTime(2023),
                      focusDate: DateTime.now(),
                      lastDate: DateTime(2099, 12, 31),
                      onDateChange: (selectedDate) {
                        taskViewModel.getTasksForDate(selectedDate);
                      },
                            itemBuilder: (
                    BuildContext context,
                    DateTime date,
                    bool isSelected,
                    VoidCallback onTap,
                    ) {
                        return InkResponse(
                          onTap: onTap,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(33),
                              gradient: isSelected ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1.0],
                                colors: [
                                  Colors.blue.shade100,
                                  Colors.blue.shade200,
                                ],
                              )
                                  : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1.0],
                                colors: [
                                  Colors.white,
                                  //Colors.cyan.shade50,
                                  Colors.blue.shade100,
                                ],
                              ),
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    EasyDateFormatter.shortDayName(date, "en_US"),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : null,
                                      fontSize: isSelected ? 16 : null
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                             },
                            ),
                    Padding(
                      padding: const EdgeInsets.
                        only(top: 20.0),
                      child: GestureDetector(
                        onTap: (){
                          taskViewModel.searchTasks('');
                        },
                        child: Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          
                          child: const Center(
                            child: Text("Reset",
                            style: TextStyle(
                              color: Colors.white
                            ),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                      )
                    ),

            Expanded(
              child: Container(
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0,bottom: 20,right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tasks",
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300
                                ),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.sort,size: 30,),
                                  onPressed: () {
                                    _showSortOptions(context);
                                  },
                                ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width:MediaQuery.of(context).size.width * .9,
                            child: TextField(
                              onChanged: (value){
                                taskViewModel.searchTasks(value);
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.search),
                                hintText: "Search for tasks",
                                filled: true,
                                fillColor: Colors.orange.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                          taskViewModel.tasks.isNotEmpty ?
                          Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: taskViewModel.tasks.length,
                            itemBuilder: (context, index) {
                              final task = taskViewModel.tasks[index];
                              print(task.dueDate);
                              return Slidable(
                                endActionPane: ActionPane(

                                  motion: const ScrollMotion(),
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 215,
                                      child: Column(
                                        children: [
                                          SlidableAction(
                                            onPressed: ((context) {
                                              taskViewModel.deleteTask(task.id);
                                            }
                                            ),
                                            backgroundColor: Colors.orange.shade700,//Colors.black.withRed(400),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            icon: Icons.delete,
                                            label: 'Delete',
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                bottomLeft: Radius.circular(25)),

                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    PaperCard(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width,
                                      borderColor: Colors.red,
                                      backgroundColor: Color.fromARGB(255, 139, 222, 255),
                                      borderRadius: 25,
                                      borderThickness: 10,
                                      elevation: 2,
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.all(16),
                                      textureAssetPath: "assets/tex.jpeg",
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 1.0),
                                                child: Text("${index+1})  ",
                                                  style: TextStyle(
                                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    task.title,
                                                    style: TextStyle(
                                                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                                        fontSize: 16
                                                    ),
                                                  ),
                                                  Text(
                                                    '${task.description}\nDue: ${task.dueDate.toLocal()}'.split(' ')[0],
                                                    style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top:0,
                                      bottom:0,
                                      right: 25,
                                      child: Checkbox(
                                        value: task.isCompleted,
                                        checkColor: Colors.white,
                                        activeColor: Colors.blue,
                                        onChanged: (_) {
                                          taskViewModel.toggleTaskCompletion(task.id);
                                        },
                                      ),
                                    )
                                  ],
                                ),


                              );

                            },
                          ),
                        ) :Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: Container(

                                    child: Lottie.asset(
                                      'assets/notask.json', // path to your animation file

                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const Text('No tasks available. Add some!',),

                              ],
                            ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityIcon(Priority priority) {
    Color color;
    switch (priority) {
      case Priority.High:
        color = Colors.red;
        break;
      case Priority.Medium:
        color = Colors.orange;
        break;
      case Priority.Low:
        color = Colors.green;
        break;
    }
    return Icon(Icons.label, color: color);
  }

  void _showSortOptions(BuildContext context) {
    Get.bottomSheet(

      Container(
        height: 200,
        color: Colors.blue.shade300,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.priority_high,
              color: Colors.white,
              ),
              title: const Text('Sort by Priority',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: () {
                taskViewModel.sortTasksByPriority();
                Get.back();
              },
            ),
            const Divider(
              height: 2,
              color: Colors.white,
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today,
                color: Colors.white,
              ),
              title: const Text('Sort by Due Date',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onTap: () {
                taskViewModel.sortTasksByDueDate();
                Get.back();
              },
            ),
            const Divider(
              height: 2,
              color: Colors.white,
            ),
            ListTile(
              leading: const Icon(Icons.access_time,
                color: Colors.white,),
              title: const Text('Sort by Creation Date',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onTap: () {
                taskViewModel.sortTasksByCreationDate();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

}
