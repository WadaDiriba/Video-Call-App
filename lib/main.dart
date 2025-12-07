
import 'package:flutter/material.dart';
import 'package:wadacallapp/screeens/meeting_home.dart';

void main() {
  runApp(WadaCallAPP());
}

class WadaCallAPP extends StatelessWidget {
  // Replace with your ZEGOCLOUD AppID and AppSign
  final int appID = 466885970;
  final String appSign =
      "7f05e2db2a72e054ae38aacbc8218e11b717319553cb6768e4cb9c02a041bfc0";

  const WadaCallAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MeetingHome(appID: appID,
       appSign: appSign),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    
    );
  }
}

