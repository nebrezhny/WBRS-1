import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final String? userPhotoUrl;
  final String group;
  final double width;
  final double height;

  const UserImage({
    super.key,
    required this.userPhotoUrl,
    required this.group,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(9),
      decoration: _buildBackgroundDecoration(),
      child: _buildUserAvatar(context),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/circles/$group.png"),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildUserAvatar(context) {
    if (userPhotoUrl != null && userPhotoUrl!.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 41, // Учитываем padding
        backgroundImage: CachedNetworkImageProvider(
          userPhotoUrl!,
          cacheKey: userPhotoUrl!,
          errorListener: (p0) => _handleError(context),
        ),
      );
    }
    return const CircleAvatar(
      radius: 39, // Учитываем padding
      backgroundImage: AssetImage("assets/profile.png"),
    );
  }

  void _handleError(BuildContext context) {
    // Здесь можно добавить логику обработки ошибки загрузки изображения
    print('Ошибка загрузки изображения');
  }
}
