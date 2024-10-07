import 'package:flutter/material.dart';
import 'dart:math';

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

class _SpookyHomePageState extends State<SpookyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: -50.0, end: 50.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find the Correct Halloween Item!')),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/background1.png',
              fit: BoxFit.cover,
            ),
          ),
          // Ghost image
          Positioned(
            left: random.nextDouble() * MediaQuery.of(context).size.width,
            top: _animation.value,
            child: Image.asset('lib/assets/ghost.png', width: 80, height: 80),
          ),
          // Pumpkin icon
          Positioned(
            right: random.nextDouble() * MediaQuery.of(context).size.width,
            bottom: _animation.value,
            child: Icon(Icons.emoji_emotions, size: 80, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
