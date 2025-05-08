import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String getTimeAgo(int timestampMillis) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestampMillis);

  timeago.setLocaleMessages("en", MyCustomMessages());

  return timeago.format(dateTime, locale: "en", allowFromNow: true);
}

class MyCustomMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => '';

  @override
  String suffixFromNow() => '';

  @override
  String lessThanOneMinute(int seconds) => 'just now';

  @override
  String aDay(int hours) => "Yesterday";

  @override
  String aboutAMinute(int minutes) => "$minutes min ago";

  @override
  String aboutAMonth(int days) => "$days days ago";

  @override
  String aboutAYear(int year) => "$year year ago";

  @override
  String aboutAnHour(int minutes) => "$minutes min ago";

  @override
  String days(int days) => "$days days ago";

  @override
  String hours(int hours) => "$hours hours ago";

  @override
  String minutes(int minutes) => "$minutes min ago";

  @override
  String months(int months) => "$months months ago";

  @override
  String wordSeparator() => "";

  @override
  String years(int years) => "ago";
}

String getTimeFromTimeStamp(String timeStamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
  return DateFormat("hh:mm a").format(dateTime);
}
