import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:sdm/utils/constants.dart';

class CustomDatePickerDialog extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<Color> color1;
  final dp.DatePickerRangeStyles? datePickerStyles;

  const CustomDatePickerDialog({super.key, 
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    required this.color1,
    this.datePickerStyles,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: color1,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: dp.DayPicker.single(
          selectedDate: selectedDate,
          onChanged: (DateTime date) {
            onDateSelected(date);
          },
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime(2100),
          datePickerStyles: datePickerStyles ?? dp.DatePickerRangeStyles(
            dayHeaderStyleBuilder: (int day) {
              return const dp.DayHeaderStyle(
                textStyle: TextStyle(
                  color: CustomColors.calenderTitleTextColor, // Customize the day header text color
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(120, 170, 97, 0), // Customize the day header background color
                ),
              );
            },
            selectedSingleDateDecoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            defaultDateTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: CustomColors.calenderTextColor,
            ),
            currentDateStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 153, 0),
            ),
            disabledDateStyle: const TextStyle(
              color: Colors.grey,
            ),
            displayedPeriodTitle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: CustomColors.calenderTitleTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
