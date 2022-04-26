import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/services/app_brain.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class VideoCall {
  int remoteUid = 0;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(AgoraManager.appId);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          _localUserJoined = true;
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          remoteUid = uid;
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          remoteUid = 0;
        },
      ),
    );

    await _engine.joinChannel(
        AgoraManager.token, AgoraManager.channelName, null, 0);
  }

  Future<void> leaveCalling() async {
    toastMessage(message: "leave calling");
    return await _engine.leaveChannel();
  }

  Widget renderLocalPreview() {
    return const RtcLocalView.SurfaceView(
    );
  }

//remote User View

  Widget renderRemoteVideo() {
    if (remoteUid != 0) {
      return RtcRemoteView.SurfaceView(
        uid: remoteUid,
        channelId: "",
      );
    } else {
      return const Text("Calling …", textAlign: TextAlign.center);
    }
  }
}
