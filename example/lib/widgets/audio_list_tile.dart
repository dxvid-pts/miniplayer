import 'package:flutter/material.dart';

import '../utils.dart';

typedef OnTap(AudioObject audioObject);

class AudioListTile extends StatelessWidget {
  final AudioObject audioObject;
  final Function onTap;

  const AudioListTile(
      {Key? key, required this.audioObject, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          audioObject.img,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(audioObject.title),
      subtitle: Text(
        audioObject.subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(Icons.play_arrow_outlined),
        onPressed: () => onTap(),
      ),
    );
  }
}
