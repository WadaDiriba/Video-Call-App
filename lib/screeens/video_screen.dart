import'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatefulWidget {
  final int appID;
  final String appSign;
  final String userID;
  final String userName;
  final String meetingID;

  const VideoCallScreen({
    Key? key,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.meetingID,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent going back when in call
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Meeting: ${widget.meetingID}",
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.blueGrey[800],
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: ZegoUIKitPrebuiltCall(
            appID: widget.appID,
            appSign: widget.appSign,
            userID: widget.userID, // Unique user ID
            userName: widget.userName,
            callID: widget.meetingID,
            config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              ..turnOnCameraWhenJoining = true
              ..turnOnMicrophoneWhenJoining = true
              ..avatarBuilder = (BuildContext context, Size size, dynamic user, Map<String, dynamic> extraInfo) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      widget.userName.isNotEmpty
                          ? widget.userName.substring(0, 1).toUpperCase()
                          : "?",
                      style: TextStyle(
                        fontSize: size.width / 2,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                maxCount: 5,
              ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: FloatingActionButton.extended(
            icon: const Icon(Icons.share),
            label: const Text("Share ID"),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed: () {
              _shareMeetingID(context);
            },
          ),
        ),
      ),
    );
  }

  void _shareMeetingID(BuildContext context) {
    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: widget.meetingID)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Meeting ID copied to clipboard!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });

    // Share via other apps
    Share.share(
      "Join my video call on WadaCall!\n\nMeeting ID: ${widget.meetingID}\n\nJoin now!",
      subject: "Join my WadaCall meeting",
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}