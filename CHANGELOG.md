# EasyImageViewer Changelog

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
