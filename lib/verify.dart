import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Verify extends StatelessWidget {
  const Verify({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Verify"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        "https://img.freepik.com/free-vector/emails-concept-illustration_114360-1355.jpg?w=1380&t=st=1673699432~exp=1673700032~hmac=d65454eb5c72e8310209bf8ae770f849ea388f318dc6b9b1300b24b03e8886ca",
                        height: 250,
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 30, 16, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Enter your verification code",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 25),
                            child: TextField(
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                labelText: "Email",
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.black,
                                  size: 18,
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                floatingLabelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          pinCodeTextField(context),


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget pinCodeTextField(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: PinCodeTextField(
      appContext: context,
      length: 4,
      enableActiveFill: true,
      animationType: AnimationType.fade,
      animationDuration: Duration(milliseconds: 300),
      onChanged: (value) {}, // Needed to avoid runtime error
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        fieldHeight: 60,
        fieldWidth: MediaQuery.of(context).size.width * 0.19,
        inactiveColor: Colors.grey,
        activeColor: Colors.black,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.grey.shade300,
        selectedFillColor: Colors.grey.shade300,
      ),
    ),
  );
}
