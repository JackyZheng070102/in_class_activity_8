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

  bool _foundCorrectItem = false; // To track if the correct item is found
  final List<String> _items = ['ghost', 'pumpkin', 'bat']; // Possible items
  late String _correctItem; // To hold the correct item

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(begin: -50.0, end: 50.0).animate(_controller);
    playBackgroundMusic();
    _correctItem = _items[random.nextInt(_items.length)]; // Randomly select the correct item
  }

  void playBackgroundMusic() async {
    await _player.setSource(AssetSource('lib/assets/sounds/spooky_music.wav'));
    _player.setReleaseMode(ReleaseMode.loop); // Loop the background music
    await _player.resume(); // Start playing
  }

  void playJumpScareSound() async {
    await _player.setSource(AssetSource('lib/assets/sounds/jump_scare.wav'));
    await _player.resume(); // Start playing the jump scare sound
  }

  void playSuccessSound() async {
    await _player.setSource(AssetSource('lib/assets/sounds/success_sound.mp3'));
    await _player.resume(); // Start playing the success sound
  }

  void _onItemTap(String item) {
    if (item == _correctItem) {
      playSuccessSound();
      setState(() {
        _foundCorrectItem = true; // Mark the correct item as found
      });
      // Show a success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('You Found It!'),
            content: Text('Congratulations! You found the correct item!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      playJumpScareSound(); // Play jump scare sound for wrong item
    }
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
          // Spooky Items
          for (String item in _items)
            Positioned(
              left: random.nextDouble() * MediaQuery.of(context).size.width,
              top: _animation.value + random.nextDouble() * 100, // Random Y position
              child: GestureDetector(
                onTap: () => _onItemTap(item),
                child: item == 'ghost'
                    ? Image.asset('lib/assets/ghost.png', width: 80, height: 80)
                    : item == 'pumpkin'
                        ? Image.asset('lib/assets/pumpkin.png', width: 80, height: 80) // Add your pumpkin image
                        : Image.asset('lib/assets/bat.png', width: 80, height: 80), // Add your bat image
              ),
            ),
          // Optionally, show a message if the correct item is found
          if (_foundCorrectItem)
            Center(
              child: Text(
                'You found the correct item!',
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}
