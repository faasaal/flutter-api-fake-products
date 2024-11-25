import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:your_app_name/constant.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List> _productFuture;

  Future<List> _getProduct() async {
    var url = Uri.parse(kProductUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    _productFuture = _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(82, 133, 107, 107),
        title: Center(
          child: Text(
            'API',
            style: TextStyle(color: Color.fromARGB(255, 126, 13, 120)),
          ),
        ),
      ),
      body: FutureBuilder<List>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No Data Available'));
          }

          return GridView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                textColor: const Color.fromARGB(255, 105, 105, 119),
                contentPadding: EdgeInsets.all(8.0),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      snapshot.data![index]['image'] ?? '',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 9.0),
                    Text(
                      snapshot.data![index]['title'] ?? 'No name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 9.0),
                    Flexible(
                      child: Text(
                        snapshot.data![index]['description'] ??
                            'No description',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 9.0),
                    Text(snapshot.data![index]['category'] ?? 'No category'),
                    SizedBox(height: 9.0),
                    Text(
                      "\$${snapshot.data![index]['price'] ?? '0.00'}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 0.8,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _productFuture = _getProduct();
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}