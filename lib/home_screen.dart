import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../api/product_client.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProductClient _productClient;
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _productClient = ProductClient(dio);
    _productsFuture = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    try {
      return await _productClient.getProducts();
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.title ?? 'No title'),
                  subtitle: Text(product.body ?? 'No body'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
