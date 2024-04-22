import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_picker/country_picker.dart';

enum UserRole {
  Administrator,
  Staff,
  Customer,
}

class AccountPage extends StatefulWidget {
  final Function loginCallback;

  const AccountPage({Key? key, required this.loginCallback}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController suburbCityController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  String selectedCountry = 'Australia';
  bool isCreatingAccount = false;
  bool addAddress = false;
  UserRole userRole = UserRole.Customer; // Default role

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> showGreenPopup(String message) async {
    if (!_isDisposed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(message),
        ),
      );
      await Future.delayed(Duration(seconds: 2));
    }
  }

  Future<void> createAccount() async {
    if (!_isDisposed && _formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? newUsername = emailController.text.trim();

      if (prefs.getString('username') == newUsername) {
        if (!_isDisposed) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Username (Email) already exists. Please choose another one.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        if (!_isDisposed) {
          await prefs.setString('username', newUsername);
          await prefs.setString('password', passwordController.text);
          await prefs.setString('email', emailController.text.trim());
          await prefs.setString('firstName', firstNameController.text.trim());
          await prefs.setString('lastName', lastNameController.text.trim());
          await prefs.setString('phoneNumber', phoneNumberController.text.trim());
          await prefs.setInt('userRole', userRole.index); // Save the user role
          if (addAddress) {
            await prefs.setString('street', streetController.text.trim());
            await prefs.setString('suburbCity', suburbCityController.text.trim());
            await prefs.setString('postcode', postcodeController.text.trim());
            await prefs.setString('state', stateController.text.trim());
            await prefs.setString('country', selectedCountry);
          }
          showGreenPopup('Account created successfully!');
          Navigator.pop(context); // Close the account creation page
        }
      }
    }
  }

  Future<void> login() async {
    if (!_isDisposed && _formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');
      String? savedPassword = prefs.getString('password');
      if (savedUsername == emailController.text && savedPassword == passwordController.text) {
        widget.loginCallback();
        showGreenPopup('Successfully logged in!');
        Navigator.pop(context);
      } else {
        if (!_isDisposed) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Incorrect email or password.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  void selectCountry() {
    if (!_isDisposed) {
      showCountryPicker(
        context: context,
        showPhoneCode: false,
        onSelect: (Country country) {
          setState(() {
            selectedCountry = country.displayName ?? 'Australia';
          });
        },
        favorite: ['AU', 'NZ'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCreatingAccount)
                    Column(
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<UserRole>(
                          value: userRole,
                          onChanged: (newValue) {
                            setState(() {
                              userRole = newValue!;
                            });
                          },
                          items: UserRole.values.map((UserRole role) {
                            return DropdownMenuItem<UserRole>(
                              value: role,
                              child: Text(role.toString().split('.').last),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'User Role',
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: firstNameController,
                                decoration: InputDecoration(labelText: 'First Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: lastNameController,
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
                        SizedBox(height: 10),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(labelText: 'Phone Number'),
                          validator: (value) {
                            if (value == null || value.isEmpty || !value.startsWith('+')) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        CheckboxListTile(
                          title: Text('Would you like to add your address for easier checkout?'),
                          value: addAddress,
                          onChanged: (value) {
                            setState(() {
                              addAddress = value!;
                            });
                          },
                        ),
                        if (addAddress) ...[
                          TextFormField(
                            controller: streetController,
                            decoration: InputDecoration(labelText: 'Street'),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: suburbCityController,
                                  decoration: InputDecoration(labelText: 'Suburb/City'),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: postcodeController,
                                  decoration: InputDecoration(labelText: 'Postcode'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: stateController,
                                  decoration: InputDecoration(labelText: 'State'),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Country: ',
                                style: TextStyle(fontSize: 16),
                              ),
                              ElevatedButton(
                                onPressed: selectCountry,
                                child: Text(selectedCountry),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: createAccount,
                          child: Text('Create Account'),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isCreatingAccount = false;
                            });
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: login,
                          child: Text('Login'),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isCreatingAccount = true;
                            });
                          },
                          child: Text('Create an Account'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}