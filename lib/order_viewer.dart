import 'package:flutter/material.dart';

import 'cart.dart';

// This removes the first 12 digits of the card number and only displays the last four digits
String getLastFourDigits(String numberStr) {
  String lastFourDigits = numberStr.length <= 4 ? numberStr : numberStr.substring(numberStr.length - 4);
  return lastFourDigits;
}
// This is the ActiveOrdersPage widget that displays the active orders
class ActiveOrdersPage extends StatefulWidget {
  @override
  _ActiveOrdersPageState createState() => _ActiveOrdersPageState();
}
// This is the state of the ActiveOrdersPage widget
class _ActiveOrdersPageState extends State<ActiveOrdersPage> {
  List<Order> activeOrders = []; // Replace Order with your actual Order model

  @override
  // This function is called when the widget is initialized
  void initState() {
    super.initState();
    fetchActiveOrders(); // Fetch the active orders when the widget is initialized
  }
// This function fetches the active orders from the server
  void fetchActiveOrders() async {
    activeOrders = await OrderService.fetchOrders();
    setState(() {}); // Call setState to rebuild the widget with the fetched orders
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Orders'),
      ),
      body: Stack(
        children: [
      ListView.builder(
      itemCount: activeOrders.length,
        itemBuilder: (context, index) {
          final order = activeOrders[index];
          return ListTile(
            title: Text('Order Number: ${order.orderNumber}'), // Display the order number
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Products: ${order.products}'), // Display the products (you can format this better if you want
                Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'), // Display the total amount
                Text('Name: ${order.firstName} ${order.lastName}'), // Display the customer's name
                Text('Email: ${order.email}'), // Display the customer's email
                Text('Phone Number: ${order.phoneNumber}'), // Display the customer's phone number
                Text('Address: ${order.street}, ${order.suburbCity}, ${order.postcode}, ${order.state}, ${order.country}'), // Display the customer's address
                Text('Card Number: **** **** **** ${getLastFourDigits(order.cardNumber)}'), // Display the last four digits of the card number

                // Add more Text widgets here to display other details of the order
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
                MaterialPageRoute(builder: (context) => ActiveOrdersPage()), // Replace with your OrderViewPage
              );
            },
            child: Icon(Icons.view_list), // Replace with your preferred icon
          ),
        ),
      ],
    ),
  );
}
}

// This is a dummy Order class to demonstrate the concept of fetching orders and displaying them
class OrderService {
  static Future<List<Order>> fetchOrders() async {
    // Actual logic for fetching orders would go here if within scope.
    // This would involve making a network request, reading from a database, etc.

    // Creating something to display as a proof of concept.
    List<Order> orders = [
      Order(
        orderNumber: '1234',
        products: [], // Actual products would appear here
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
        products: [], // Actual products would appear here
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
      // Any more orders would go here...
    ];
    return orders;
  }
}
