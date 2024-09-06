import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../login/login.dart';
import '../../academy.dart';
import '../evaluate_module.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String videoId;
  final Employee employee;
  final AcademyRespond academy;
  final String Function(String) videoView;
  const YouTubePlayerWidget(
      {Key? key,
      required this.videoId,
      required this.employee,
      required this.academy,
      required this.videoView})
      : super(key: key);

  @override
  _YouTubePlayerWidgetState createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  int? _lastStopTime;
  final Duration _startTime =
      Duration(seconds: 70); // Start Time เริ่มวินาทีที่ 10
  Duration _currentPosition =
      Duration.zero; // Variable to store current position

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Listen to player state changes to update the current time
    _controller.addListener(() {
      if (_controller.value.isPlaying && _controller.value.isReady) {
        setState(() {
          _currentPosition = _controller.value.position;
        });
      }

      // Save the stop time when video is paused or stopped
      if (!_controller.value.isPlaying) {
        _lastStopTime = _controller.value.position.inSeconds;
        // Save StopTime
        widget.videoView(_lastStopTime.toString());
        print('Video stopped at: $_lastStopTime');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('YouTube Player'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => EvaluateModule(
                        employee: widget.employee,
                        academy: widget.academy,
                        selectedPage: 1)),
              );
            },
          ),
        ),
        body: Scaffold(
          body: OrientationBuilder(
            builder: (context, orientation) {
              return YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  // aspectRatio : 1 / 1,
                  onReady: () {
                    print('Player is ready.');
                    // Seek to the start time when the player is ready
                    _controller.seekTo(_startTime);
                  },
                ),
                builder: (context, player) {
                  return SafeArea(
                    child: OrientationBuilder(
                      builder: (context, orientation) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: player,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FullScreenPlayer extends StatelessWidget {
  final YoutubePlayerController controller;

  const FullScreenPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}
