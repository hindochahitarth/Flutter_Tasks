import 'package:flutter/material.dart';
import 'package:api_tutorial/AdmissionApp.dart';
import 'package:api_tutorial/Task_4.dart';
import 'package:api_tutorial/Task_5.dart';
import 'package:api_tutorial/Task_6_Todos.dart';

class HomeTabsPage extends StatelessWidget {
  const HomeTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade50,
          elevation: 0,
          title: const Text(
            "Tab View Example",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.purple,
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Users'),
              Tab(icon: Icon(Icons.text_fields), text: 'text'),
              Tab(icon: Icon(Icons.image), text: 'photos'),
              Tab(icon: Icon(Icons.check_box), text: 'todo'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddDetails(),      // Users
            HomePage2(),       // todo
            Task_5_Images(),   // photos
            Task_6_Todo(),     // text
          ],
        ),
      ),
    );
  }
}
