import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoListScreen extends StatelessWidget {
  final List<String> videoTitles = [
    'The Wall Slide',
    'Clam Shell',
    'Bridge / Hip Raises',
  ];

  final List<String> videoUrls = [
    'https://drive.google.com/uc?id=1DhpMRyBrLWBh8vC-Sh_jnTaFVo7RbPAy',
    'https://drive.google.com/uc?id=1LSJ6l3DjCUZiOoF4GkwN61BWiP80wpzI',
    'https://drive.google.com/uc?id=1ArKnAKNpD6GzhzUn5xMyzXcR5zDj939s',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trimister One'),
      ),
      body: ListView.builder(
        itemCount: videoTitles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(videoTitles[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    videoTitle: videoTitles[index],
                    videoUrl: videoUrls[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoTitle;
  final String videoUrl;

  VideoPlayerScreen({required this.videoTitle, required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
    );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoTitle),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
