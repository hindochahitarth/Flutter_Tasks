import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:api_tutorial/models/ToDosModel.dart';

class Task_6_Todo extends StatefulWidget {
  const Task_6_Todo({super.key});

  @override
  State<Task_6_Todo> createState() => _Task_6_TodoState();
}

class _Task_6_TodoState extends State<Task_6_Todo> {
  List<ToDosModel> todos = [];
  List<ToDosModel> displayedTodos = [];
  bool showCompletedOnly = false;
  bool sortAscending = true;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        todos = data.map((json) => ToDosModel.fromJson(json)).toList();
        applyFilters();
      });
    }
  }

  void applyFilters() {
    displayedTodos = todos.where((todo) {
      final matchesSearch = todo.title.toLowerCase().contains(searchText.toLowerCase());
      final matchesFilter = showCompletedOnly ? todo.completed : true;
      return matchesSearch && matchesFilter;
    }).toList();

    displayedTodos.sort((a, b) =>
    sortAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
  }

  void onSearchChanged(String value) {
    setState(() {
      searchText = value;
      applyFilters();
    });
  }

  void toggleSort() {
    setState(() {
      sortAscending = !sortAscending;
      applyFilters();
    });
  }

  void toggleFilter() {
    setState(() {
      showCompletedOnly = !showCompletedOnly;
      applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Todo List'),

        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: toggleSort,
          ),
          IconButton(
            icon: Icon(showCompletedOnly ? Icons.filter_alt_off : Icons.filter_alt),
            onPressed: toggleFilter,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search todos...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: onSearchChanged,
            ),
          ),
        ),
      ),
      body: todos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: displayedTodos.length,
        itemBuilder: (context, index) {
          final todo = displayedTodos[index];
          return ListTile(
            leading: CircleAvatar(child: Text('${todo.id}')),
            title: Text(todo.title),
            trailing: Icon(
              todo.completed ? Icons.check_circle : Icons.circle_outlined,
              color: todo.completed ? Colors.green : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
