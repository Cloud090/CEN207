import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

void main() {
  runApp(MyApp());
}

class Product {
  String productName;
  double productPrice;
  int quantity;

  Product({
    required this.productName,
    required this.productPrice,
    this.quantity = 0,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Product> products = [
    Product(productName: 'Product 1', productPrice: 10.0),
    Product(productName: 'Product 2', productPrice: 20.0),
    Product(productName: 'Product 3', productPrice: 30.0),
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> cartProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OneStop',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Set header color to blue
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Powered by checkITout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Set container color to white
        child: ListView.builder(
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            final product = widget.products[index];

            return ListTile(
              title: Text(
                product.productName,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                '\$${product.productPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  setState(() {
                    var existingProduct = cartProducts.firstWhere(
                          (item) => item.productName == product.productName,
                      orElse: () => Product(
                        productName: product.productName,
                        productPrice: product.productPrice,
                      ),
                    );
                    if (existingProduct.quantity == 0) {
                      cartProducts.add(existingProduct);
                    }
                    existingProduct.quantity++;
                  });
                },
                child: Text('Add to Cart'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShoppingCart(products: List.of(cartProducts)),
            ),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class ShoppingCart extends StatefulWidget {
  final List<Product> products;

  ShoppingCart({required this.products});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  double deliveryFee = 12; // Initial delivery fee for Australia
  String selectedCountry = 'Australia'; // Default selected country

  List<String> countries = [
    'Australia', 'United States', 'United Kingdom', 'Canada', 'India', 'Japan', // Add more countries as needed
  ];

  double get total {
    double productsTotal = widget.products.fold(
      0,
          (sum, product) => sum + (product.productPrice * product.quantity),
    );
    return productsTotal + deliveryFee; // Add delivery fee to total
  }

  double get gst {
    return total * 0.1; // 10% GST
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Set header color to blue
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // Set container color to white
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Cart (${widget.products.length} items)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  double subtotal = product.productPrice * product.quantity;

                  return ListTile(
                    title: Text(
                      product.productName,
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (product.quantity > 0) {
                                product.quantity--;
                                if (product.quantity == 0) {
                                  widget.products.remove(product);
                                }
                              }
                            });
                          },
                        ),
                        Text(
                          product.quantity.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              product.quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Delivery Fee: \$${deliveryFee.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  'GST: \$${gst.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                title: Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(), // Grey line to separate sections
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Date of Birth'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Address',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(labelText: 'Street'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Suburb/City'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Postcode'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'State'),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Country: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButton<String>(
                          value: selectedCountry,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCountry = newValue!;
                            });
                          },
                          items: countries.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(), // Grey line to separate sections
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(labelText: 'Card Number'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Expiry Date'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'CVV'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}