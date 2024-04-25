import 'package:flutter/material.dart';

import 'cart.dart';

String getLastFourDigits(String numberStr) {
  String lastFourDigits = numberStr.length <= 4 ? numberStr : numberStr.substring(numberStr.length - 4);
  return lastFourDigits;
}

class ActiveOrdersPage extends StatefulWidget {
  @override
  _ActiveOrdersPageState createState() => _ActiveOrdersPageState();
}

class _ActiveOrdersPageState extends State<ActiveOrdersPage> {
  List<Order> activeOrders = []; // Replace Order with your actual Order model

  @override
  void initState() {
    super.initState();
    activeOrders; // Fetch the active orders when the widget is initialized
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
