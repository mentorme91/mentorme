import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String? uid;
  final String? image;
  const DetailScreen({required this.image, super.key, required this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color:
                  Colors.black.withOpacity(0.5), // Transparent black background
            ),
          ),
          Center(
            child: Hero(
              tag: 'userImage${uid}',
              child: ExpandingAvatar(
                image: NetworkImage(image ??
                    'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ'),
                radius: 300.0, // Expanded radius in the detail screen
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandingAvatar extends StatelessWidget {
  final ImageProvider image;
  final double radius;

  ExpandingAvatar({required this.image, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 60.0, end: radius),
        duration: Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Container(
            width: value,
            height: value,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
