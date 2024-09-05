import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String videoId;

  const YouTubePlayerWidget({Key? key, required this.videoId}) : super(key: key);

  @override
  _YouTubePlayerWidgetState createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;
  late Duration _lastStopTime;
  final Duration _startTime = Duration(seconds: 10); // Start Time เริ่มวินาทีที่ 10
  Duration _currentPosition = Duration.zero; // Variable to store current position

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
        _lastStopTime = _controller.value.position;
        // Save StopTime
        print('Video stopped at: $_lastStopTime');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Player'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.fullscreen),
        //     onPressed: () {
        //       setState(() {
        //         _isFullScreen = !_isFullScreen;
        //         if (_isFullScreen) {
        //           Navigator.of(context).push(
        //             MaterialPageRoute(
        //               builder: (context) => FullScreenPlayer(controller: _controller),
        //             ),
        //           );
        //         } else {
        //           Navigator.of(context).pop();
        //         }
        //       });
        //     },
        //   ),
        // ],
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Player is ready.');
            // Seek to the start time when the player is ready
            _controller.seekTo(_startTime);
          },
        ),
        builder: (context, player) {
          return Column(
            children: [
              player,
              SizedBox(height: 10),
              // Display the current time of the video
              Text(
                'Current Time: ${_currentPosition.inMinutes}:${(_currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  setState(() {});
                },
                child: Text(_controller.value.isPlaying ? 'Pause' : 'Play'),
              ),
            ],
          );
        },
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

  const FullScreenPlayer({Key? key, required this.controller}) : super(key: key);

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
