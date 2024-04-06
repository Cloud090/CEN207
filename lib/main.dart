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
        backgroundColor: Colors.blue,
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
        color: Colors.white,
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
  String selectedCountry = 'Australia';
  double deliveryFee = 0;
  DateTime? selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool showCosts = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 0 && !_scrollController.position.outOfRange) {
      setState(() {
        showCosts = true;
      });
    } else {
      setState(() {
        showCosts = false;
      });
    }
  }

  double calculateDeliveryFee(int itemCount) {
    if (itemCount > 0) {
      if (selectedCountry == 'Australia') {
        deliveryFee = 12;
      } else {
        deliveryFee = 16;
      }
    } else {
      deliveryFee = 0;
    }
    return deliveryFee;
  }

  double get total {
    double productsTotal = widget.products.fold(
      0,
          (sum, product) => sum + (product.productPrice * product.quantity),
    );
    return productsTotal + calculateDeliveryFee(widget.products.length);
  }

  double get gst {
    return total * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Cart (${widget.products.length} items)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            widget.products.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "It's empty in here, Go Shopping",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back to Shopping'),
                    ),
                  ],
                ),
              ),
            )
                : ListView.builder(
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
                'Delivery Fee: \$${calculateDeliveryFee(widget.products.length).toStringAsFixed(2)}',
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
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'First Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Last Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 120,
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Date of Birth'),
                              controller: TextEditingController(
                                text: selectedDate != null
                                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                    : "",
                              ),
                              onTap: () async {
                                final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null && pickedDate != selectedDate) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your date of birth';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Phone Number'),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Address',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Street'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your street';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Suburb/City'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your suburb/city';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Postcode'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your postcode';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'State'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your state';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Country: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                flagSize: 25,
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                                bottomSheetHeight: 500,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                inputDecoration: InputDecoration(
                                  labelText: 'Search',
                                  hintText: 'Start typing to search',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8).withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                              onSelect: (Country country) {
                                setState(() {
                                  selectedCountry = country.displayName ?? 'Australia';
                                });
                              },
                            );
                          },
                          child: Text(selectedCountry),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Other form fields...
                  SizedBox(height: 16),
                  Text(
                    'Payment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Card Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your card number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Expiry MM/DD'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your expiry date';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16), // Add spacing between form fields
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'CVV'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your CVV';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: showCosts,
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Fee: \$${calculateDeliveryFee(widget.products.length).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'GST: \$${gst.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid, proceed with checkout
            print('Form is valid. Proceed with checkout.');
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}