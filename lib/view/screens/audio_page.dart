import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioPage extends StatefulWidget {
  final String name;
  final String image;
  final String song;
  final String madeby;
  const AudioPage(
      {Key? key,
      required this.name,
      required this.image,
      required this.song,
      required this.madeby})
      : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> with TickerProviderStateMixin {
  AssetsAudioPlayer myPlayer = AssetsAudioPlayer();
  Duration Max = Duration.zero;
  AnimationController? myIconController;
  AnimationController? myIconController2;

  bool Play = true;

  SliderComponentShape? myThumb = SliderComponentShape.noThumb;

  @override
  void initState() {
    super.initState();

    myIconController = AnimationController(
      vsync: this,
      duration: const Duration(
        microseconds: 250,
      ),
    );
    myIconController2 = AnimationController(
      vsync: this,
      duration: const Duration(
        microseconds: 250,
      ),
    );

    myPlayer
        .open(
          Audio(widget.song),
          autoStart: false,
          showNotification: true,
        )
        .then(
          (_) => setState(
            () {
              Max = myPlayer.current.value!.audio.duration;
            },
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    myPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              widget.image,
              opacity: const AlwaysStoppedAnimation(0.6),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 100,
                    ),
                    child: Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(widget.image),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Text(
                      widget.madeby,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            myPlayer.stop();
                            setState(() {
                              myIconController!.reverse();
                            });
                          },
                          icon: const Icon(
                            Icons.stop,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        StreamBuilder(
                            stream: myPlayer.isPlaying,
                            builder: (context, snapShot) {
                              var val = snapShot.data;
                              (val == true)
                                  ? myIconController!.forward()
                                  : myIconController!.reverse();
                              return IconButton(
                                onPressed: () {
                                  if (val == true) {
                                    myPlayer.pause();
                                  } else {
                                    myPlayer.play();
                                  }
                                },
                                icon: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  color: Colors.white,
                                  size: 50,
                                  progress: myIconController!,
                                ),
                              );
                            }),
                        IconButton(
                          onPressed: () {
                            if (Play == true) {
                              myPlayer.setVolume(00);
                              setState(() {
                                Play = !Play;
                              });
                            } else {
                              myPlayer.setVolume(100);
                              setState(() {
                                Play = !Play;
                              });
                            }
                          },
                          icon: Play
                              ? const Icon(
                                  Icons.headset,
                                  size: 35,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.headset_off,
                                  size: 35,
                                  color: Colors.white,
                                ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: StreamBuilder(
                      stream: myPlayer.currentPosition,
                      builder: (context, snapShot) {
                        Duration? data = snapShot.data;
                        return SliderTheme(
                          data: SliderThemeData(
                            thumbShape: myThumb,
                            // overlayColor: Colors.transparent,
                          ),
                          child: Slider(
                            activeColor: Colors.green,
                            inactiveColor: Colors.grey,
                            min: 0,
                            max: Max.inSeconds.toDouble(),
                            value: data == null ? 0 : data.inSeconds.toDouble(),
                            onChanged: (val) {
                              setState(() {
                                myPlayer.seek(
                                  Duration(
                                    seconds: val.toInt(),
                                  ),
                                );
                              });
                            },
                            onChangeStart: (val) {
                              setState(() {
                                myThumb = null;
                              });
                            },
                            onChangeEnd: (val) {
                              setState(() {
                                myThumb = SliderComponentShape.noThumb;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  StreamBuilder(
                    stream: myPlayer.currentPosition,
                    builder: (context, snapShot) {
                      var data = snapShot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${data!.inHours} : ${data.inMinutes} : ${data.inSeconds % 60} / ${Max.inHours} :${Max.inMinutes} : ${Max.inSeconds % 60}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
