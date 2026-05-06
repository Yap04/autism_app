import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  static const String _tokenServerUrl =
      'https://fyp-api-sandy.vercel.app/api/agora-token';

  RtcEngine? _engine;

  RtcEngine get engine {
    if (_engine == null) {
      throw Exception('Agora Engine is not initialized yet!');
    }
    return _engine!;
  }

  Future<void> initializeAndJoin({
    required String channelName,
    required String role,
    required VoidCallback onLocalJoined,
    required void Function(int remoteUid) onRemoteJoined,
    required void Function(int remoteUid) onRemoteOffline,
    required void Function(String errorMsg) onError,
  }) async {
    try {
      await [Permission.microphone, Permission.camera].request();

      final response = await http.post(
        Uri.parse(_tokenServerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'channelName': channelName, 'uid': 0, 'role': role}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch token: ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['token'] as String;
      final appId = data['appId'] as String;

      _engine = createAgoraRtcEngine();
      await _engine!.initialize(
        RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint('local user ${connection.localUid} joined');
            onLocalJoined();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint('remote user $remoteUid joined');
            onRemoteJoined(remoteUid);
          },
          onUserOffline: (
            RtcConnection connection,
            int remoteUid,
            UserOfflineReasonType reason,
          ) {
            debugPrint('remote user $remoteUid left channel');
            onRemoteOffline(remoteUid);
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint('Agora Error: $err - $msg');
            onError(msg);
          },
        ),
      );

      await _engine!.enableVideo();
      await _engine!.startPreview();

      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: 0,
        options: const ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
    } catch (e) {
      debugPrint('Agora Init Error: $e');
      onError(e.toString());
    }
  }

  Future<void> toggleMute(bool isMuted) async {
    if (_engine == null) {
      return;
    }
    await _engine!.muteLocalAudioStream(isMuted);
  }

  Future<void> toggleVideo(bool isVideoDisabled) async {
    if (_engine == null) {
      return;
    }

    await _engine!.enableLocalVideo(!isVideoDisabled);
  }

  Future<void> leaveAndRelease() async {
    if (_engine == null) {
      return;
    }

    try {
      await _engine!.leaveChannel();
      await _engine!.release();
      _engine = null;
    } catch (e) {
      debugPrint('Error leaving channel: $e');
    }
  }
}
