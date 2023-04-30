import 'package:flutter/material.dart';
import 'package:music_player_app/utils/audio_utils.dart';
import 'package:music_player_app/view/screens/audio_page.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicPlayer(),
    ),
  );
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  State<MusicPlayer> createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "RAINBOW MUSIC",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: myMusicList
              .map(
                (e) => Card(
                  color: Colors.primaries[myMusicList.indexOf(e) % 18],
                  elevation: 3,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AudioPage(
                            name: e['name'],
                            image: e['image'],
                            song: e['song'],
                            madeby: e['makeby'],
                          ),
                        ),
                      );
                    },
                    leading: Container(
                      height: 65,
                      width: 65,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            e['image'],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      e['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      e['makeby'],
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
