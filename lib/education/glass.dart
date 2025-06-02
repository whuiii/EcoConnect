import 'package:flutter/material.dart';

class GlassBin extends StatelessWidget {
  const GlassBin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Glass")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(top:16, left:20, right:20,bottom: 16 ),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Brown Bin",
                      style: TextStyle(fontSize: 30,
                          fontWeight: FontWeight.w500),),
                    SizedBox(width: 50,),
                    Image.asset("assets/images/Glass.png"),
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
