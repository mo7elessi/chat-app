import 'package:chat_app/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
double radius = 5.0;
double width = double.infinity;

Widget textInputField(
    {required TextEditingController controller,
    required TextInputType keyboard,
    required MultiValidator validator,
    Function? validatorFunc,
    required String hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Function? suffixIconPressed,
    required context,
    Function? onSubmit,
    Function? onChange,
    bool confirmPass = false,
    bool description = false}) {
  return  SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(fontSize: 14),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: () => suffixIconPressed!(),
                )
              : null,
          prefixIcon: Icon(prefixIcon),
        ),
        validator: validator,
        //  onChanged: (value) => onChange!(value),
      ),

  );
}

Widget textInputFieldToOTP({
  required TextEditingController controller,
  required context,
  Function? onChange,
}) {
  return  SizedBox(
    height: 80,
    child: TextFormField(
      maxLength: 6,
      maxLines: 6,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 14),
      decoration: const InputDecoration(
          hintText: "Enter code here", fillColor: Colors.white, filled: true),
      onChanged: (value) => onChange!(value),
  ),);
}

Widget primaryButton({
  required Function function,
  required String text,
  Color color = primaryColor,
  double height = 55,
}) {
  return  Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
      ),
      child: MaterialButton(
        minWidth: width,
        onPressed: () => function(),
        child: Center(
          child: Text(text.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
}

Widget secondaryButton({
  required Function function,
  required String text,
  Color color = primaryColor,
  double height = 55,
}) {
  return SizedBox(
      height: height,
      child: OutlinedButton(
        child: Text(text.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            )),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const RoundedRectangleBorder()),
        ),
        onPressed: () => function(),
      ),
  );
}


void toastMessage({required String message}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 14.0);
}

Widget spaceBetween({double size = 6.0, bool vertical = true}) {
  return vertical ? SizedBox(height: size) : SizedBox(width: size);
}

Widget logo(){
  return Align(
    alignment: AlignmentDirectional.topCenter,
    child: Row(
      children: [
        const Image(
          image: AssetImage("assets/images/logoChat.png"),
          height: 40,
        ),
        spaceBetween(vertical: false),
        const Text(
          "CHATME",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
        )
      ],
    ),
  );
}

