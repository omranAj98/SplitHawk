import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class CollapsibleDatePicker extends StatefulWidget {
  final DateTime initialDate = DateTime.now();
  final Function(DateTime) onDateChanged;
  final String? label;

  CollapsibleDatePicker({
    super.key,
    initialDate,
    required this.onDateChanged,
    this.label,
  });

  @override
  State<CollapsibleDatePicker> createState() => _CollapsibleDatePickerState();
}

class _CollapsibleDatePickerState extends State<CollapsibleDatePicker> {
  late DateTime selectedDate;
  bool isDatePickerExpanded = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _showMaterialDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateChanged(picked);
    }
  }

  Widget _buildDatePicker() {
    if (Platform.isIOS) {
      return Container(
        height: 200,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          backgroundColor: Theme.of(context).colorScheme.surface,
          initialDateTime: selectedDate,
          maximumDate: DateTime.now().add(const Duration(days: 365)),
          minimumDate: DateTime.now().subtract(const Duration(days: 365)),
          onDateTimeChanged: (value) {
            setState(() {
              selectedDate = value;
            });
            widget.onDateChanged(value);
          },
        ),
      );
    } else {
      return Container(
        height: 300,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: CalendarDatePicker(
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateChanged: (value) {
            setState(() {
              selectedDate = value;
            });
            widget.onDateChanged(value);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlpha(40),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Date display - tappable area
              InkWell(
                onTap: () {
                  if (Platform.isAndroid) {
                    _showMaterialDatePicker();
                  } else {
                    setState(() {
                      isDatePickerExpanded = !isDatePickerExpanded;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Icon(
                        Platform.isIOS
                            ? (isDatePickerExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down)
                            : Icons.calendar_today,
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable date picker (only for iOS)
              if (isDatePickerExpanded && Platform.isIOS) _buildDatePicker(),
            ],
          ),
        ),
      ],
    );
  }
}
