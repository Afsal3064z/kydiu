import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/signup_page/widget/form_container/form_container_controller.dart';

//This is the form container for the all purpose of login  and signu[]
class FormContainerWidget extends StatelessWidget {
  final Key? fieldKey;
  final bool isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
  final TextEditingController? controller;

  const FormContainerWidget({
    super.key,
    required this.isPasswordField,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
    this.controller,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    final FormContainerController controller =
        Get.put(FormContainerController());

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: kwhite,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          width: 250,
          height: 50,
        ),
        Obx(
          () => TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(color: kblack),
            controller: this.controller,
            keyboardType: inputType,
            key: fieldKey,
            obscureText: isPasswordField ? controller.obscureText.value : false,
            onSaved: onSaved,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              errorStyle: const TextStyle(height: 0),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: controller.borderColor.value,
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              fillColor: kwhite,
              filled: true,
              hintText: hintText,
              hintStyle: const TextStyle(color: kgrey),
              suffixIcon: isPasswordField
                  ? GestureDetector(
                      onTap: () {
                        controller.toggleObscureText();
                      },
                      child: Icon(
                        controller.obscureText.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: controller.obscureText.value
                            ? Colors.grey
                            : mainColor,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
