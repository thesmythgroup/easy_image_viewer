# EasyImageViewer

An easy way to display images in a full-screen dialog, including pinch & zoom.

[![Pub](https://img.shields.io/pub/v/easy_image_viewer.svg)](https://pub.dartlang.org/packages/easy_image_viewer)
[![Tests](https://github.com/thesmythgroup/easy_image_viewer/actions/workflows/dart.yml/badge.svg)](https://github.com/thesmythgroup/easy_image_viewer/actions/workflows/dart.yml)

![Easy Image Viewer Demo](https://github.com/thesmythgroup/easy_image_viewer/blob/main/demo_images/demo1.gif?raw=true "Easy Image Viewer Demo")

## Features

* Show a single image or a swipeable list of images
* Use pinch & zoom to zoom in and out of images
* Optionally allow "double tap to zoom" by passing in `doubleTapZoomable: true`
* Optionally allow "swipe down to dismiss" by passing in `swipeDismissible: true`
* No dependencies besides Flutter
* Callbacks for `onPageChanged` and `onViewerDismissed`

## Usage

Show a single image:

```dart
final imageProvider = Image.network("https://picsum.photos/id/1001/5616/3744").image;
showImageViewer(context, imageProvider, onViewerDismissed: () {
  print("dismissed");
});
```

Show a bunch of images:

```dart
MultiImageProvider multiImageProvider = MultiImageProvider([
  Image.network("https://picsum.photos/id/1001/5616/3744").image,
  Image.network("https://picsum.photos/id/1003/1181/1772").image,
  Image.network("https://picsum.photos/id/1004/5616/3744").image,
  Image.network("https://picsum.photos/id/1005/5760/3840").image
]);

showImageViewerPager(context, multiImageProvider, onPageChanged: (page) {
  print("page changed to $page");
}, onViewerDismissed: (page) {
  print("dismissed while on page $page");
});
```

Usually you'll want to implement your own `EasyImageProvider`. Suppose you have
a list of `Product`s, each of which has an `imagePath` property with the path
to a local image file. You could create an `EasyImageProvider` that takes a list
of `Product`s like this:

```dart
class ProductsImageProvider extends EasyImageProvider {

  final List<Product> products;
  final int initialIndex;

  ProductsImageProvider({ required this.products, this.initialIndex = 0 });

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    String? localImagePath = products[index].imagePath;
    File? imageFile;

    if (localImagePath != null) {
      imageFile = File(localImagePath);
    }

    ImageProvider imageProvider = imageFile != null ? FileImage(imageFile) : AssetImage("assets/images/product_placeholder.jpg") as ImageProvider;

    return imageProvider;
  }

  @override
  int get imageCount => products.length;  
}
```

You could then use it like this:

```dart
ProductsImageProvider productsImageProvider = ProductsImageProvider(products: products);

showImageViewerPager(context, productsImageProvider, onPageChanged: (page) {
  print("page changed to $page");
}, onViewerDismissed: (page) {
  print("dismissed while on page $page");
});
```

## How to release a new version on pub.dev
1. Update the version number in `pubspec.yaml`.
2. Add an entry for the new version in `CHANGELOG.md`.
3. Make sure `flutter test` and `flutter analyze` pass without any issues.
4. Run `dart pub publish --dry-run` to ensure all publishing checks pass.
5. If you haven't installed the [pana package analysis tool](https://pub.dev/packages/pana) yet, install it with `dart pub global activate pana`.
6. Make sure all changes are committed and run `pana .` inside the project directory. We are aiming for the highest score.
7. Address any issues reported by pana.
8. Create a new branch for your changes, for example by running `git checkout -b release-1.1.0`.
9. Commit your changes (formatting changes separately from other changes).
10. Open a PR with your changes.
11. Once approved, merge the PR.
12. Run `dart pub publish` to publish the new version.
13. On GitHub, create a new release by visiting [Releases](https://github.com/thesmythgroup/easy_image_viewer/releases). The tag should have the format of `v` plus the version number, for example `v1.1.0`. The title of the release should be the version number without a `v`. Add what you've added to the changelog as the release's description.
14. That's it.


## Credits

EasyImageViewer is a project by [TSG](https://thesmythgroup.com/), a full-service digital agency taking software from concept to launch.
Our powerhouse team of designers and engineers build iOS, Android, and web apps across many industries.
