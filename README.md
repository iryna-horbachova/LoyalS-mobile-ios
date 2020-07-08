## LoyalS project
Application for users to make check-ins in different places (restaurants, hotels, theatres, etc.) and get coins which can be exchanged for discounts.

Project developed in the group of 5 people for the University Project Practice, during which we worked through different phases of software development, created Vision and Scope document, Software Requirements, USE-case/object/class/component/deployment diagrams.

All documents for the project can be found here: https://drive.google.com/drive/u/3/folders/1lGUnmUW0eHjTFf0bNZcyx4qlWQUHyY6t

## LoyalS iOS app

This is an iOS part of the project, created with xCode 10.1 for iOS 12.1. Utilized Swift 4.2, UIKit, Alamofire and SwiftyJSON to work with API, Firebase SDK to manage personal accounts, CoreLocation to manage user's and places' locations, CocoaPods to install dependencies.
![Demo](https://github.com/iryna-horbachova/LoyalS-mobile-ios/blob/master/loyals_demo.jpeg) 

### App features
1. User authentication.
2. Lists of different places with additional info about them.
3. Liss of different discounts which user can get.
3. Check-in in on of the listed places to get coins (application checks that your current location matches the location of the place).
4. Exchange coins for one of the discounts (get QR-code, which can be used in the desired place).
5. Suggestion of places which user would like to see in our app via map search.
6. Profile with coins balance and history of bought discounts.

###### Warning!! In order to have this app running on your machine, you should install server first (check below) and change path to it in API Manager -> Constants.

## Other parts of the project

Back-end for the project: https://github.com/proomka/LoyalS-mobile-backens

Admin part to add/edit places: https://github.com/AndyP1erce/LoyalS-admin

Presentation and demo promo video (without some of the current features): https://drive.google.com/drive/u/3/folders/1HgyyXVC9LbybdoAt8PRcKC_sWCOYT3lo
