import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  final ImageProvider<dynamic> image;
  final IconData initImage;

  const Avatar({
    required this.image,
    Key? key,
    this.initImage = Icons.verified_user,
  }) : super(key: key);

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  static double border = 0.3;

  double? _sizeChild;
  Widget? _widgetChild;

  @override
  Widget build(BuildContext context) {
    _sizeChild = 70.0;
    _widgetChild = _getImageOnError(null);

    return Container(
      padding: const EdgeInsets.all(6), // borde
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blue,
            offset: Offset(0.0, 1.0),
            blurRadius: 1,
          ),
        ],
        shape: BoxShape.circle,
        color: Color(0xFFFFFFFF),
      ),
      child: SizedBox(
        width: _sizeChild,
        height: _sizeChild,
        child: CircleAvatar(
          radius: (_sizeChild! / 3) - border,
          backgroundColor: const Color(0xFFD9DADD),
          backgroundImage: widget.image as ImageProvider<Object>?,
          onBackgroundImageError: _setOnErrorAvatar,
          child: _widgetChild,
        ),
      ),
    );
  }

  void _setOnErrorAvatar(exception, StackTrace? stackTrace) {
    setState(() {
      _widgetChild = _getImageOnError(Icon(widget.initImage));
    });
  }

  Widget _getImageOnError(Widget? icon) {
    double? imageSize;
    imageSize = _sizeChild!;
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.circle),
      width: imageSize,
      height: imageSize,
      child: icon,
    );
  }
}
