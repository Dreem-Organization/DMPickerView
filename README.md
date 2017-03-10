# DMPickerView

[![Version](https://img.shields.io/cocoapods/v/DMPickerView.svg?style=flat)](http://cocoapods.org/pods/DMPickerView)
[![License](https://img.shields.io/cocoapods/l/DMPickerView.svg?style=flat)](http://cocoapods.org/pods/DMPickerView)
[![Platform](https://img.shields.io/cocoapods/p/DMPickerView.svg?style=flat)](http://cocoapods.org/pods/DMPickerView)

![Demo](https://github.com/Dreem-Devices/DMPickerView/raw/master/demo.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Your project deployment target must be `iOS 7.1+`

## Installation

DMPickerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DMPickerView"
```
## Options

Here is the list of customizable options:

	@property (nonatomic) Orientation orientation;

The orientation of the picker. Default is `VERTICAL`.

	@property (nonatomic) CGFloat spacing;

Minimum scale of the label. Default is 0.2

	@property (nonatomic) CGFloat minSizeScale;

The spacing between two consecutove elements of the picker. Default is 30.

	@property (nonatomic) CGFloat sizeScaleRatio;

Ratio of the scale. If you increase this value the outer labels will look smaller

	@property (nonatomic) CGFloat minAlphaScale;

Minimum scale of the alpha. Default is 0.2

	@property (nonatomic) CGFloat alphaScaleRatio;

Ratio of the alpha. If you increase this value the outer labels will look dimmer

	@property (nonatomic) CGFloat shouldUpdateRenderingOnlyWhenSelected;

Define if the alpha and ratio should be applied always or only when selected. Default is NO


## Author

Olivier Tranzer, olivier@dreem.com

## License

DMPickerView is available under the MIT license. See the LICENSE file for more info.
