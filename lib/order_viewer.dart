import 'package:flutter/material.dart';

class Order {
  final String orderNumber;
  final List<Product> products;
  final double totalAmount;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String street;
  final String suburbCity;
  final String postcode;
  final String state;
  final String country;
  final String cardNumber;
  final String expiry;
  final String cvv;
  final String selectedCountry;

  Order({
    required this.orderNumber,
    required this.products,
    required this.totalAmount,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.street,
    required this.suburbCity,
    required this.postcode,
    required this.state,
    required this.country,
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
    required this.selectedCountry,
  });
}

class Product {
  final String name;
  final int quantity;

  Product({
    required this.name,
    required this.quantity,
  });
}

class ActiveOrdersPage extends StatefulWidget {
  @override
  _ActiveOrdersPageState createState() => _ActiveOrdersPageState();
}

class _ActiveOrdersPageState extends State<ActiveOrdersPage> {
  List<Order> activeOrders = [];

  @override
  void initState() {
    super.initState();
    fetchActiveOrders();
  }

  void fetchActiveOrders() async {
    activeOrders = await OrderService.fetchOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Orders', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: activeOrders.length,
            itemBuilder: (context, index) {
              final order = activeOrders[index];
              return ListTile(
                title: Text('Order Number: ${order.orderNumber}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Products:'),
                    for (var product in order.products)
                      Text('${product.name} - Quantity: ${product.quantity}'),
                    Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
                    Text('Name: ${order.firstName} ${order.lastName}'),
                    Text('Email: ${order.email}'),
                    Text('Phone Number: ${order.phoneNumber}'),
                    Text(
                        'Address: ${order.street}, ${order.suburbCity}, ${order.postcode}, ${order.state}, ${order.country}'),
                    Text('Card Number: **** **** **** ${getLastFourDigits(order.cardNumber)}'),
                  ],
                ),
              );
            },
          ),
          Positioned(
            left: 10.0,
            bottom: 10.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActiveOrdersPage()),
                );
              },
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}

String getLastFourDigits(String numberStr) {
  String lastFourDigits = numberStr.length <= 4 ? numberStr : numberStr.substring(numberStr.length - 4);
  return lastFourDigits;
}

class OrderService {
  static Future<List<Order>> fetchOrders() async {
    List<Order> orders = [
      Order(
        orderNumber: '1234',
        products: [
          Product(name: 'Product A', quantity: 2),
          Product(name: 'Product B', quantity: 1),
        ],
        totalAmount: 100.0,
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phoneNumber: '+1234567890',
        street: '123 Street',
        suburbCity: 'City',
        postcode: '12345',
        state: 'State',
        country: 'Country',
        cardNumber: '1234123412341234',
        expiry: '12/24',
        cvv: '123',
        selectedCountry: 'Country',
      ),
      Order(
        orderNumber: '5678',
        products: [
          Product(name: 'Product C', quantity: 3),
          Product(name: 'Product D', quantity: 1),
        ],
        totalAmount: 200.0,
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane.doe@example.com',
        phoneNumber: '+0987654321',
        street: '456 Street',
        suburbCity: 'City',
        postcode: '67890',
        state: 'State',
        country: 'Country',
        cardNumber: '5678567856785678',
        expiry: '12/25',
        cvv: '456',
        selectedCountry: 'Country',
      ),
      Order(
        orderNumber: '91011',
        products: [
          Product(name: 'Product E', quantity: 1),
          Product(name: 'Product F', quantity: 2),
        ],
        totalAmount: 150.0,
        firstName: 'Alice',
        lastName: 'Smith',
        email: 'alice.smith@example.com',
        phoneNumber: '+1122334455',
        street: '789 Street',
        suburbCity: 'City',
        postcode: '54321',
        state: 'State',
        country: 'Country',
        cardNumber: '9101110123456789',
        expiry: '12/23',
        cvv: '789',
        selectedCountry: 'Country',
      ),
      Order(
        orderNumber: '121314',
        products: [
          Product(name: 'Product G', quantity: 1),
          Product(name: 'Product H', quantity: 3),
        ],
        totalAmount: 180.0,
        firstName: 'Bob',
        lastName: 'Johnson',
        email: 'bob.johnson@example.com',
        phoneNumber: '+9988776655',
        street: '1011 Street',
        suburbCity: 'City',
        postcode: '24680',
        state: 'State',
        country: 'Country',
        cardNumber: '1213141516171819',
        expiry: '12/26',
        cvv: '101',
        selectedCountry: 'Country',
      ),
      // Add more dummy orders here...
    ];
    return orders;
  }
}
