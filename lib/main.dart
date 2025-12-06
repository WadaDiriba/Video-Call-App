import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final int appID = 466885970;
  final String appSign = "7f05e2db2a72e054ae38aacbc8218e11b717319553cb6768e4cb9c02a041bfc0";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MeetingHome(appID: appID, appSign: appSign),
    );
  }
}

class MeetingHome extends StatefulWidget {
  final int appID;
  final String appSign;
  MeetingHome({required this.appID, required this.appSign});

  @override
  State<MeetingHome> createState() => _MeetingHomeState();
}

class _MeetingHomeState extends State<MeetingHome> {
  String username = "";
  String meetingID = "";

  String generateMeetingID() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random rnd = Random();
    return List.generate(8, (index) => chars[rnd.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return username.isEmpty
        ? enterNameScreen()
        : meetingScreen();
  }

  Widget enterNameScreen() {
    final nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Enter Your Name")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Your Name"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    username = nameController.text.trim();
                    meetingID = generateMeetingID();
                  });
                },
                child: Text("Start Meeting"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget meetingScreen() {
    return Scaffold(

      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Meeting: $meetingID")),
      body: ZegoUIKitPrebuiltCall(
        appID: widget.appID,
        appSign: widget.appSign,
        userID: username,
        userName: username,
        callID: meetingID,
        config: ZegoUIKitPrebuiltCallConfig.groupVideoCall(), // or use another config as needed
      ),
    );
  }
}
