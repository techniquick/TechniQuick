import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../../core/constant/constant.dart';

class ImageMessageView extends StatelessWidget {
  static const String routeName = '/image-viewer';
  final String imageUrl;

  const ImageMessageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: 1,
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.white),
            builder: (BuildContext context, index) {
              return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrl));
            },
            loadingBuilder: (ctx, loadingProgress) {
              if (loadingProgress == null) return Container();
              return FractionallySizedBox(
                widthFactor: loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!,
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.grey[400]!.withOpacity(0.3),
                ),
              );
            },
          ),
          Positioned(
            top: 30,
            left: 0,
            child: SizedBox(
              height: 45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: primaryColor, size: 30.0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
