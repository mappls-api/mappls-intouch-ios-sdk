[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mappls.com/api)

# [Mappls Intouch SDK - MapplsIntouchCore]()

## [Introduction](#Introduction)

Mappls Intouch  will enable the live tracking functionality in your mobile app and allows you to get the powerful features from Intouch IoT platform for your telematics devices. Inotuch SDK for iOS lets you easily add Mappls Telematics cloud services to your own iOS application.

Using this SDK, Your app shall fetch the live location from the end user mobile phone at the predefined condition, It could be based on the movement of the user, or fixed time interval or the combination of both. You can customize the data polling conditions. Along with that  you can get the details about your other telematics device live locaion and analytics around that.

You will get seemless location benifits which caterted to different domains like `logistics`, `delivery tracking` , `Employee tracking` , `live location sharing`  etc.

-  [Publishable Key](https://apisupport@mappls.com) Get your Publishable Key please contact from apiSupport url (https://apisupport@mappls.com)

-  [Integrate the SDK]() Integrate the SDK into your app

-  [Dashboard](https://intouch.mappls.com/nextgen/#/home/dashboard) See all your devices' locations on Mappls Intouch Dashboard

## [Installation](#Installation)

This library is available through `CocoaPods`. To install, simply add the following line to your `podfile`:

```ruby
pod 'MapplsIntouchCore', '1.0.1'
```

Run pod repo update && pod install and open the resulting Xcode workspace.

## [Version History](#Version-History)

| Version | Dated | Description |
| :---- | :---- | :---- |
| `1.0.2`| 28 Nov 2024  | Claim controlled data polling configuration. |
| `1.0.1`| 16 Apr 2024  | Fixed some bugs related to data types. |
| `1.0.0`| 05 Oct 2023  | Fixed location tracking issue. |
| `1.0.0.beta.9 `| 23 Aug 2023  | |
| `1.0.0.beta.1 `| 13 Apr 2023  | |

### [Dependencies](#Dependencies)

This library depends upon `MapplsAPICore`. All dependent libraries will be automatically installed on using CocoaPods.

## [Setup](#Setup)

### [Publishable Key](#Publishable-Key). 

We use Publishable key to identify your account details and assign all your users device under single account. 

After getting the publishable key, you can [start with the IntouchDemo app](https://github.com/mappls-api), or [Integrate the Intouch SDK]([https://github.com/mappls.com](https://github.com/mappls-api)) in your app.

Setup a Project
This guide allows you to add a live location tracking to an iOS app. 

[Xcode IDE](https://developer.apple.com/xcode/) recommended download Xcode latest version from Appstore.

### [Location Permission](#Location-Permission)

For Privacy Policy of Location

Location Permission Map Prompt(Always allow)
For apps granted Always Allow location permissions, iOS 13 will periodically display a "map prompt" The "map prompt" displays the location points collected by the app. In testing, we've identified that this prompt will be triggered after 3 consecutive days of background location use, and will continue to appear periodically with continued use.

Add Location permission into your plist file
 Configure the location services by adding the following entries to the Info.plist file. locations and motion keys are mandatory.

- Location permissions
- CoreMotion Permissions

Above permissions can be added by using below keys in Info.plist of an application:

```    
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>""</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>""</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>""</string>
<key>NSMotionUsageDescription</key>
<string>""</string>
```

In your project settings, go to **Capabilities > Background Modes** and turn on background fetch, location updates.

To use SDK functionalities you must write import statements as shown below:

```swift
import MapplsIntouchCore
```

## [Initialization](#Initialization)

To work with SDK first call `setup` function on entry point of app i.e. on calling of `didFinishLaunchingWithOptions` of app.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Intouch.shared.setup()
}
```

Before start tracking SDK needs to be authenticate first. `Authenticate` SDK by calling function `initializeForCredentials` using your keys.

```swift
Intouch.shared.initializeForCredentials(clientId: ci, clientSecret: cs, deviceName: trimmedText, deviceIdentifier: nil) { isSuccess in
    if isSuccess {
        // Take action for success means now you can start tracking
    } else {
        // Take action for error
    }
} failure: { error in
    var errorMessage = "Unknown Error"
    if let error = error {
        errorMessage = error.localizedDescription
    }
    // Take action for error
}
```

### [Start Tracking](#Start-Tracking)

Call the below method to track your app user's phone live location.  Make sure your internet connection  will be on that time.

```swift
Intouch.shared.startTracking()
``` 

### [Stop Tracking](#Stop-Tracking)

Call the below method to Stop Track your app user's phone live location. 
We put these lines for stop beacon tracking  and  sensors  like gyro, aceelerometer., barometer , motion detectors.

```swift
Intouch.shared.stopTracking()
``` 


## [Intouch Configurations](#Intouch-Configurations)

`MapplsIntouchConfiguration` 

A configuration class for managing and customizing the behavior of the Mappls InTouch Core SDK. It provides various location settings, handles polling profiles, and manages settings fetched from device claims.

#### `desiredAccuracy` *(CLLocationAccuracy)*  
Specifies the desired accuracy for location updates.  
**Default**: `kCLLocationAccuracyBestForNavigation`.

#### `distanceFilter` *(CLLocationDistance)*  
Specifies the minimum distance (in meters) the device must move before generating a location update.  
**Default**: `kCLDistanceFilterNone`.

#### `activityType` *(CLActivityType)*  
Indicates the type of activity associated with the location updates (e.g., automotive navigation).  
**Default**: `.automotiveNavigation`.

#### `allowsBackgroundLocationUpdates` *(Bool)*  
Determines whether the app can receive location updates in the background.  
**Default**: `true`.

#### `pausesLocationUpdatesAutomatically` *(Bool)*  
Indicates whether the system can pause location updates when the app is running in the background.  
**Default**: `false`.

#### `requestAuthorizationStatus` *(CLAuthorizationStatus)*  
Represents the authorization status for location services.  
**Default**: `.authorizedWhenInUse`.

#### `showsBackgroundLocationIndicator` *(Bool)*  
Specifies whether to show the blue background location indicator when the app uses location services in the background.  
**Default**: `false`.

#### `itemCount` *(Int)*  
A getter property determines the maximum number of items that can be processed or stored. 
**Default**: `10`.  
**Dynamic**: This value may be updated based on device claims.

#### `sendingFrequency` *(Int)*  
A getter property Specifies the frequency (in seconds) for sending location data on the server.  
**Default**: `5`.  
**Dynamic**: This value may be updated based on device claims.

#### `avaliablePollingProfile` *([PollingProfile])*  
Returns a list of polling profiles available based on device claims.  
**Default**: Derived from the `pollingProfile` property.

#### `pollingProfile` *(PollingProfile)*  
Returns the currently selected polling profile.  

### Methods

#### `setPollingProfile(profile: PollingProfile) -> PollingProfile?`  
Updates the polling profile to the specified value if it is supported by the device.  
If the requested profile is not available, it attempts to set an alternative suitable profile.  

**Parameters**:  
- `profile`: The desired polling profile to set.  
**Returns**: The updated polling profile, or `nil` if no device details are available.    

---


<br>


<br>

For any queries and support, please contact:

[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="40"/> </p>](https://about.mappls.com/api/)

Email us at [apisupport@mappls.com](mailto:apisupport@mappls.com)

![](https://www.mapmyindia.com/api/img/icons/support.png)
[Support](https://about.mappls.com/contact/)
Need support? contact us!

<br></br>

[<p align="center"> <img src="https://www.mapmyindia.com/api/img/icons/stack-overflow.png"/> ](https://stackoverflow.com/questions/tagged/mappls-api)[![](https://www.mapmyindia.com/api/img/icons/blog.png)](https://about.mappls.com/blog/)[![](https://www.mapmyindia.com/api/img/icons/gethub.png)](https://github.com/mappls-api)[<img src="https://mmi-api-team.s3.ap-south-1.amazonaws.com/API-Team/npm-logo.one-third%5B1%5D.png" height="40"/> </p>](https://www.npmjs.com/org/mapmyindia) 

[<p align="center"> <img src="https://www.mapmyindia.com/june-newsletter/icon4.png"/> ](https://www.facebook.com/Mapplsofficial)[![](https://www.mapmyindia.com/june-newsletter/icon2.png)](https://twitter.com/mappls)[![](https://www.mapmyindia.com/newsletter/2017/aug/llinkedin.png)](https://www.linkedin.com/company/mappls/)[![](https://www.mapmyindia.com/june-newsletter/icon3.png)](https://www.youtube.com/channel/UCAWvWsh-dZLLeUU7_J9HiOA)

<div align="center">@ Copyright 2024 CE Info Systems Pvt. Ltd. All Rights Reserved.</div>

<div align="center"> <a href="https://about.mappls.com/api/terms-&-conditions">Terms & Conditions</a> | <a href="https://www.mappls.com/about/privacy-policy">Privacy Policy</a> | <a href="https://www.mappls.com/pdf/mappls-sustainability-policy-healt-labour-rules-supplir-sustainability.pdf">Supplier Sustainability Policy</a> | <a href="https://www.mappls.com/pdf/Health-Safety-Management.pdf">Health & Safety Policy</a> | <a href="https://www.mappls.com/pdf/Environment-Sustainability-Policy-CSR-Report.pdf">Environmental Policy & CSR Report</a>

<div align="center">Customer Care: +91-9999333223</div>
