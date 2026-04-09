import 'dart:math';
import 'package:flutter/material.dart';
import 'package:height_dial_picker/src/dial_painter.dart';

/// A customizable height picker widget with a dial-based UI.
///
/// This widget allows users to select height using a smooth horizontal drag.
/// It supports both feet (ft) and centimeters (cm) units and provides full UI customization.
class HeightDialPicker extends StatefulWidget {

  /// Minimum selectable height (default: 4 ft)
  final double minHeight;

  /// Maximum selectable height (default: 9 ft)
  final double maxHeight;

  /// Initial unit of measurement ('ft' or 'cm')
  final String initialUnit;

  /// Background color of the widget
  final Color backgroundColor;

  /// Selected toggle button color
  final Color selectedColor;

  /// Unselected toggle button color
  final Color unselectedColor;

  /// Main text color (height + unit)
  final Color textColor;

  /// Default tick color (not used directly but available for customization)
  final Color tickColor;

  /// Color of small ticks
  final Color smallTickColor;

  /// Color of big ticks
  final Color bigTickColor;

  /// Color of big ticks
  final Color centerLineColor;

  /// Color of selected tick indicator
  final Color selectedTickColor;

  /// Color of bottom label text (numbers)
  final Color labelTextColor;

  /// Callback triggered when height value changes
  final Function(double value, String unit) onChanged;

  /// Creates a [HeightDialPicker] widget.
  const HeightDialPicker({
    super.key,
    this.minHeight = 4,
    this.maxHeight = 9,
    this.initialUnit = 'ft',
    this.backgroundColor = const Color(0xFF0F172A),
    this.selectedColor = const Color(0xFF5D9AFF),
    this.unselectedColor = Colors.white,
    this.textColor = Colors.white,
    this.tickColor = const Color(0xFFBDBDBD),
    this.smallTickColor = const Color(0xFFBDBDBD),
    this.bigTickColor = const Color(0xFFBDBDBD),
    this.centerLineColor = const Color(0xFFBDBDBD),
    this.selectedTickColor = const Color(0xFF5D9AFF),
    this.labelTextColor = Colors.white,

    required this.onChanged,
  });

  @override
  State<HeightDialPicker> createState() => _HeightDialPickerState();
}
/// State class for [HeightDialPicker]
class _HeightDialPickerState extends State<HeightDialPicker> {

  /// Current rotation angle of the dial
  double angle = 0;

  /// Currently selected unit (ft/cm)
  late String selectedUnit;

  @override
  void initState() {
    selectedUnit = widget.initialUnit;
    super.initState();
  }

  /// Calculates the currently selected height based on dial position
  String get selectedHeight {
    final progress = angle / pi;
    final totalInches = widget.minHeight * 12 +
        (widget.maxHeight * 12 - widget.minHeight * 12) * progress;

    final inches = totalInches.round();

    if (selectedUnit == 'ft') {
      final feet = inches ~/ 12;
      final inch = inches % 12;
      return inch == 0 ? "$feet" : "$feet.$inch";
    } else {
      return (inches * 2.54).round().toString();
    }
  }

  /// Handles drag gesture and updates dial angle
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      angle += details.delta.dx * 0.01;
      angle = angle.clamp(0.0, pi);
    });

    final progress = angle / pi;
    final totalInches = widget.minHeight * 12 +
        (widget.maxHeight * 12 - widget.minHeight * 12) * progress;

    final inches = totalInches.round();

    if (selectedUnit == 'ft') {
      final feet = inches ~/ 12;
      final inch = inches % 12;
      widget.onChanged(double.parse("$feet.$inch"), selectedUnit);
    } else {
      widget.onChanged((inches * 2.54).roundToDouble(), selectedUnit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildUnitToggle(),
          const SizedBox(height: 20),

          /// Selected height display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedHeight,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                selectedUnit,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Dial painter widget
          GestureDetector(
            onPanUpdate: _onPanUpdate,
            child: CustomPaint(
              painter: DialPainter(
                angle: angle,
                min: widget.minHeight.toInt(),
                max: widget.maxHeight.toInt(),
                unit: selectedUnit,
                smallTickColor: widget.smallTickColor,
                bigTickColor: widget.bigTickColor,
                centerLineColor: widget.centerLineColor,
                selectedTickColor: widget.selectedTickColor,
                labelTextColor: widget.labelTextColor,
              ),
              size: const Size(double.infinity, 220),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the unit toggle (ft/cm)
  Widget _buildUnitToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['ft', 'cm'].map((unit) {
        final isSelected = selectedUnit == unit;

        return GestureDetector(
          onTap: () => setState(() => selectedUnit = unit),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            decoration: BoxDecoration(
              color: isSelected ? widget.selectedColor : widget.unselectedColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              unit,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}