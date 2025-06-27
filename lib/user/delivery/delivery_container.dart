import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class RequestContainerWidget extends StatelessWidget {
  final String username;
  final String location;
  final List<String> materials;
  final String bagSize;
  final String status;
  final String remark;
  final String date;
  final String time;
  final VoidCallback? onTap;

  const RequestContainerWidget({
    super.key,
    required this.username,
    required this.location,
    required this.materials,
    required this.bagSize,
    required this.status,
    required this.remark,
    required this.date,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String iconName = '';
    Color statusColor = Colors.grey;

    if (status == "Pending") {
      iconName = 'assets/images/pending.json';
      statusColor = Colors.orange;
    } else if (status == "Accepted") {
      iconName = 'assets/images/accepted.json';
      statusColor = Colors.green;
    } else if (status == "Rejected") {
      iconName = 'assets/images/rejected.json';
      statusColor = Colors.red;
    }
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Side: Address + Status + Remarks
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Address
                    Row(
                      children: [
                        const Icon(Iconsax.location, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text("Address: $location",
                              style: const TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),

                    // Remark
                    if (remark.isNotEmpty && remark != "-") ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Iconsax.note_text, color: Colors.purple),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text("Remarks: $remark",
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Right Side: Icon + Date & Time
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Lottie Animation
                  Lottie.asset(
                    iconName,
                    width: 50,
                    height: 50,
                    repeat: false,
                  ),

                  // Status Label
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Date
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.right,
                  ),

                  // Time
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
