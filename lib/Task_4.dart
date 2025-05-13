import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Your TasksModel class
class TasksModel {
  TasksModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory TasksModel.fromJson(dynamic json) {
    return TasksModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  final num userId;
  final num id;
  final String title;
  final String body;
}

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  List<TasksModel>? dataList;

  Future<void> getApi() async {
    const String uri = "https://jsonplaceholder.typicode.com/posts";
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      setState(() {
        dataList = jsonData.map((e) => TasksModel.fromJson(e)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getApi();
  }

  void showDetailsDialog(TasksModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Text(task.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('G E T A P I'),
      ),
      body: dataList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: dataList!.length,
        itemBuilder: (context, index) {
          final task = dataList![index];
          return InkWell(
            onTap: () => showDetailsDialog(task),
            child: Card(
              margin:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${task.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Title: ${task.title}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Body: ${task.body}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
