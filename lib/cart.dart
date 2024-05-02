import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'success.dart';
import 'package:month_year_picker/month_year_picker.dart';

class ShoppingCart extends StatefulWidget {
  final List<Product> products;
  final VoidCallback clearCartCallback; // Add this line

  ShoppingCart({required this.products, required this.clearCartCallback});

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

  // New variables for autofilling
  String? savedEmail;
  String? savedStreet;
  String? savedSuburbCity;
  String? savedPostcode;
  String? savedState;
  String? savedCountry;
  String? savedFirstName;
  String? savedLastName;
  String? savedPhoneNumber;

  // Text editing controllers for form fields
  TextEditingController emailController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController suburbCityController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  // List to store orders
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    loadUserInformation();
  }

  void loadUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      setState(() {
        savedEmail = prefs.getString('email') ?? '';
        savedStreet = prefs.getString('street') ?? '';
        savedPhoneNumber = prefs.getString('phoneNumber') ?? '';
        savedSuburbCity = prefs.getString('suburbCity') ?? '';
        savedPostcode = prefs.getString('postcode') ?? '';
        savedState = prefs.getString('state') ?? '';
        savedCountry = prefs.getString('country') ?? 'Australia';
        savedFirstName = prefs.getString('firstName') ?? '';
        savedLastName = prefs.getString('lastName') ?? '';
      });

      // Set initial values for relevant form fields
      if (savedEmail != null && savedEmail!.isNotEmpty) {
        emailController.text = savedEmail!;
      }
      if (savedPhoneNumber != null && savedPhoneNumber!.isNotEmpty) {
        phoneNumberController.text = savedPhoneNumber!;
      }
      if (savedStreet != null && savedStreet!.isNotEmpty) {
        streetController.text = savedStreet!;
      }
      if (savedSuburbCity != null && savedSuburbCity!.isNotEmpty) {
        suburbCityController.text = savedSuburbCity!;
      }
      if (savedPostcode != null && savedPostcode!.isNotEmpty) {
        postcodeController.text = savedPostcode!;
      }
      if (savedState != null && savedState!.isNotEmpty) {
        stateController.text = savedState!;
      }
      if (savedFirstName != null && savedFirstName!.isNotEmpty) {
        firstNameController.text = savedFirstName!;
      }
      if (savedLastName != null && savedLastName!.isNotEmpty) {
        lastNameController.text = savedLastName!;
      }

      // Print the loaded user information for debugging
      print('Saved Email: $savedEmail');
      print('Saved Street: $savedStreet');
      print('Saved Suburb/City: $savedSuburbCity');
      print('Saved Postcode: $savedPostcode');
      print('Saved State: $savedState');
      print('Saved Country: $savedCountry');
    }
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

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      if (widget.products.isEmpty) {
        // Handle empty cart scenario
        print('Cannot submit order, cart is empty!');
      } else {
        // Proceed with order submission
        String orderNumber = DateTime.now().millisecondsSinceEpoch.toString();
        Order newOrder = Order(
          orderNumber: orderNumber,
          products: List.from(widget.products), // Create a new list from widget products
          totalAmount: total,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          phoneNumber: phoneNumberController.text,
          street: streetController.text,
          suburbCity: suburbCityController.text,
          postcode: postcodeController.text,
          state: stateController.text,
          country: selectedCountry,
          cardNumber: cardNumberController.text,
          expiry: expiryController.text,
          cvv: cvvController.text,
          selectedCountry: selectedCountry, // Pass selectedCountry to Order constructor
        );
        orders.add(newOrder);
        print('Order submitted successfully! Order Number: $orderNumber');

        // Call the clearCartCallback function to clear the cart on the home page
        widget.clearCartCallback();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessPage(
              orderNumber: orderNumber,
              products: newOrder.products, // Pass newOrder products to OrderSuccessPage
              totalAmount: newOrder.totalAmount,
              firstName: newOrder.firstName,
              lastName: newOrder.lastName,
              email: newOrder.email,
              phoneNumber: newOrder.phoneNumber,
              street: newOrder.street,
              suburbCity: newOrder.suburbCity,
              postcode: newOrder.postcode,
              state: newOrder.state,
              country: newOrder.country,
              cardNumber: newOrder.cardNumber,
              expiry: newOrder.expiry,
              cvv: newOrder.cvv,
              selectedCountry: selectedCountry, // Pass selectedCountry to OrderSuccessPage
            ),
          ),
        ).then((value) {
          if (value != null && value) {
            setState(() {
              widget.products.clear();
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
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
                            controller: firstNameController,
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
                            controller: lastNameController,
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
                            controller: phoneNumberController,
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
                      controller: emailController,
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
                      controller: streetController,
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
                            controller: suburbCityController,
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
                            controller: postcodeController,
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
                            controller: stateController,
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
                          child: Text(savedCountry ?? selectedCountry),
                        ),
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(0),
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
                            controller: cardNumberController,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(labelText: 'Expiry MM/YY'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your expiry date';
                                    }
                                    return null;
                                  },
                                  controller: expiryController,
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
                                  controller: cvvController,
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
        onPressed: _submitOrder,
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
  final String selectedCountry; // Include selectedCountry as a field

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
    required this.selectedCountry, // Update constructor to accept selectedCountry
  });
}

