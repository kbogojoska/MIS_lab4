import 'package:latlong2/latlong.dart';

class Exam {
  final String id;
  String subject;
  DateTime dateTime;
  LatLng location;
  String locationName;

  Exam({
    required this.id,
    required this.subject,
    required this.dateTime,
    required this.location,
    required this.locationName
  });
}