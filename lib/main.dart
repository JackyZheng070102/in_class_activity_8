import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(SpookyHalloweenGame());
}

class SpookyHalloweenGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Halloween Game',
      theme: ThemeData.dark(),
      home: SpookyHomePage(),
    );
  }
}

class SpookyHomePage extends StatefulWidget {
  @override
  _SpookyHomePageState createState() => _SpookyHomePageState();
}

class _SpookyHomePageState extends State<SpookyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  Random random = Random();
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(begin: -50.0, end: 50.0).animate(_controller);
    playBackgroundMusic();
  }

  void playBackgroundMusic() async {
    await _player.setSource(AssetSource('lib/assets/sounds/spooky_music.wav')); // Play local file
    _player.setReleaseMode(ReleaseMode.loop); // Loop the background music
    await _player.resume(); // Start playing
  }

  void playJumpScareSound() async {
    await _player.setSource(AssetSource('lib/assets/sounds/jump_scare.wav')); // Play local file
    await _player.resume(); // Start playing the jump scare sound
  }

  void playSuccessSound() async {
    await _player.setSource(AssetSource('lib/assets/sounds/success_sound.mp3')); // Play local file
    await _player.resume(); // Start playing the success sound
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find the Correct Halloween Item!')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/background1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: random.nextDouble() * MediaQuery.of(context).size.width,
            top: _animation.value,
            child: GestureDetector(
              onTap: () {
                playJumpScareSound();
              },
              child: Image.asset('lib/assets/ghost.png', width: 80, height: 80),
            ),
          ),
          Positioned(
            right: random.nextDouble() * MediaQuery.of(context).size.width,
            bottom: _animation.value,
            child: GestureDetector(
              onTap: () {
                playSuccessSound();
              },
              child: Icon(Icons.emoji_emotions, size: 80, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
