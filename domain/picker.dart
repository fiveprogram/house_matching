import 'package:flutter/material.dart';

// typedef FireDoc = Map<String,dynamic>;

@immutable
class PickerFormField extends StatefulWidget {
  const PickerFormField(
      {required this.pickerController,
      required this.hintText,
      required this.picker,
      Key? key})
      : super(key: key);
  final TextEditingController? pickerController;
  final String? hintText;
  final VoidCallback picker;

  @override
  State<PickerFormField> createState() => _PickerFormFieldState();
}

class _PickerFormFieldState extends State<PickerFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: () {
        widget.picker();
        setState(() {});
      },
      controller: widget.pickerController,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            onPressed: () {
              widget.pickerController!.clear();
            },
            icon: const Icon(Icons.clear),
          )),
    );
  }
}
