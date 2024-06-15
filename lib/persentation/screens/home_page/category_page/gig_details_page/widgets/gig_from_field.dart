import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

// This is the refactored GigFormField this is the from used to enter
// the gig details in the application
class GigFromField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? prefixText;
  final bool acceptOnlyNumbers;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const GigFromField({
    super.key,
    required this.controller,
    required this.title,
    required this.acceptOnlyNumbers,
    this.prefixText,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      style: const TextStyle(color: mainColor),
      onChanged: (value) {},
      textInputAction: TextInputAction.next,
      keyboardType:
          acceptOnlyNumbers ? TextInputType.number : TextInputType.text,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: mainColor, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: mainColor, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: title,
        hintStyle: const TextStyle(color: kgrey, fontSize: 20),
        //This is the prefix which is used for the enter the offer
        prefix: prefixText != null && prefixText!.isNotEmpty
            ? Text('$prefixText')
            : null,
      ),
    );
  }
}
