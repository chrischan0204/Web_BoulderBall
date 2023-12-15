import 'package:boulderball/models/route_model.dart';
import 'package:boulderball/utils/route_manager.dart';
import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RouteDetailsScreen extends StatefulWidget {
  const RouteDetailsScreen({super.key, required this.route});

  final RouteModel route;

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  late YoutubePlayerController _videoController;
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();

    if (widget.route.imgBackUrl == "") {
      RouteManager.instance.loadRouteImage(widget.route, 1).then((value) {
        if (mounted) {
          setState(() {});
        }
      });
    }
    if (widget.route.imgSkillsUrl == "") {
      RouteManager.instance.loadRouteImage(widget.route, 2).then((value) {
        if (mounted) {
          setState(() {});
        }
      });
    }

    final videoId = YoutubePlayer.convertUrlToId(widget.route.videoUrl);
    _videoController = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
        disableDragSeek: true,
        loop: true,
        hideThumbnail: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    List<String> imageUrls = [];

    for (var url in [
      widget.route.imgFrontUrl,
      widget.route.imgBackUrl,
      widget.route.imgSkillsUrl,
    ]) {
      if (url != "") imageUrls.add(url);
    }
    return BBScaffold(
      title: Text(widget.route.name),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PageStorage(
              bucket: PageStorageBucket(),
              child: CarouselSlider.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index, realIndex) {
                  return _buildImageWidget(imageUrls[index]);
                },
                carouselController: _controller,
                options: CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    enableInfiniteScroll: false,
                    height: height * 0.65,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.5,
                    onPageChanged: (index, reason) {
                      if (mounted) {
                        setState(() {
                          _currentIndex = index;
                        });
                      }
                    }),
              ),
            ),
            getIndicator(imageUrls),
            widget.route.videoUrl.isEmpty
                ? Container()
                : Container(
                    margin: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: YoutubePlayer(
                        controller: _videoController,
                        aspectRatio: 9 / 16,
                        bottomActions: [
                          ProgressBar(
                            isExpanded: true,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imgUrl) {
    return Center(
      child: _buildEmptyRoute(
        child: imgUrl == ""
            ? Center(child: Text(widget.route.name))
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  fit: BoxFit.scaleDown,
                  imageUrl: imgUrl,
                  imageBuilder: (context, imageProvider) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeroPhotoViewRouteWrapper(
                              imageProvider: imageProvider,
                              tag: imgUrl,
                            ),
                          ));
                    },
                    child: Hero(
                      tag: imgUrl,
                      child: Image(image: imageProvider),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return const Center(
                      child: Text("Unable to load image"),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyRoute({required Widget child}) {
    return AspectRatio(
      aspectRatio: 827 / 1182, // aspect ratio of the image
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget getImageWidget(ImageProvider imageProvider) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: imageProvider,
        ),
      ),
    );
  }

  Widget getIndicator(List<String> imgUrls) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imgUrls.asMap().entries.map((entry) {
        return Container(
          width: 12.0,
          height: 12.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (_currentIndex == entry.key ? Colors.white : Colors.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    super.key,
    required this.imageProvider,
    required this.tag,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final String tag;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        // constraints: BoxConstraints.expand(
        //   height: MediaQuery.of(context).size.height,
        // ),
        child: PhotoView(
          tightMode: true,
          imageProvider: imageProvider,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          heroAttributes: PhotoViewHeroAttributes(
            tag: tag,
          ),
        ),
      ),
    );
  }
}
