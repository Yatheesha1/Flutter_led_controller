// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

enum GridDemoTileStyle { imageOnly, oneLine, twoLine }

typedef void BannerTapCallback(Photo photo);

const double _kMinFlingVelocity = 800.0;
const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class Photo {
  Photo({
    this.assetName,
    this.assetPackage,
    this.title,
    this.caption,
    this.isFavorite = false,
  });

  final String assetName;
  final String assetPackage;
  final String title;
  final String caption;

  bool isFavorite;
  String get tag => assetName; // Assuming that all asset names are unique.

  bool get isValid =>
      assetName != null &&
      title != null &&
      caption != null &&
      isFavorite != null;
}

class GridPhotoViewer extends StatefulWidget {
  const GridPhotoViewer({Key key, this.photo}) : super(key: key);

  final Photo photo;

  @override
  _GridPhotoViewerState createState() => new _GridPhotoViewerState();
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return new FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: new Text(text),
    );
  }
}

class _GridPhotoViewerState extends State<GridPhotoViewer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset =
        new Offset(size.width, size.height) * (1.0 - _scale);
    return new Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(
            begin: _offset, end: _clampOffset(_offset + direction * distance))
        .animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: new ClipRect(
        child: new Transform(
          transform: new Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
          child: new Image.asset(
            widget.photo.assetName,
            package: widget.photo.assetPackage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class GridDemoPhotoItem extends StatelessWidget {
  GridDemoPhotoItem(
      {Key key,
      @required this.photo,
      @required this.tileStyle,
      @required this.onBannerTap})
      : assert(photo != null && photo.isValid),
        assert(tileStyle != null),
        assert(onBannerTap != null),
        super(key: key);

  final Photo photo;
  final GridDemoTileStyle tileStyle;
  final BannerTapCallback
      onBannerTap; // User taps on the photo's header or footer.

  void showPhoto(BuildContext context) {
    Navigator.push(context,
        new MaterialPageRoute<void>(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(title: new Text(photo.title)),
        body: new SizedBox.expand(
          child: new Hero(
            tag: photo.tag,
            child: new GridPhotoViewer(photo: photo),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = new GestureDetector(
        onTap: () {
          showPhoto(context);
        },
        child: new Hero(
            key: new Key(photo.assetName),
            tag: photo.tag,
            child: new Image.asset(
              photo.assetName,
              package: photo.assetPackage,
              fit: BoxFit.cover,
            )));

    final IconData icon = photo.isFavorite ? Icons.star : Icons.star_border;

    switch (tileStyle) {
      case GridDemoTileStyle.imageOnly:
        return image;

      case GridDemoTileStyle.oneLine:
        return new GridTile(
          header: new GestureDetector(
            onTap: () {
              onBannerTap(photo);
            },
            child: new GridTileBar(
              title: new _GridTitleText(photo.title),
              backgroundColor: Colors.black45,
              leading: new Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          child: image,
        );

      case GridDemoTileStyle.twoLine:
        return new GridTile(
          footer: new GestureDetector(
            onTap: () {
              onBannerTap(photo);
            },
            child: new GridTileBar(
              backgroundColor: Colors.black45,
              title: new _GridTitleText(photo.title),
              subtitle: new _GridTitleText(photo.caption),
              trailing: new Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          child: image,
        );
    }
    assert(tileStyle != null);
    return null;
  }
}

class GridListDemo extends StatefulWidget {
  const GridListDemo({Key key}) : super(key: key);

  static const String routeName = '/material/grid-list';

  @override
  GridListDemoState createState() => new GridListDemoState();
}

class GridListDemoState extends State<GridListDemo> {
  GridDemoTileStyle _tileStyle = GridDemoTileStyle.twoLine;

  List<Photo> photos = <Photo>[
    new Photo(
      assetName: 'places/india_chennai_flower_market.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Chennai',
      caption: 'Flower Market',
    ),
    new Photo(
      assetName: 'places/india_tanjore_bronze_works.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
      caption: 'Bronze Works',
    ),
    new Photo(
      assetName: 'places/india_tanjore_market_merchant.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
      caption: 'Market',
    ),
    new Photo(
      assetName: 'places/india_tanjore_thanjavur_temple.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
      caption: 'Thanjavur Temple',
    ),
    new Photo(
      assetName: 'places/india_tanjore_thanjavur_temple_carvings.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
      caption: 'Thanjavur Temple',
    ),
    new Photo(
      assetName: 'places/india_pondicherry_salt_farm.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Pondicherry',
      caption: 'Salt Farm',
    ),
    new Photo(
      assetName: 'places/india_chennai_highway.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Chennai',
      caption: 'Scooters',
    ),
    new Photo(
      assetName: 'places/india_chettinad_silk_maker.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Chettinad',
      caption: 'Silk Maker',
    ),
    new Photo(
      assetName: 'places/india_chettinad_produce.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Chettinad',
      caption: 'Lunch Prep',
    ),
    new Photo(
      assetName: 'places/india_tanjore_market_technology.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
      caption: 'Market',
    ),
    new Photo(
      assetName: 'places/india_pondicherry_beach.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Pondicherry',
      caption: 'Beach',
    ),
    new Photo(
      assetName: 'places/india_pondicherry_fisherman.png',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Pondicherry',
      caption: 'Fisherman',
    ),
  ];

  void changeTileStyle(GridDemoTileStyle value) {
    setState(() {
      _tileStyle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Grid list'),
        actions: <Widget>[
          new PopupMenuButton<GridDemoTileStyle>(
            onSelected: changeTileStyle,
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<GridDemoTileStyle>>[
                  const PopupMenuItem<GridDemoTileStyle>(
                    value: GridDemoTileStyle.imageOnly,
                    child: Text('Image only'),
                  ),
                  const PopupMenuItem<GridDemoTileStyle>(
                    value: GridDemoTileStyle.oneLine,
                    child: Text('One line'),
                  ),
                  const PopupMenuItem<GridDemoTileStyle>(
                    value: GridDemoTileStyle.twoLine,
                    child: Text('Two line'),
                  ),
                ],
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new SafeArea(
              top: false,
              bottom: false,
              child: new GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                childAspectRatio:
                    (orientation == Orientation.portrait) ? 1.0 : 1.3,
                children: photos.map((Photo photo) {
                  return new GridDemoPhotoItem(
                      photo: photo,
                      tileStyle: _tileStyle,
                      onBannerTap: (Photo photo) {
                        setState(() {
                          photo.isFavorite = !photo.isFavorite;
                        });
                      });
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
