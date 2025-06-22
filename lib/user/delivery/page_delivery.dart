import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:navigate/color.dart';

class DeliveryForm extends StatefulWidget {
  const DeliveryForm({super.key});

  @override
  State<DeliveryForm> createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  bool _secureText = true;
  bool? isPlastic = false;
  bool? isAluminium = false;
  bool? isPaper = false;
  TextEditingController _nameController = TextEditingController();
  String? _passwordError;
  TextEditingController _passwordController = TextEditingController();
  String? _dropdownValue;
  var _formKey = GlobalKey<FormState>();

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                  hintText: "Your Name as per IC",
                  labelText: "Full Name",
                  labelStyle: TextName,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(50.0), // Rounded corners
                  ),
                  fillColor: primary,
                  filled: true),
              maxLines: 1,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Your Contact Number",
                labelText: "Contact No.",
                labelStyle: TextName,
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 12,
            ),
            SizedBox(height: 16),
            FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Username or email",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      prefixIcon: Icon(
                        Iconsax.user,
                        color: Colors.black,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade200, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      floatingLabelStyle:
                          TextStyle(color: Colors.black, fontSize: 18),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(10))),
                )),
            SizedBox(height: 16),
            Column(
              children: [
                Row(children: [
                  Checkbox(
                    value: isPlastic,
                    onChanged: (bool? value) {
                      setState(() {
                        isPlastic = value;
                      });
                    },
                    activeColor: Colors.orange, // fill color when checked
                    checkColor: Colors.white, // tick mark color
                  ),
                  Text(
                    "Plastic",
                    style: TextName,
                  ),
                ]),
                Row(children: [
                  Checkbox(
                    value: isAluminium,
                    onChanged: (bool? value) {
                      setState(() {
                        isAluminium = value;
                      });
                    },
                    activeColor: Colors.brown, // fill color when checked
                    checkColor: Colors.white, // tick mark color
                  ),
                  Text(
                    "Aluminium",
                    style: TextName,
                  ),
                ]),
                Row(children: [
                  Checkbox(
                    value: isPaper,
                    onChanged: (bool? value) {
                      setState(() {
                        isPaper = value;
                      });
                    },
                    activeColor: Colors.blue, // fill color when checked
                    checkColor: Colors.white, // tick mark color
                  ),
                  Text(
                    "Paper",
                    style: TextName,
                  ),
                ]),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Your address/city/state",
                labelText: "Address",
                labelStyle: TextName,
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                floatingLabelStyle:
                    TextStyle(color: Colors.black, fontSize: 18),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                fillColor: primary,
                filled: true,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                  hintText: "Additional Note",
                  labelText: "Remarks",
                  labelStyle: TextName,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(50.0), // Rounded corners
                  ),
                  fillColor: primary,
                  filled: true),
              maxLines: 1,
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty";
                  } else if (value.length < 3) {
                    return "Enter at least 3 characters";
                  }
                  return null; // No error
                },
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  labelText: "Password",
                  labelStyle: TextStyle(fontSize: 24, color: Colors.blue),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.security),
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButton(
              items: ["Dash", "Sparky", "Snoo"]
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              value: _dropdownValue,
              onChanged: dropdownCallback,
              iconSize: 20,
              iconEnabledColor: Colors.green,
              icon: const Icon(Icons.ac_unit_rounded),
              isExpanded: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  bool? isValid = _formKey.currentState?.validate();
                  print("Form Validation: $isValid");
                },
                child: Text("Form")),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    print("Password: " + _passwordController.text);
                    if (_passwordController.text.length < 3)
                      _passwordError = "Enter at least 3 char";
                    else {
                      _passwordError = null;
                    }
                  });
                },
                child: Text("Submit")),
          ],
        ),
      ),
    ));
  }
}
