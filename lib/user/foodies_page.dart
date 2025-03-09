import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FoodiesPage extends StatefulWidget {
  @override
  _FoodiesPageState createState() => _FoodiesPageState();
}

class _FoodiesPageState extends State<FoodiesPage> {
  // List of video URLs
  final List<String> videoUrls = [
    'https://moodpandaa.com/videos/a.mp4',
   'https://moodpandaa.com/videos/b.mp4',
   'https://moodpandaa.com/videos/c.mp4',
   'https://moodpandaa.com/videos/d.mp4',
   'https://moodpandaa.com/videos/e.mp4',
   'https://moodpandaa.com/videos/f.mp4',
   'https://moodpandaa.com/videos/g.mp4',
   'https://moodpandaa.com/videos/h.mp4',

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        title: Text(
          'Foodies Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        itemCount: videoUrls.length,
        scrollDirection:
            Axis.vertical, // Vertical scrolling like Instagram Reels or TikTok
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: VideoPlayerWidget(videoUrl: videoUrls[index], index: index),
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final int index;

  const VideoPlayerWidget({required this.videoUrl, required this.index});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return VisibilityDetector(
      key: Key(widget.index.toString()), // Unique key for each video
      onVisibilityChanged: (visibilityInfo) {
        // Play the video if it's fully visible
        if (visibilityInfo.visibleFraction == 1.0) {
          setState(() {
            if (!isPlaying) {
              _controller.play();
              isPlaying = true;
            }
          });
        } else {
          setState(() {
            if (isPlaying) {
              _controller.pause();
              isPlaying = false;
            }
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
            isPlaying = !isPlaying;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            if (!isPlaying)
              Icon(
                Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
