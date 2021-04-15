import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  CustomPicker({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.day);
    this.setMiddleIndex(this.currentTime.month);
    this.setRightIndex(this.currentTime.year);
  }



  @override
  String leftStringAtIndex(int index) {
    if (index >= 1 && index < 32) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 1 && index < 13) {
      return months[index-1];
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 2021 && index < 2025) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(this.currentRightIndex(), this.currentMiddleIndex(), this.currentLeftIndex())
        : DateTime(this.currentRightIndex(), this.currentMiddleIndex(), this.currentLeftIndex());
  }


}