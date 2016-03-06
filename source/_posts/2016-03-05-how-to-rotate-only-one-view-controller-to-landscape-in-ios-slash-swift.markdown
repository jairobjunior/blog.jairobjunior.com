---
layout: post
title: "How to Rotate Only One View Controller to Landscape Orientation in iOS Swift"
date: 2016-03-05 23:38:19 -0800
comments: true
categories: [Labs, iOS, Swift, Device Rotation, Landscape, Portrait, UIInterfaceOrientation]
published: true
---

{% img right half /images/labs/2016-03-06/screens-device-orientation.png 395 293 %}

It might be tricky to create a whole iOS Swift project using portrait only and suddenly when your app is far down the road you need to give landscape orientation support for only one View Controller.

Immediately you could think... "I can get this done by using `func shouldAutorotate() -> Bool` and `func supportedInterfaceOrientations() -> UIInterfaceOrientationMask`".

The only problem of this is that you'll need to enable device rotation for both **Landscape Left and Right** and depending of your code structure you'll need to go over every simple View Controller adding `func shouldAutorotate() -> Bool` and `func supportedInterfaceOrientations() -> UIInterfaceOrientationMask`. It can be painful if you have a lot of classes.

Fortunately we can move all of the hard work to be done at one place, which is in our *AppDelegate.swift*.

<!--more-->

###Deployment Info - Device Orientation

If your project is already in portrait you won't need to change anything. If not, make sure that only portrait is selected.

{% img /images/labs/2016-03-06/device-orientation.png %}

###AppDelegate.swift

{% codeblock lang:objc AppDelegate.swift %}
...
func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
    if let rootViewController = self.topViewControllerWithRootViewController(window?.rootViewController) {
        if (rootViewController.respondsToSelector(Selector("canRotate"))) {
            // Unlock landscape view orientations for this view controller
            return .AllButUpsideDown;
        }
    }

    // Only allow portrait (standard behaviour)
    return .Portrait;
}

private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
    if (rootViewController == nil) { return nil }
    if (rootViewController.isKindOfClass(UITabBarController)) {
        return topViewControllerWithRootViewController((rootViewController as! UITabBarController).selectedViewController)
    } else if (rootViewController.isKindOfClass(UINavigationController)) {
        return topViewControllerWithRootViewController((rootViewController as! UINavigationController).visibleViewController)
    } else if (rootViewController.presentedViewController != nil) {
        return topViewControllerWithRootViewController(rootViewController.presentedViewController)
    }
    return rootViewController
}
...
{% endcodeblock %}

The method `topViewControllerWithRootViewController` gets the top View Controller from the window to checked if it has the method/selector `canRotate` implemented, if so `.AllButUpsideDown` is returned from `supportedInterfaceOrientationsForWindow`.

Now all you need to do is to implement an empty `canRotate` on the View Controller that you want to be rotated and before it gets disappeared return the orientation back to portrait.

Below you can see how our View Controller should be for both scenarios: *Show* and *Present Modally*

###Show

{% codeblock lang:objc ShowViewController.swift %}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()) {
            UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.Portrait.rawValue), forKey: "orientation")
        }
    }
    
    func canRotate() -> Void {}
}
{% endcodeblock %}

###Present Modally

{% codeblock lang:objc ShowViewController.swift %}
class PresentedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func didDismissButtonPress(sender: UIButton) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.Portrait.rawValue), forKey: "orientation")
        }
    }
    
    func canRotate() -> Void {}
}
{% endcodeblock %}

---
This project sample can be downloaded from [github][bb].

[bb]:https://github.com/jairobjunior/labs.jairobjunior.com.DeviceRotationOnlyOneViewController