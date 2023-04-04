import 'package:flutter/material.dart';

class PromiseCheckBox extends StatefulWidget {

  final String? promiseText;
  final bool isChecked;
  const PromiseCheckBox({super.key, this.promiseText, this.isChecked = false});

  @override
  State<PromiseCheckBox> createState() => _PromiseCheckBoxState();
}

class _PromiseCheckBoxState extends State<PromiseCheckBox> {
  bool isChecked = false;
  String? promise;

  @override
  void initState() {
    super.initState();
    setState(() {
      promise = widget.promiseText;
      isChecked = widget.isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        Checkbox(value: isChecked, onChanged: (value) {
          setState(() {
            isChecked = value!;
          });
        },  
        activeColor: Colors.red),
        Expanded(
          child: TextField(
          onChanged: (value) {
            promise = value;
          } ,
          textAlign: TextAlign.start,
          controller: (promise == null) ? null : TextEditingController(text: promise),
          decoration: const InputDecoration(
            hintText: "Type promises",
            border: InputBorder.none,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),
          ), 
          style: TextStyle(
            fontSize: 14,
            color: !isChecked ? Theme.of(context).textTheme.bodyLarge?.color : Colors.red,
            fontWeight: FontWeight.w600
          ),
        ),
        )
      ],
    );
  }
}
