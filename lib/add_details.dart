import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_tutorial/models/AdmissionModel.dart';


class addDetails extends StatefulWidget {
  const addDetails({super.key});

  @override
  State<addDetails> createState() => _addDetailsState();
}

class _addDetailsState extends State<addDetails> {
List<Response>? datalist;
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
          Uri.parse("https://glexas.com/hostel_data/API/test/new_admission_crud.php")
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final model = AdmissionModel.fromJson(decoded);
        setState(() => datalist = model.response);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> addData(Map<String, dynamic> data) async {
    setState(() => isLoading = true);
    try {
        final response = await http.post(
        Uri.parse("https://glexas.com/hostel_data/API/test/new_admission_crud.php"),
        body: data, // Send as form data directly
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data added successfully')),
        );
        await fetchData(); // Wait for fetch to complete before rebuilding
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateData(Map<String, dynamic> data) async {
    setState(() => isLoading = true);
    try {
      final response = await http.put(
        Uri.parse("https://glexas.com/hostel_data/API/test/new_admission_crud.php"),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully')),
        );
        fetchData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating data: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteData(String registrationMainId) async {
    setState(() => isLoading = true);
    try {
      final response = await http.delete(
        Uri.parse("https://glexas.com/hostel_data/API/test/new_admission_crud.php"),
        body: jsonEncode({'registration_main_id': registrationMainId}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data deleted successfully')),
        );
        fetchData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting data: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _showAddDialog() {
    final userCodeController = TextEditingController();
    final firstNameController = TextEditingController();
    final middleNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Data'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userCodeController,
                decoration: const InputDecoration(labelText: 'User Code*'),
              ),
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name*'),
              ),
              TextField(
                controller: middleNameController,
                decoration: const InputDecoration(labelText: 'Middle Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name*'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number*'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email*'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (userCodeController.text.isEmpty ||
                  firstNameController.text.isEmpty ||
                  lastNameController.text.isEmpty ||
                  phoneController.text.isEmpty ||
                  emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields (*)')),
                );
                return;
              }

              await addData({
                'user_code': userCodeController.text,
                'first_name': firstNameController.text,
                'middle_name': middleNameController.text,
                'last_name': lastNameController.text,
                'phone_number': phoneController.text,
                'phone_country_code': '+91',
                'email': emailController.text,
              });

              if (mounted) Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(Response item) {
    final userCodeController = TextEditingController(text: item.userCode);
    final firstNameController = TextEditingController(text: item.firstName);
    final middleNameController = TextEditingController(text: item.middleName ?? '');
    final lastNameController = TextEditingController(text: item.lastName);
    final phoneController = TextEditingController(text: item.phoneNumber);
    final emailController = TextEditingController(text: item.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Data'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userCodeController,
                decoration: const InputDecoration(labelText: 'User Code*'),
              ),
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name*'),
              ),
              TextField(
                controller: middleNameController,
                decoration: const InputDecoration(labelText: 'Middle Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name*'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number*'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email*'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (userCodeController.text.isEmpty ||
                  firstNameController.text.isEmpty ||
                  lastNameController.text.isEmpty ||
                  phoneController.text.isEmpty ||
                  emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields (*)')),
                );
                return;
              }

              await updateData({
                'registration_main_id': item.registrationMainId,
                'user_code': userCodeController.text,
                'first_name': firstNameController.text,
                'middle_name': middleNameController.text,
                'last_name': lastNameController.text,
                'phone_number': phoneController.text,
                'phone_country_code': '+91',
                'email': emailController.text,
              });

              if (mounted) Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMISSION APP'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : datalist == null || datalist!.isEmpty
          ? const Center(child: Text('No data available'))
          : ListView.builder(
        itemCount: datalist!.length,
        itemBuilder: (context, index) {
          final item = datalist![index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Dismissible(
              key: Key(item.registrationMainId),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.blue,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  _showUpdateDialog(item);
                  return false;
                } else {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text('Are you sure you want to delete this item?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm) {
                    await deleteData(item.registrationMainId);
                  }
                  return confirm;
                }
              },
              child: ListTile(
                title: Text('${item.firstName} ${item.lastName}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${item.registrationMainId}'),
                    Text('User Code: ${item.userCode}'),
                    if (item.middleName?.isNotEmpty ?? false)
                      Text('Middle Name: ${item.middleName}'),
                    Text('Phone: ${item.phoneCountryCode} ${item.phoneNumber}'),
                    Text('Email: ${item.email}'),
                    Text('Created: ${item.createdTime}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
