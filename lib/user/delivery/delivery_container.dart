import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:navigate/user/delivery/delivery_container_detail.dart';

class RequestContainerWidget extends StatelessWidget {
  final String location;
  final List<String> materials;
  final String bagSize;
  final String status;
  final String remark;
  final VoidCallback? onTap;

  const RequestContainerWidget({
    super.key,
    required this.location,
    required this.materials,
    required this.bagSize,
    required this.status,
    required this.remark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Combine materials into a readable string
    final String materialsText = materials.join(', ');

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Iconsax.location, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(location,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Iconsax.repeat_circle, color: Colors.teal),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text("Materials: $materialsText",
                        style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Iconsax.bag, color: Colors.orange),
                  SizedBox(width: 8),
                  Text("Bag Size: $bagSize", style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Iconsax.box, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(status, style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              if (remark.isNotEmpty && remark != "-") ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Iconsax.note_text, color: Colors.purple),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text("Remarks: $remark",
                          style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
