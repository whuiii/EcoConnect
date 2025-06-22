import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/user/delivery/delivery_info.dart';
import 'package:navigate/user/delivery/page_delivery.dart';

import '../../color.dart';
import 'delivery_form.dart';

class DeliveryRequest extends StatelessWidget {
  const DeliveryRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          title: const Text("Recycle Request"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const Delivery()); // ensure Delivery() is a widget
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(DeliveryInfo());
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: button,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.question_mark,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10), // spacing between icon and text
                      const Text(
                        "Info",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10), // body-level padding
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10, // more blur = softer shadow
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: const [
                        RequestContainerWidget(
                          location: "Seri Iskandar",
                          description: "5kg Newspaper and 50 cans",
                          contactNo: "010-310123123",
                          remarks: "-",
                        ),
                        RequestContainerWidget(
                          location: "Seri Iskandar",
                          description: "5kg Newspaper and 50 cans",
                          contactNo: "010-310123123",
                          remarks: "Please come before 2/5/2034",
                        ),
                      ],
                    ),
                  ),
                ),

                // if contain request
                // may use while true to check the availability of the data
                // if no request display a no request picture

              ],

            ),
          ),
        ),
      ),
    );
  }
}

class RequestContainerWidget extends StatelessWidget {
  const RequestContainerWidget({
    Key? key,
    required this.location,
    required this.description,
    required this.contactNo,
    required this.remarks,
    this.textColor,
  }) : super(key: key);

  final String location;
  final String description;
  final String contactNo;
  final String remarks;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location: $location",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Description: $description",
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Contact: $contactNo",
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Remarks: $remarks",
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
