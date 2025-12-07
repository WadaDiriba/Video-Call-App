import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wadacallapp/screeens/video_screen.dart';

class MeetingHome extends StatefulWidget {
  final int appID;
  final String appSign;
  
  MeetingHome({required this.appID,
   required this.appSign});

  @override
  State<MeetingHome> createState() => _MeetingHomeState();
}

class _MeetingHomeState extends State<MeetingHome> {
  String username = "";
  String userID = ""; // Add this line
  String meetingID = "";
  bool _isJoining = false;

  TextEditingController joinController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String generateMeetingID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return List.generate(8, (index) => chars[rnd.nextInt(chars.length)]).join();
  }

  @override
  void initState() {
    super.initState();
    // Pre-generate a meeting ID for better UX
    meetingID = generateMeetingID();
  }

  @override
  void dispose() {
    joinController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return username.isEmpty ? enterNameScreen() : meetingOptionsScreen();
  }

  // Step 1: Enter your name
  Widget enterNameScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Your Name"),
        elevation: 0,
        
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.video_camera_front,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Welcome to WadaCall",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your name to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (value) => _continueToMeeting(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _continueToMeeting,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _continueToMeeting() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your name"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Generate a unique user ID by combining name and timestamp
    final uniqueUserID = "${name}_${DateTime.now().millisecondsSinceEpoch}";
    
    setState(() {
      username = name;
      // Use the generated unique user ID instead of just the name
      userID = uniqueUserID;
    });
  }

  // Step 2: Meeting Options (Host / Join)
  Widget meetingOptionsScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, $username"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              setState(() {
                username = "";
                nameController.clear();
                joinController.clear();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.video_call,
                      size: 60,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Start a New Meeting",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Meeting ID: $meetingID",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.videocam),
                        label: const Text("Start Meeting"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoCallScreen(
                                appID: widget.appID,
                                appSign: widget.appSign,
                                userID: userID, // Use the unique user ID
                                userName: username,
                                meetingID: meetingID,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "OR",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.group_add,
                      size: 60,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Join a Meeting",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: joinController,
                      decoration: InputDecoration(
                        hintText: "Enter Meeting ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.meeting_room),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: _isJoining
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : const Icon(Icons.login),
                        label: Text(_isJoining ? "Joining..." : "Join Meeting"),
                        onPressed: _isJoining
                            ? null
                            : () {
                                final meetingId = joinController.text.trim();
                                if (meetingId.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please enter a meeting ID"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _isJoining = true;
                                });

                                // Simulate network delay
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  setState(() {
                                    _isJoining = false;
                                  });
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoCallScreen(
                                        appID: widget.appID,
                                        appSign: widget.appSign,
                                        userID: userID, // Use the unique user ID
                                        userName: username,
                                        meetingID: meetingId.toUpperCase(),
                                      ),
                                    ),
                                  );
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Step 3: Video Call Screen
