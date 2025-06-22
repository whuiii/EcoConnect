import 'package:flutter/material.dart';
import 'package:navigate/color.dart';

class BagSizeSelector extends StatefulWidget {
  final String? selectedSize;
  final Function(String) onChanged;

  const BagSizeSelector({
    super.key,
    required this.selectedSize,
    required this.onChanged,
  });

  @override
  State<BagSizeSelector> createState() => _BagSizeSelectorState();
}

class _BagSizeSelectorState extends State<BagSizeSelector> {
  late String? _currentSize;

  @override
  void initState() {
    super.initState();
    _currentSize = widget.selectedSize;
  }

  void _handleSelection(String? value) {
    setState(() {
      _currentSize = value;
    });
    if (value != null) {
      widget.onChanged(value);  // <-- pass selected value to parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: Text('Small Bag (1-2 bags)', style: TextName),
          value: 's',
          groupValue: _currentSize,
          onChanged: _handleSelection,
        ),
        RadioListTile<String>(
          title: Text('Medium Bag (3-5 bags)', style: TextName),
          value: 'm',
          groupValue: _currentSize,
          onChanged: _handleSelection,
        ),
        RadioListTile<String>(
          title: Text('Large Bag (>5 bags)', style: TextName),
          value: 'l',
          groupValue: _currentSize,
          onChanged: _handleSelection,
        ),
      ],
    );
  }
}