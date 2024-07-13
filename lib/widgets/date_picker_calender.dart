import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:sdm/utils/constants.dart';

class CustomDatePickerDialog extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final dp.DatePickerRangeStyles? datePickerStyles;

  const CustomDatePickerDialog({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
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
            colors: [
              CustomColors.calenderBackgroundColor1,
              CustomColors.calenderBackgroundColor2.withOpacity(0.8),
            ],
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
          datePickerStyles: datePickerStyles ??
              dp.DatePickerRangeStyles(
                dayHeaderStyleBuilder: (int day) {
                  return const dp.DayHeaderStyle(
                    textStyle: TextStyle(
                      color: CustomColors.calenderTitleTextColor, // Customize the day header text color
                      fontWeight: FontWeight.bold,
                    ),
                    // decoration: BoxDecoration(
                    //   color: CustomColors.calenderBackgroundColor1, // Customize the day header background color
                    // ),
                  );
                },
                selectedSingleDateDecoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 29, 23).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                defaultDateTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.calenderTextColor,
                ),
                currentDateStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.buttonColor,
                ),
                disabledDateStyle: const TextStyle(
                  color: CustomColors.textColorGrey,
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
