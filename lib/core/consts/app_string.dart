class AppString {
  static final weeks = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static final monthsList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  //total office working duration

  static final officeOut = DateTime.now().weekday == DateTime.saturday
      ? DateTime.now().copyWith(hour: 13, minute: 30, second: 0)
      : DateTime.now().copyWith(hour: 18, minute: 0, second: 0);

  // tables names

  static final profileTable = 'profiles';
  static final attendanceTable = 'attendance_logs';
}
