import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class RequestContainerWidget extends StatelessWidget {
  final String username;
  final String location;
  final List<String> materials;
  final String bagSize;
  final String status;
  final String remarks;
  final String rejectReason;
  final String date;
  final String time;
  final int? pointAwarded;
  final VoidCallback? onTap;

  const RequestContainerWidget({
    super.key,
    required this.username,
    required this.location,
    required this.materials,
    required this.bagSize,
    required this.status,
    required this.rejectReason,
    required this.date,
    required this.time,
    this.onTap,
    this.pointAwarded,
    required this.remarks,
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
    } else if (status == "Completed") {
      iconName = 'assets/images/rewarded.json';
      statusColor = Colors.blue;
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
              // Left Side: Address + Status + rejectReasons
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
// Remarks (if available)
                    if (remarks.isNotEmpty && remarks != "-") ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Iconsax.message_text, color: Colors.teal),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Remarks: $remarks",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                    // Points Awarded (only if completed)
                    if (status == "Completed" && pointAwarded != null) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const SizedBox(width: 6),
                          Text(
                            "+ $pointAwarded points",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // rejectReason
                    if (status == "Rejected" &&
                        rejectReason.isNotEmpty &&
                        rejectReason != "-") ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Iconsax.close_circle, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text("Reason: $rejectReason",
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
