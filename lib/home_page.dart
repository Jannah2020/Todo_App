import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:todo_application/util.dart';
import 'package:todo_application/todo_page.dart';

// stl = stateless widget
// stf = stateful widget

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedItem = 'todo';

  final List<Map<String, dynamic>> _unCompletedData = [];

  final List<Map<String, dynamic>> _completedData = [];

  final List<Map<String, dynamic>> data = [
    {
      'title': 'Assignments Reminder',
      'description': 'Todo App',
      'date_time': 'Yesterday',
      'status': true,
    },
    {
      'title': 'Kid sisters birthday',
      'description': 'Happy Happy Birthday to my pretty anoining baby sister',
      'date_time': 'Today',
      'status': true,
    },
    {
      'title': 'Pool Party Schedule',
      'description': 'Going to Pool Party with my Boys Boys',
      'date_time': 'Tomorrow',
      'status': false,
    },
    {
      'title': 'Studying & Coding Time',
      'description': 'Online Cousera and Flutter App development class',
      'date_time': 'Mon. 27 Dec',
      'status': true,
    },
    {
      'title': 'Studying & Coding Time',
      'description': 'Online Cousera and Flutter App development class',
      'date_time': 'Today',
      'status': false,
    },
    {
      'title': 'Traveling to my hometown',
      'description': 'Holiday Travels',
      'date_time': 'Yesterday',
      'status': false,
    },
    {
      'title': 'Swimming Lessons with friends',
      'description': 'Exercising the body',
      'date_time': 'Tomorrow',
      'status': true,
    },
    {
      'title': 'Swimming Lessons with friends',
      'description': 'Exercising the body',
      'date_time': 'Tomorrow',
      'status': false,
    },
  ];

  @override
  void initState() {
    for (Map<String, dynamic> element in data) {
      if (!element['status']) {
        _unCompletedData.add(element);
      } else {
        _completedData.add(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.8),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'My Tasks',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          leading: const Icon(Icons.arrow_back_ios),
          actions: [
            PopupMenuButton<String>(
                icon: const Icon(Icons.menu),
                onSelected: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      child: Text('Todo'),
                      value: 'todo',
                    ),
                    const PopupMenuItem(
                      child: Text('Completed'),
                      value: 'completed',
                    )
                  ];
                }),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CreateTodoView();
            }));
          },
          child: const Icon(CupertinoIcons.add),
          backgroundColor: const Color.fromRGBO(37, 43, 103, 2),
        ),
        body: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              return TaskCardWidget(
                dateTime: selectedItem == 'todo'
                    ? _unCompletedData[index]['date_time']
                    : _completedData[index]['date_time'],
                title: selectedItem == 'todo'
                    ? _unCompletedData[index]['title']
                    : _completedData[index]['title'],
                description: selectedItem == 'todo'
                    ? _unCompletedData[index]['description']
                    : _completedData[index]['description'],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemCount: selectedItem == 'todo'
                ? _unCompletedData.length
                : _completedData.length),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: InkWell(
              onTap: () {
                showBarModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            return TaskCardWidget(
                              dateTime: _completedData[index]['date_time'],
                              description: _completedData[index]['description'],
                              title: _completedData[index]['title'],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: _completedData.length);
                    });
              },
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(37, 42, 103, 1),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 25,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Completed',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${_completedData.length}',
                        style:
                            const TextStyle(fontSize: 17, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.dateTime,
  }) : super(key: key);

  final String title;
  final String description;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline_outlined,
              size: 23,
              color: customColor(date: dateTime),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color.fromRGBO(37, 42, 103, 1)),
                  ),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 18,
                  color: customColor(date: dateTime),
                ),
                Text(
                  dateTime,
                  style: TextStyle(color: customColor(date: dateTime)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
