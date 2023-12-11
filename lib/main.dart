import 'package:flutter/material.dart';
import 'product.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Product App',
      home: ProductList(),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final dbHelper = DatabaseHelper.instance;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _queryAllProducts();
  }

  void _queryAllProducts() async {
    final allRows = await dbHelper.queryAllProducts();
    setState(() {
      products = allRows;
    });
  }

  void _insert() async {
    Product newProduct = Product(name: 'Product ${DateTime.now().toLocal()}', price: 19.99);
    await dbHelper.insert(newProduct);
    _queryAllProducts();
  }

  void _delete(int id) async {
    await dbHelper.delete(id);
    _queryAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text('${product.name} - \$${product.price.toString()}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _delete(product.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _insert,
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }
}
