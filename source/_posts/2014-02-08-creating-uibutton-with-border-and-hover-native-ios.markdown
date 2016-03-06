---
layout: post
title: "Creating UIButton with border and hover native iOS"
date: 2014-02-08 22:43:41 -0300
comments: true
categories: [Labs, iOS, UIButton, Border, Hover, Highlighted]
---

{% img right half /images/labs/2014-02-08/app-sample-screenshot.png %}

### The problem

When you are using Interface Builder to create your buttons there is just a few properties that we can change for different `UIButton`'s state.

{% img /images/labs/2014-02-08/uibutton-state-config.png %}

So, that brings us some restrictions if we need to change the background color of the highlighted state. I have seen people creating an image of a button relatively simple, but one image for the normal and the other for the highlighted state or some other properties. I confess that it was my approach for a short while, until I had to deal with a bunch of buttons that the only thing that changed was the text, and sometimes an icon embeded in the button.

For that reason I implemented a class to deal with the background of the highlighted state and some border features.

### How to use it?

First you have to add [Catfish][cf] as a dependency to your project, inside of it there is a class `CFUIButton`. It has methods to:

<!--more-->

{% codeblock lang:objc CFUIButton.h %}
+ (void)setBorderColor:(UIColor*)color;
- (void)setBorderColor:(UIColor*)color;

- (void)removeBorder;
- (void)setBorderWidth:(CGFloat)borderWidth;
- (void)setCornerRadius:(CGFloat)cornerRadius;

+ (void) setBackgroundColorForHighlightedState:(UIColor*)color;
- (void) setBackgroundColorForHighlightedState:(UIColor*)color;
{% endcodeblock %}

If you are using Interface Builder, the next step is to set `CFUIButton` as a custom class for your button.

{% img /images/labs/2014-02-08/custom-class-cfuibutton.png %}

Cool, and now set your `CFUIButton` type as custom.

{% img /images/labs/2014-02-08/uibutton-type-config.png %}

But if you are creating your button programmatically, you just have to extend `CFUIButton`.

{% codeblock lang:objc CFUIButton.h %}
@interface MyButton : CFUIButton

@end
{% endcodeblock %}

Now that you have everying set, lets play with it.

### Setting border color

There are two different ways to change the border color of the `CFUIButton`. The first one is for all of the `CFUIButton` in your application and the second is for a specific `CFUIButton` instance. The default color for all of the `CFUIButton` is `[UIColor colorWithWhite:1.0 alpha:0.4]`.

#### Application level:

Open your `AppDelegate.m` and add the following code in the method `didFinishLaunchingWithOptions`:

{% codeblock lang:objc %}
[CFUIButton setBorderColor:[UIColor whiteColor]];
{% endcodeblock %}

You should have something like that:

{% codeblock lang:objc AppDelegate.m %}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CFUIButton setBorderColor:[UIColor whiteColor]];
   
    return YES;
}
{% endcodeblock %}

#### Instance level:

First you have to create a class for your `ViewController`, for this example I am using `MainViewController`, after that you have to [reference][co] your `CFUIButton` with your `MainViewController.h` and set the instance name `customButtonWithBorder`.

{% codeblock lang:objc MainViewController.h %}
#import "CFUIButton.h"

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet CFUIButton *customButtonWithBorder;

@end
{% endcodeblock %}

Now, open the class `MainViewController.m` and add the following line in your `- (void)viewDidLoad` method:

{% codeblock lang:objc %}
[_customButtonWithBorder setBorderColor:[UIColor yellowColor]];
{% endcodeblock %}

### Corner radius

You also can create button with corner:

{% img /images/labs/2014-02-08/connection-with-facebook.png %}

Since that you have your instance variable, in the `- (void)viewDidLoad` method, add the following line:

{% codeblock lang:objc %}
[_customButtonWithBorder setCornerRadius:30.0f];
{% endcodeblock %}

### Removing border

You can also remove the border if you just want to use the benefit of the <a href="{{ root_url }}/blog/2014/02/03/creating-uibutton-with-border-and-hover-native-ios/#highlighted">highlighted state color</a>.

{% img /images/labs/2014-02-08/message-without-border.png %}

{% codeblock lang:objc %}
[_customButtonWithBorder removeBorder];
{% endcodeblock %}

<a id="highlighted"></a>
### Highlighted state

You can change the text color for the highlighted state through the Interface Builder, but to change the background color, it becomes a little bit more complicated, so if you want to have something like that:

{% img /images/labs/2014-02-08/with-different-hover-color.png %} {% img /images/labs/2014-02-08/with-different-hover-color-selected.png %}

You can use:

#### Application level:

{% codeblock lang:objc AppDelegate.m %}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[CFUIButtonBorder setBackgroundColorForHighlightedState:[UIColor whiteColor]];

	return YES;
}
{% endcodeblock %}

#### Instance level:

{% codeblock lang:objc %}
[_customButtonWithDifferentHoverColor setBackgroundColorForHighlightedState:[UIColor whiteColor]];
{% endcodeblock %}

---
[Download][bb] the project sample.

[co]:https://developer.apple.com/library/ios/recipes/xcode_help-interface_builder/articles-connections_bindings/CreatingOutlet.html#//apple_ref/doc/uid/TP40009971-CH15
[cf]:https://github.com/jairobjunior/Catfish
[bb]:https://github.com/jairobjunior/labs.jairobjunior.com.ButtonWithBorderAndHover