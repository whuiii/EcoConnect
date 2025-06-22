import 'package:flutter/material.dart';
import 'package:navigate/color.dart';

class BagSizeSelector extends StatefulWidget {
  const BagSizeSelector({super.key});

  @override
  State<BagSizeSelector> createState() => _BagSizeSelectorState();
}

class _BagSizeSelectorState extends State<BagSizeSelector> {
  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: Text('Small Bag (1-2 bags)', style: TextName),
          value: 'Small',
          groupValue: _selectedSize,
          onChanged: (value) {
            setState(() {
              _selectedSize = value;
            });
          },
        ),
        RadioListTile<String>(
          title: Text('Medium Bag (3-5 bags)', style: TextName),
          value: 'Medium',
          groupValue: _selectedSize,
          onChanged: (value) {
            setState(() {
              _selectedSize = value;
            });
          },
        ),
        RadioListTile<String>(
          title: Text('Large Bag (>5 bags)', style: TextName),
          value: 'Large',
          groupValue: _selectedSize,
          onChanged: (value) {
            setState(() {
              _selectedSize = value;
            });
          },
        ),
      ],
    );
  }
}
