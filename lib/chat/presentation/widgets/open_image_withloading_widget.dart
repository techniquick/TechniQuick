import 'package:flutter/material.dart';

import '../../../core/constant/constant.dart';
import 'image_message_view.dart';
import 'message_card_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageWithLoading extends StatefulWidget {
  final String imageUrl;
  const ImageWithLoading({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ImageWithLoadingState createState() => _ImageWithLoadingState();
}

class _ImageWithLoadingState extends State<ImageWithLoading> {
  late final String imageUrl;
  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  void _openImageView(String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => ImageMessageView(imageUrl: url)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openImageView(imageUrl),
      child: SizedBox(
        height: height(context) * .30,
        width: width(context) * .50,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          progressIndicatorBuilder: (_, child, loadingProgress) {
            if (loadingProgress.totalSize == null) {
              return const EmptyContainer();
            }
            return Stack(
              children: <Widget>[
                const EmptyContainer(),
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor:
                        loadingProgress.downloaded / loadingProgress.totalSize!,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
