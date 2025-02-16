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
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(5),
        decoration: _buildBackgroundDecoration(),
        child: _buildUserAvatar(context),
      ),
    );
  }

  List<Color> getColorsByGroup(String group) {
    switch (group) {
      case 'красная':
        return [Colors.red, Colors.red];
      case 'синяя':
        return [Colors.blue, Colors.blue];
      case 'коричневая':
        return [Colors.brown, Colors.brown];
      case 'красно-синяя':
        return [Colors.red, Colors.blue];
      case 'красно-коричневая':
        return [Colors.red, Colors.brown];
      case 'красно-белая':
        return [Colors.red, Colors.white];
      case 'сине-коричневая':
        return [Colors.blue, Colors.brown];
      case 'сине-белая':
        return [Colors.blue, Colors.white];
      case 'сине-красная':
        return [Colors.blue, Colors.red];
      case 'коричнево-белая':
        return [Colors.brown, Colors.white];
      case 'коричнево-красная':
        return [Colors.brown, Colors.red];
      case 'коричнево-синяя':
        return [Colors.brown, Colors.blue];
      case 'бело-красная':
        return [Colors.white, Colors.red];
      case 'бело-синяя':
        return [Colors.white, Colors.blue];
      case 'бело-коричневая':
        return [Colors.white, Colors.brown];

      default:
        return [Colors.white, Colors.white];
    }
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.center,
        end: const Alignment(0.56, 0.56),
        stops: const [0.9, 0.4],
        colors: getColorsByGroup(group),
      ),
    );
  }

  Widget _buildUserAvatar(context) {
    if (userPhotoUrl != '' && userPhotoUrl != null) {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50, // Учитываем padding
        child: CachedNetworkImage(
            cacheKey: uid,
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
            placeholder: (context, url) => Container(
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: grey),
                ),
            errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 50, // Учитываем padding
                  backgroundImage: AssetImage('assets/profile.png'),
                )),
      );
    }
    return const CircleAvatar(
      radius: 39, // Учитываем padding
      backgroundImage: AssetImage('assets/profile.png'),
    );
  }
}
