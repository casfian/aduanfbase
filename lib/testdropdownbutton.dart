
import 'package:flutter/material.dart';

class TestDropDownButton extends StatefulWidget {
  const TestDropDownButton({super.key});

  @override
  State<TestDropDownButton> createState() => _TestDropDownButtonState();
}

class _TestDropDownButtonState extends State<TestDropDownButton> {

String? _dropdownValue;

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
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Center(
        child: DropdownButton(
          items: const [
            DropdownMenuItem(value: 'Apple', child: Text('Apple')),
            DropdownMenuItem(value: 'Banana', child: Text('Banana')),
            DropdownMenuItem(value: 'Coconut', child: Text('Coconut')),
          ],
          value: _dropdownValue,
          onChanged: dropdownCallback,
        ),
      ),
    );
  }
}

