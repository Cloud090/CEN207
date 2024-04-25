import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'cart.dart';
import 'account.dart';
import 'order_viewer.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String productName;
  final double productPrice;
  int quantity;
  final String description;
  final String imagePath;

  Product({
    required this.productName,
    required this.productPrice,
    this.quantity = 1,
    required this.imagePath,
    required this.description,

  });
}

enum UserRole {
  Administrator,
  Staff,
  Customer,
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Product> products = [
    Product(
        productName: 'USB C Cable',
        productPrice: 10.0,
        imagePath: 'assets/images/product1.png',
        description: 'This is a USB C cable.'
    ),
    Product(
        productName: 'USB Micro Cable',
        productPrice: 20.0,
        imagePath: 'assets/images/product2.png',
        description: 'This is a USB Micro cable.'
    ),
    Product(
        productName: 'USB Mini Cable',
        productPrice: 30.0,
        imagePath: 'assets/images/product3.png',
        description: 'This is a USB Mini cable.'
    ),
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> cartProducts = [];
  bool isLoggedIn = false;
  UserRole userRole = UserRole.Customer; // Default role

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Check login status when the app starts
    checkUserRole(); // Check user role from shared preferences
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  Future<void> checkUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int roleIndex = prefs.getInt('userRole') ?? UserRole.Customer.index;
    setState(() {
      userRole = UserRole.values[roleIndex];
    });
  }

  Future<void> createAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    // Add your account creation logic here (e.g., saving username and password)
    setState(() {
      isLoggedIn = true;
    });
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    setState(() {
      isLoggedIn = true;
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (isLoggedIn && (userRole == UserRole.Administrator || userRole == UserRole.Staff))
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  // Handle menu button tap
                },
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OneStop',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Powered by checkITout',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                if (isLoggedIn) {
                  logout(); // Log out if already logged in
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage(loginCallback: login)), // Pass login callback
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isLoggedIn ? Icons.logout : Icons.account_circle,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    isLoggedIn ? 'Logout' : 'Sign In/Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            final product = widget.products[index];

            return ListTile(
              leading: Image.asset(product.imagePath),
              title: Text(
                product.productName,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${product.productPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    product.description, // Add this line
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  setState(() {
                    var existingProduct = cartProducts.firstWhere(
                          (item) => item.productName == product.productName,
                      orElse: () {
                        var newProduct = Product(
                          productName: product.productName,
                          productPrice: product.productPrice,
                          imagePath: product.imagePath,
                          description: product.description,
                        );
                        cartProducts.add(newProduct); // Add the new product to the cartProducts list
                        return newProduct;
                      },
                    );
                    existingProduct.quantity++;
                  });
                  print('Add to Cart button pressed. Current cart products: $cartProducts , '
                      '${cartProducts.length}}');
                },
                child: Text('Add to Cart'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingCart(products: List.of(cartProducts), clearCartCallback: clearCartProducts), // Pass clearCartProducts callback
                ),
              );
            },
            child: Icon(Icons.shopping_cart),
          ),
          FloatingActionButton(
            onPressed: () {
              if (userRole == UserRole.Administrator || userRole == UserRole.Staff) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActiveOrdersPage(),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Access Denied'),
                    content: Text('Only Administrators and Staff can view active orders.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              }
            },
            child: Icon(Icons.view_list),
          )
        ],
      ),
    );
  }

  // Function to clear cartProducts
  void clearCartProducts() {
    setState(() {
      cartProducts.clear();
    });
  }
}