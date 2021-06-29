import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioServiceWidget(child: MainScreen()),
    );
  }
}

void _backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(child: Text("Start"), onPressed: start),
            ElevatedButton(child: Text("Stop"), onPressed: stop),
            ElevatedButton(child: Text("Pause"), onPressed: AudioService.pause),
          ],
        ),
      ),
    );
  }

  start() => AudioService.start(
        backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
        androidResumeOnClick: true,
        androidStopForegroundOnPause: false,
      );

  stop() => AudioService.stop();
}

class AudioPlayerTask extends BackgroundAudioTask {
  final _audioPlayer = AudioPlayer();
  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    print("start");
    _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(
        'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3')));
    await _audioPlayer.load();
    await _audioPlayer.play();
    return super.onStart(params);
  }

  @override
  Future<void> onStop() {
    return super.onStop();
  }

  @override
  Future<void> onPause() async {
    await _audioPlayer.pause();
  }
}
