import 'package:custom_date_range_picker/custom_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateRangePicker extends StatefulWidget {
  const CustomDateRangePicker({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onApplyClick,
    this.barrierDismissible = true,
    required this.minimumDate,
    required this.maximumDate,
    required this.onCancelClick,
    this.weekendDays,
    this.holidays,
    this.onVacationDayClicked,
  }) : super(key: key);
  final Function(String)? onVacationDayClicked;
  final List<int>? weekendDays;
  final List<DateTime>? holidays;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final bool barrierDismissible;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime, DateTime) onApplyClick;
  final Function() onCancelClick;

  @override
  CustomDateRangePickerState createState() => CustomDateRangePickerState();
}

class CustomDateRangePickerState extends State<CustomDateRangePicker> with TickerProviderStateMixin {
  AnimationController? animationController;

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'From',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    startDate != null ? DateFormat('EEE, dd MMM').format(startDate!) : '--/-- ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 74,
              width: 1,
              color: Theme.of(context).dividerColor,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'To',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    endDate != null ? DateFormat('EEE, dd MMM').format(endDate!) : '--/-- ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider(
          height: 1,
        ),
        CustomCalendar(
          minimumDate: widget.minimumDate,
          maximumDate: widget.maximumDate,
          initialEndDate: widget.initialEndDate,
          initialStartDate: widget.initialStartDate,
          weekendDays: widget.weekendDays,
          holidays: widget.holidays,
          onVacationDayClicked: widget.onVacationDayClicked,
          startEndDateChange: (DateTime startDateData, DateTime endDateData) {
            setState(() {
              startDate = startDateData;
              endDate = endDateData;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
          child: Row(
            children: [
              DialogActionButton(
                onTap: () {
                  widget.onCancelClick();
                },
                label: 'Cancel',
              ),
              const SizedBox(width: 16),
              DialogActionButton(
                onTap: () {
                  widget.onApplyClick(startDate!, endDate!);
                },
                label: 'Apply',
              ),
            ],
          ),
        )
      ],
    );
  }
}

class DialogActionButton extends StatelessWidget {
  const DialogActionButton({
    required this.onTap,
    required this.label,
  });
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(17.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: OutlinedButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor)),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(17.0)),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            onPressed: () {
              onTap();
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `showCustomDateRangePicker(
///   BuildContext context, {
///   required bool dismissible,
///   required DateTime minimumDate,
///   required DateTime maximumDate,
///   DateTime? startDate,
///   DateTime? endDate,
///   required Function(DateTime startDate, DateTime endDate) onApplyClick,
///   required Function() onCancelClick,
///   Color? backgroundColor,
///   Color? primaryColor,
///   String? fontFamily,
/// })`
void showCustomDateRangePicker(
  BuildContext context, {
  required bool dismissible,
  required DateTime minimumDate,
  required DateTime maximumDate,
  DateTime? startDate,
  DateTime? endDate,
  required Function(DateTime startDate, DateTime endDate) onApplyClick,
  required Function() onCancelClick,
  Color? backgroundColor,
  Color? primaryColor,
  String? fontFamily,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) => CustomDateRangePicker(
      barrierDismissible: true,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      initialStartDate: startDate,
      initialEndDate: endDate,
      onApplyClick: onApplyClick,
      onCancelClick: onCancelClick,
    ),
  );
}
