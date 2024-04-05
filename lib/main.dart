import 'package:flutter/material.dart';
//Client Information
var client_name;
var client_address;
var client_phone;
var client_email;
//Product Information
var product_name; 
var product_price;
var product_quantity;
var shipping_cost;
//Final Costs
var total_cost;

void main() {
  runApp(
    const MaterialApp(
      title: 'CEN207 Prototype Team 1', // used by the OS task switcher
      home: SafeArea(
        child: MyScaffold(),
      ),
    ),
  );
}
//---------------------------------------------------------//
//-----------------------[ GLOBAL ]-----------------------//
//-------------------------------------------------------//




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

//---------------------------------------------------------//
//-----------------------[ PAGE 1 ]-----------------------//  
//-------------------------------------------------------//

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Stack(
        children: [
          // Other widgets that should appear on top of the list
          // Add your widgets here
          SpacedItemsList(),
          // List of items displayed behind other widgets
          Positioned.fill(
            child: SpacedItemsList(),
          ),
        ],
      ),
    );
  }
}



class MyScaffold extends StatelessWidget {
  const MyScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            Expanded(
              child: SpacedItemsList(), // Display the item list here
            ),
          ],
        ),
      ),
    );
  }
}

  
//---------------------------------------------------------//
//-----------------------[ PAGE 2 ]-----------------------//  
//-------------------------------------------------------//

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter your Name:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16), // Add vertical spacing
                  // TextField(
                  //   decoration: InputDecoration(
                  //     labelText: 'Enter your Address:',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(width: 16), // Add horizontal spacing
            Expanded(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter your Phone:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16), // Add vertical spacing
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter your Email:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16), // Add vertical spacing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpacedItemsList extends StatelessWidget {
  const SpacedItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const items = 8;

    return MaterialApp(
      title: 'CEN207 App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardTheme(color: Colors.blue.shade50),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  items,
                  (index) => ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 50), // Adjust the height as needed
                    child: ItemWidget(text: 'Product ${index + 1}'),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(child: Text(text)),
      ),
    );
  }
}