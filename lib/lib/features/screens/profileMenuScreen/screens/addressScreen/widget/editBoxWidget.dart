
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:flutter/material.dart';

editBoxWidget(BuildContext context, TextEditingController edtController, Function validationFunction, String label, String errorLabel, TextInputType inputType, {Widget? tailIcon, bool? isLastField, bool? isEditable = true}) {
  return TextFormField(
    enabled: isEditable,
    controller: edtController,
    textInputAction: isLastField == true ? TextInputAction.done : TextInputAction.next,
    decoration: InputDecoration(
      suffixIcon: tailIcon,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(color: ColorsRes.appColor, width: 1, style: BorderStyle.solid, strokeAlign: BorderSide.strokeAlignCenter),
      ),
      labelText: label,
      isDense: true,
      floatingLabelStyle: MaterialStateTextStyle.resolveWith(
        (Set<MaterialState> states) {
          final Color color = states.contains(MaterialState.error) ? Theme.of(context).colorScheme.error : ColorsRes.appColor;
          return TextStyle(color: color, letterSpacing: 1.3);
        },
      ),
    ),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: inputType,
    validator: (String? value) {
      if (value == null || value == '') {
        return errorLabel;
      }
      return null;
    },
  );
}
