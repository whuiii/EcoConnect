import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController email = TextEditingController();
  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              "https://img.freepik.com/free-vector/emails-concept-illustration_114360-1355.jpg?w=1380&t=st=1673699432~exp=1673700032~hmac=d65454eb5c72e8310209bf8ae770f849ea388f318dc6b9b1300b24b03e8886ca",
              height: 350,
            ),
          ),
          const SizedBox(
            height: 60,
            child: Text(
              "Enter your Email to get Code",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            child: Column(
              children: [
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.mail,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.teal,
                        )),
                    hintText: "Email Address",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
