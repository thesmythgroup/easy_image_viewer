import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

/// Simple example of how to use EasyImageViewer with a FutureBuilder
class AsyncDemoPage extends StatefulWidget {
  const AsyncDemoPage({Key? key}) : super(key: key);

  @override
  _AsyncDemoPageState createState() => _AsyncDemoPageState();
}

class _AsyncDemoPageState extends State<AsyncDemoPage> {

  final _pageController = PageController();

  /// Simulates a network fetch of image URLs
  Future<List<String>> _fetchURLs() async {
    // Wait for three seconds to simulate a network fetch
    await Future.delayed(const Duration(seconds: 3));

    return [
      "https://picsum.photos/id/1001/4912/3264",
      "https://picsum.photos/id/1003/1181/1772",
      "https://picsum.photos/id/1004/4912/3264",
      "https://picsum.photos/id/1005/4912/3264"
    ];
  }

  /// Creates an EasyImageProvider from a list of URLs
  Future<EasyImageProvider> _createEasyImageProvider() async {
    final urls = await _fetchURLs();
    return MultiImageProvider(urls.map((url) => NetworkImage(url)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async Demo')),
      body: FutureBuilder<EasyImageProvider>(
        future: _createEasyImageProvider(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            EasyImageProvider easyImageProvider = snapshot.data!;
            return Center(child: 
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.0,
                child: EasyImageViewPager(
                    easyImageProvider: easyImageProvider,
                    pageController: _pageController),
              )
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}