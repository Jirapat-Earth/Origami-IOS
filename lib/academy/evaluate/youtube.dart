import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeScreen extends StatefulWidget {
  @override
  _YouTubeScreenState createState() => _YouTubeScreenState();
}

class _YouTubeScreenState extends State<YouTubeScreen> {
  late YoutubePlayerController _controller;
  late String videoId = 'KpDQhbYzf4Y'; // Replace with your video ID
  double _stoppedPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStoppedPosition(); // Load the saved position

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _controller.addListener(() {
      if (!_controller.value.isPlaying) {
        _saveStoppedPosition();
      }
    });

  }

  Future<void> _loadStoppedPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _stoppedPosition = prefs.getDouble('stoppedPosition_$videoId') ?? 0.0;
    _controller.seekTo(Duration(seconds: _stoppedPosition.toInt()));
  }

  Future<void> _saveStoppedPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('stoppedPosition_$videoId', _controller.value.position.inSeconds.toDouble());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('YouTube Player')),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          return Column(
            children: [
              player,
              ElevatedButton(
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _saveStoppedPosition();
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
}
