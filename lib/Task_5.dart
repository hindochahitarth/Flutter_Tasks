import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageModel {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  ImageModel({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      albumId: json['albumId'] ?? 0,
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
    );
  }
}

class Task_5_Images extends StatefulWidget {
  const Task_5_Images({super.key});

  @override
  State<Task_5_Images> createState() => _Task_5_ImagesState();
}

class _Task_5_ImagesState extends State<Task_5_Images> {
  List<ImageModel>? dataList;
  bool isLoading = false;
  String? errorMessage;
  Future<void> getApi() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse("https://picsum.photos/v2/list?page=1&limit=30"),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List jsonData = jsonDecode(response.body);
        setState(() {
          dataList = jsonData.map((e) => ImageModel(
            albumId: 0,
            id: int.tryParse(e['id']) ?? 0,
            title: e['author'] ?? '',
            url: e['download_url'],
            thumbnailUrl: e['download_url'],
          )).toList();
        });
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching images: $e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getApi();
  }

  void showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5, // limit height
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Column(
                      children: [
                        Icon(Icons.error, size: 50),
                        Text('Failed to load image'),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
        title: const Text('Image List'),
        centerTitle: true,
      ),
      body: errorMessage != null
          ? Center(child: Text(errorMessage!))
          : isLoading
          ? const Center(child: CircularProgressIndicator())
          : dataList == null
          ? const Center(child: Text('No data available'))
          : ListView.builder(
        itemCount: dataList!.length,
        itemBuilder: (context, index) {
          final item = dataList![index];
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  item.thumbnailUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes !=
                              null
                              ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 50);
                  },
                ),
              ),
              title: Text(item.title),
              subtitle: Text('ID: ${item.id}'),
              onTap: () => showImageDialog(item.url),
            ),
          );
        },
      ),
    );
  }
}