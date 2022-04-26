import 'package:flutter/material.dart';
import '../../shared/services/video_call.dart';

class VideoAudioCallScreen extends StatelessWidget {
  const VideoAudioCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoCall().initAgora();
    String callType = "video";

    return Scaffold(
      body: Stack(
        children: [
          if (callType == "video")
            Column(
              children: [
                Center(
                  child: VideoCall().renderRemoteVideo(),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                            height: 120,
                            width: 120,
                            child: VideoCall().renderLocalPreview()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (callType == "audio")
            Center(
              child: Text(VideoCall().remoteUid == 0
                  ? "Calling"
                  : "Calling with ${VideoCall().remoteUid}"),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        VideoCall().leaveCalling();
                        Navigator.of(context).pop(true);
                      },
                      icon: const Icon(
                        Icons.call_end,
                        size: 50,
                        color: Colors.redAccent,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
