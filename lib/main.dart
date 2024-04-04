import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.blue[500]),
      child: Row(
        children: [
          const IconButton(
            icon: Icon(Icons.shopping_cart),
            tooltip: 'Navigation menu',
            onPressed: null,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // Center the title widget vertically
              children: [
                title, // Center align the title widget
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 0),
            child: Text(
              'Powered by CheckitOut',
              style: TextStyle(fontSize: 8, color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ),
          const IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Add GestureDetector here
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
      },
      child: Material(
        child: Column(
          children: [
            MyAppBar(
              title: Text(
                'OneStop',
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(', Hello. 123 world?'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout Page'),
      ),
      body: Center(
        child: Text('This is the Checkout page'),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      title: 'My app', // used by the OS task switcher
      home: SafeArea(
        child: MyScaffold(),
      ),
    ),
  );
}

