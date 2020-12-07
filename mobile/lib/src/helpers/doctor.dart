import '../models/activeDay.dart';
import 'package:health/health.dart';

class Doctor {
  static List<ActiveDay> parseActiveDays(List<HealthDataPoint> datapoints) {
    List<ActiveDay> activeDays = [];
    DateTime markerDate;
    datapoints.forEach((datapoint) {
      if (markerDate == null || datapoint.dateFrom.day != markerDate.day) {
        ActiveDay newDay = ActiveDay(
            date: datapoint.dateFrom.toLocal(),
            stepsTracked: datapoint.value.toInt());
        markerDate = datapoint.dateFrom;
        activeDays.add(newDay);
      } else {
        activeDays[activeDays.length - 1].stepsTracked +=
            datapoint.value.toInt();
      }
    });
    return activeDays;
  }
}
