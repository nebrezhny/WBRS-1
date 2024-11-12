import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';

class UserImage extends StatelessWidget {
  final String? userPhotoUrl;
  final String group;
  final double width;
  final double height;
  final String? uid;

  const UserImage({
    super.key,
    this.uid,
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
          image: AssetImage("assets/circles/${group!=""?group:"синяя"}.png"),
          filterQuality: FilterQuality.low),
    );
  }

  Widget _buildUserAvatar(context) {
    if (userPhotoUrl != "") {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 41, // Учитываем padding
        child: CachedNetworkImage(
            imageBuilder: (context, imageProvider, {bool? loadProgress}) {
              return ClipOval(
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  width: width, // Задайте желаемый размер
                  height: height, // Задайте желаемый размер
                ),
              );
            },
          imageUrl: userPhotoUrl!,
          placeholder: (context, url) =>
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: grey
                ),),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: Colors.red,
          )
        ),
      );
    }
    return const CircleAvatar(
      radius: 39, // Учитываем padding
      backgroundImage: AssetImage("assets/profile.png"),
    );
  }
}
