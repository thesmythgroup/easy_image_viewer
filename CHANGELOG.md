# EasyImageViewer Changelog

## 1.3.1

- Revert breaking constructor change introduced in 1.3.0. This changes the default `EasyImageView` constructor back to accepting an `ImageProvider` instead of a `Widget`. Constructing an `EasyImageView` with a widget can be done by using a new named constructor: `EasyImageView.imageWidget`.

## 1.3.0

- Update Flutter to `3.16.3`
- Add loading progress indicator out of the box with options to fully customize both the widget used to display progress as well as the widget used to display an image (Flutter's `Image` by default).

## 1.2.1

- Update Dart to `>=2.12.0 <4.0.0`.

## 1.2.0

- Add option to "double tap to zoom" by setting `doubleTapZoomable` to `true` [GH-24](https://github.com/thesmythgroup/easy_image_viewer/issues/24). Thank you to [Tony](https://github.com/nne998) of [lookingpet](https://github.com/lookingpet/easy_image_viewer) for the initial implementation.
- Fix an issue where the PageView was not correctly disabled when `swipeDismissible` was `true` and the image was zoomed in [GH-27](https://github.com/thesmythgroup/easy_image_viewer/issues/27).

## 1.1.0

- Enable dragging the PageView with a mouse [GH-11](https://github.com/thesmythgroup/easy_image_viewer/issues/11).
- Add option to "swipe down to dismiss" by setting `swipeDismissible` to `true` [GH-14](https://github.com/thesmythgroup/easy_image_viewer/issues/14).
- Correctly clean up (status bar visibility etc) when using the Android back button to dismiss [GH-15](https://github.com/thesmythgroup/easy_image_viewer/issues/15#issuecomment-1131670449).
- Don't use rounded corners on the full-screen dialog when using Material 3 [GH-16](https://github.com/thesmythgroup/easy_image_viewer/issues/16).

## 1.0.4

- Add `backgroundColor` and `closeButtonColor` arguments that default to `black` and `white` respectively. These values are passed through to `showDialog` so the background color and the close button color can be customized.

## 1.0.3

- Add `useSafeArea` argument that defaults to `false` and pass it through to `showDialog` to let a zoomed-in image fill the entire screen.
- Use `SizedBox.expand` to make `EasyImageView` fill its parent instead of hard-coding its size to the full screen.
- Add example of how to use `EasyImageViewPager` without a dialog, embedding it in a widget and using buttons to go forward and backward.

## 1.0.2

- Provide more comprehensive example.
- Structure lib directory using a src folder.

## 1.0.1

- Update demo image path in README.

## 1.0.0

- Initial version.
