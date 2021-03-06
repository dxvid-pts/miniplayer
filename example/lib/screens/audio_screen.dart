import 'package:flutter/material.dart';
import '../widgets/audio_list_tile.dart';

import '../utils.dart';

typedef OnTap(final AudioObject audioObject);

const Set<AudioObject> audioExamples = {
  AudioObject('Salt & Pepper', 'Dope Lemon',
      'https://m.media-amazon.com/images/I/81UYWMG47EL._SS500_.jpg'),
  AudioObject('Losing It', 'FISHER',
      'https://m.media-amazon.com/images/I/9135KRo8Q7L._SS500_.jpg'),
  AudioObject('American Kids', 'Kenny Chesney',
      'https://cdn.playbuzz.com/cdn/7ce5041b-f9e8-4058-8886-134d05e33bd7/5c553d94-4aa2-485c-8a3f-9f496e4e4619.jpg'),
  AudioObject('Wake Me Up', 'Avicii',
      'https://upload.wikimedia.org/wikipedia/en/d/da/Avicii_Wake_Me_Up_Official_Single_Cover.png'),
  AudioObject('Missing You', 'Mesto',
      'https://img.discogs.com/EcqkrmOCbBguE3ns-HrzNmZP4eM=/fit-in/600x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-12539198-1537229070-5497.jpeg.jpg'),
  AudioObject('Drop it dirty', 'Tavengo',
      'https://images.shazam.com/coverart/t416659652-b1392404277_s400.jpg'),
  AudioObject('Cigarettes', 'Tash Sultana',
      'https://m.media-amazon.com/images/I/91vBpel766L._SS500_.jpg'),
  AudioObject('Ego Death', 'Ty Dolla \$ign, Kanye West, FKA Twigs, Skrillex',
      'https://static.stereogum.com/uploads/2020/06/Ego-Death-1593566496.jpg'),
};

class AudioUi extends StatelessWidget {
  final OnTap onTap;

  const AudioUi({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 6, top: 15),
          child: Text('Your Library:'),
        ),
        for (AudioObject a in audioExamples)
          AudioListTile(audioObject: a, onTap: () => onTap(a))
      ],
    );
  }
}
