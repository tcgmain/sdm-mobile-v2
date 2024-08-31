// import 'package:flutter/material.dart';

// class CustomTextFormField {
//   static Widget buildValidatedTextFormField({
//     required TextEditingController controller,
//     required String label,
//     required String fieldName,
//     required FocusNode focusNode,
//     TextInputType keyboardType = TextInputType.text, // Optional parameter with default value
//     required String? Function(String?) validator,
//     required void Function(String fieldName) validateField,
//     required Map<String, bool?> validationStatus,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: label,
//             labelStyle: const TextStyle(color: Colors.black), // Replace with CustomColors if needed
//             suffixIcon: validationStatus[fieldName] == null
//                 ? null
//                 : validationStatus[fieldName]!
//                     ? const Icon(Icons.check, color: Colors.green)
//                     : const Icon(Icons.error, color: Colors.red),
//           ),
//           keyboardType: keyboardType,
//           focusNode: focusNode,
//           validator: validator,
//           onChanged: (value) {
//             validateField(fieldName);
//           },
//         ),
//       ],
//     );
//   }
// }
