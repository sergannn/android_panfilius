import 'package:audioplayers/audioplayers.dart';


class chords_player {

  AudioPlayer audioPlayer = AudioPlayer();
  play(chord) async {



    int result = await audioPlayer.play('https://www.scales-chords.com/chord-sounds/snd-piano-chord-'+chord.replaceAll("#","s")+'.aac');
    if (result == 1) {
      // success
    }
  }



}