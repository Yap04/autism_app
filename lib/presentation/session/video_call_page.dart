import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';
import '../../../infrastructure/services/agora_service.dart';

@RoutePage()
class VideoCallPage extends StatefulWidget {
  const VideoCallPage({
    required this.channelName,
    required this.role,
    super.key,
  });
  final String channelName;
  final String role;

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final AgoraService _agoraService = AgoraService();

  int? _remoteUid;
  bool _localUserJoined = false;
  bool _muted = false;
  bool _videoDisabled = false;

  @override
  void initState() {
    super.initState();
    _startCall();
  }

  Future<void> _startCall() async {
    await _agoraService.initializeAndJoin(
      channelName: widget.channelName,
      role: widget.role,
      onLocalJoined: () {
        setState(() => _localUserJoined = true);
      },
      onRemoteJoined: (remoteUid) {
        setState(() => _remoteUid = remoteUid);
      },
      onRemoteOffline: (remoteUid) {
        setState(() => _remoteUid = null);
      },
      onError: (errorMsg) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Call Error: $errorMsg')));
        }
      },
    );
  }

  @override
  void dispose() {
    _agoraService.leaveAndRelease();
    super.dispose();
  }

  void _onCallEnd() {
    context.router.maybePop();
  }

  void _onToggleMute() {
    setState(() => _muted = !_muted);
    _agoraService.toggleMute(_muted);
  }

  void _onToggleVideo() {
    setState(() => _videoDisabled = !_videoDisabled);
    _agoraService.toggleVideo(_videoDisabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: _remoteVideo()),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ColoredBox(
                      color: ThemeColor.darkBlue.withValues(alpha: 0.3),
                      child:
                          _localUserJoined
                              ? (_videoDisabled
                                  ? const Center(
                                    child: Icon(
                                      Icons.videocam_off,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                  : AgoraVideoView(
                                    controller: VideoViewController(
                                      rtcEngine: _agoraService.engine,
                                      canvas: const VideoCanvas(uid: 0),
                                    ),
                                  ))
                              : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
              ),
            ),
            _toolbar(),
          ],
        ),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _agoraService.engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return const Text(
        'Waiting for other user to join...',
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            shape: const CircleBorder(),
            fillColor: _muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(15),
            child: Icon(
              _muted ? Icons.mic_off : Icons.mic,
              color: _muted ? Colors.white : Colors.blueAccent,
              size: 24,
            ),
          ),
          RawMaterialButton(
            onPressed: _onCallEnd,
            shape: const CircleBorder(),
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15),
            child: const Icon(Icons.call_end, color: Colors.white, size: 35),
          ),
          RawMaterialButton(
            onPressed: _onToggleVideo,
            shape: const CircleBorder(),
            fillColor: _videoDisabled ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(15),
            child: Icon(
              _videoDisabled ? Icons.videocam_off : Icons.videocam,
              color: _videoDisabled ? Colors.white : Colors.blueAccent,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
