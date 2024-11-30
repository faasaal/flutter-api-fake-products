import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:your_app_name/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List> _productFuture;
  List _allProducts = [];
  List _filteredProducts = [];
  TextEditingController _searchController = TextEditingController();

  Future<List> _getProduct() async {
    var url = Uri.parse(kProductUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _allProducts = data;
        _filteredProducts = data;
      });
      return data;
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _filterProducts(String query) {
    List filtered = _allProducts.where((product) {
      return (product['title'] ?? '')
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredProducts = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    _productFuture = _getProduct();
    _searchController.addListener(() {
      _filterProducts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchButtonPressed() {
    _filterProducts(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            'API',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          hintText: "Search product",
                          fillColor: Colors.grey[200],
                          hintStyle: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: _onSearchButtonPressed,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        child: const Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      textColor: const Color.fromARGB(255, 105, 105, 119),
                      contentPadding: EdgeInsets.all(8.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            _filteredProducts[index]['image'] ?? '',
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(height: 9.0),
                          Text(
                            _filteredProducts[index]['title'] ?? 'No name',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 9.0),
                          Flexible(
                            child: Text(
                              _filteredProducts[index]['description'] ??
                                  'No description',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: 9.0),
                          Text(_filteredProducts[index]['category'] ??
                              'No category'),
                          SizedBox(height: 9.0),
                          Text(
                            "\$${_filteredProducts[index]['price'] ?? '0.00'}",
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
                ),
              ),
            ],
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
