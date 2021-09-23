# EasyImageViewer

An easy way to display images in a full-screen dialog, including pinch & zoom.

## Features

* Show a single image or a swipeable list of images
* Use pinch & zoom to zoom in and out of images
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

## Credits

EasyImageViewer is a project by [TSG](https://thesmythgroup.com/), a full-service digital agency taking software from concept to launch.
Our powerhouse team of designers and engineers build iOS, Android, and web apps across many industries.
