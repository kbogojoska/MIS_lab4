import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/exam.dart';
import '../providers/exam_provider.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  LatLng _selectedLocation = LatLng(41.9981, 21.4254);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _locationController = TextEditingController();
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
    });
  }

  void _submitExam() {
    if (_formKey.currentState!.validate()) {
      DateTime examDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      String title = _titleController.text;
      String location = _locationController.text;

      Exam exam = Exam(
        id: DateTime.now().toString(),
        subject: title,
        dateTime: examDateTime,
        location: _selectedLocation,
        locationName: location,
      );


      Provider.of<ExamProvider>(context, listen: false).addExam(exam);


      print("Submitting exam: $title, $examDateTime, $location");
      print("Selected Location: $_selectedLocation");

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Exam'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Name of Subject"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the subject name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: "Location"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the location";
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ListTile(
              title: Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text('Time: ${_selectedTime.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: _pickTime,
            ),
            SizedBox(height: 16.0),
            Container(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  center: _selectedLocation,
                  zoom: 13.0,
                  onTap: (tapPosition, latLng) => _onMapTap(latLng),
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitExam,
              child: Text('Add Exam'),
            ),
          ],
        ),
      ),
    );
  }
}

