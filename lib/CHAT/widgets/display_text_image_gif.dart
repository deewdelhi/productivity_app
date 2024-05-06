import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/models/message.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //bool isPlaying = false;
    //final AudioPlayer audioPlayer = AudioPlayer();

    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints: const BoxConstraints(
                    minWidth: 100,
                  ),
                  onPressed: () async {
                    // if (isPlaying) {
                    //   await audioPlayer.pause();
                    //   setState(() {
                    //     isPlaying = false;
                    //   }
                    //   );
                    // } else {
                    //   await audioPlayer.play(UrlSource(message));
                    //   setState(() {
                    //     isPlaying = true;
                    //   });
                    // }
                  },
                  icon: Icon(Icons.pause_circle
                      // isPlaying ? Icons.pause_circle : Icons.play_circle,

                      ),
                );
              })
            : type == MessageEnum.video
                ? Text("video player")
                : type == MessageEnum.gif
                    ? Text("gif")
                    : CachedNetworkImage(
                        imageUrl: message,
                      );
  }
}
