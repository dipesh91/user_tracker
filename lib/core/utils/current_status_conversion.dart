import 'package:user_tracker/core/consts/app_enums.dart';

class CurrentStatusConversion {
  static CurrentStatus fetchStatusFromText(String text) {
    switch (text) {
      case 'checkedIn':
        return CurrentStatus.checkedIn;
      case 'checkedOut':
        return CurrentStatus.checkedOut;
      case 'InBreak':
        return CurrentStatus.inBreak;
      default:
        return CurrentStatus.notCheckedIn;
    }
  }

  static String fetchTextFromStatus(CurrentStatus status) {
    switch (status) {
      case CurrentStatus.checkedIn:
        return 'checkedIn';
      case CurrentStatus.checkedOut:
        return 'checkedOut';
      case CurrentStatus.inBreak:
        return 'InBreak';
      case CurrentStatus.notCheckedIn:
        return 'notCheckedIn';
    }
  }
}
