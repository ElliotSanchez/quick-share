# quick-share
### A simple photo sharing / camera app

[Quick Share by Elliot Sanchez on the App Store](https://itunes.apple.com/us/app/quick-share/id1173345834)

This is my first app store submission. It's based on sample code from ["The Complete iOS 10 Developer" Udemy course](https://www.udemy.com/the-complete-ios-10-developer-course/) by Grant Klimaytys, but has been rewritten into a very different app.

Although 2,000 students had taken the course when I enrolled, the example app had not yet been submitted to the App Store because major improvments were needed before it would meet Apple's quality standards.

I was able to make the neccesary improvements and the app was accepted in the app store as v1.0. I have since rewritten (or made further improvements to) most major components including navigation logic, UI/UX, and image processing which were submitted as v2.0.

My original contributions include:
* custom UX to replace standard navigation controller
* streamlined workflow to "front/back" metaphor for image views
* custom UI including most icons and segues
* simple multi-threading for improved responsiveness
* decreased memory footprint and cpu usage
* removed duplication of images for sharing dialog
* ongoing photos permission checking after initial failure
* camera roll reload after permission change
* full screen image preview prior to sharing
* autolayout for multiple devices / universal app
* force touch on supported devices
