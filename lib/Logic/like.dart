import 'package:flutter/material.dart';


class like extends StatefulWidget {
  const like({super.key});

  @override
  State<like> createState() => _likeState();
}

class _likeState extends State<like> {
  bool _liked = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _liked ? Icons.favorite : Icons.favorite_border,
        color: _liked ? Colors.red : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _liked = !_liked;
        });
      },
    );
  }
}
