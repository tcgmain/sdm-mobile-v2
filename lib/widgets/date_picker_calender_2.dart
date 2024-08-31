import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker {
  static Widget buildDateSelectionFormField({
    required TextEditingController controller,
    required String label,
    required String fieldName,
    required FocusNode focusNode,
    required BuildContext context,
    required String? Function(String?) validator,
    required void Function(String fieldName) validateField,
    required Map<String, bool?> validationStatus,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black), 
            suffixIcon: validationStatus[fieldName] == null
                ? null
                : validationStatus[fieldName]!
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.error, color: Colors.red),
          ),
          readOnly: true,
          focusNode: focusNode,
          validator: validator,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode()); // To prevent opening the keyboard
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1920),
              lastDate: DateTime(2101),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Colors.red, // Red background for selected date
                      onPrimary: Colors.white, // Text color for selected date
                      onSurface: Colors.black, // Default text color for unselected dates
                    ),
                    dialogBackgroundColor: Colors.white,
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
              controller.text = formattedDate;
              validateField(fieldName);
            }
          },
        ),
      ],
    );
  }
}
