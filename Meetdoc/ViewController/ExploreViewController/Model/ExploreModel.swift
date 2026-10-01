//
//  ExploreModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 27/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class ExploreModel {

    var result : ExploreResult!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = ExploreResult(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }

}
class ExploreResult{

    var banner : [Banner]!
    var defaultCurrency : String!
    var defaultCurrencyCode : String!
    var emailVerified : Bool!
    var featuredListing : [ExploreListing]!
    var featuredListingCount : Int!
    var hostBlock : Bool!
    var popularDestination : [PopularDestination]!
    var popularListing : [ExploreListing]!
    var popularListingCount : String!
    var recentListingCount : Int!
    var recentView : [ExploreListing]!
    var recentlyAdded : [ExploreListing]!
    var specialities : [Speciality]!
    var status : Bool!
    var doctors : [Doctor]!
  
     init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        banner = [Banner]()
        let bannerArray = json["banner"].arrayValue
        for bannerJson in bannerArray{
            let value = Banner(fromJson: bannerJson)
            banner.append(value)
        }
      
        defaultCurrency = json["default_currency"].stringValue
        defaultCurrencyCode = json["default_currency_code"].stringValue
        emailVerified = json["email_verified"].boolValue
        featuredListing = [ExploreListing]()
        let featuredListingArray = json["featured_listing"].arrayValue
        for featuredListingJson in featuredListingArray{
            let value = ExploreListing(fromJson: featuredListingJson)
            featuredListing.append(value)
        }
        featuredListingCount = json["featured_listing_count"].intValue
        hostBlock = json["host_block"].boolValue
        popularDestination = [PopularDestination]()
        let popularDestinationArray = json["popular_destination"].arrayValue
        for popularDestinationJson in popularDestinationArray{
            let value = PopularDestination(fromJson: popularDestinationJson)
            popularDestination.append(value)
        }
        popularListing = [ExploreListing]()
        let popularListingArray = json["popular_listing"].arrayValue
        for popularListingJson in popularListingArray{
            let value = ExploreListing(fromJson: popularListingJson)
            popularListing.append(value)
        }
        popularListingCount = json["popular_listing_count"].stringValue
        recentListingCount = json["recent_listing_count"].intValue
        recentView = [ExploreListing]()
        let recentViewArray = json["recent_view"].arrayValue
        for recentViewJson in recentViewArray{
            let value = ExploreListing(fromJson: recentViewJson)
            recentView.append(value)
        }
              specialities = [Speciality]()
               let specialitiesArray = json["specialities"].arrayValue
               for specialitiesJson in specialitiesArray{
                let value = Speciality(fromJson: specialitiesJson)
                specialities.append(value)
               }
               doctors = [Doctor]()
               let doctorsArray = json["doctors"].arrayValue
               for doctorsJson in doctorsArray{
                   let value = Doctor(fromJson: doctorsJson)
                doctors.append(value)
               }
 
        recentlyAdded = [ExploreListing]()
        let recentlyAddedArray = json["recently_added"].arrayValue
        for recentlyAddedJson in recentlyAddedArray{
            let value = ExploreListing(fromJson: recentlyAddedJson)
            recentlyAdded.append(value)
        }
    }
}
class ListPhoto{

    var imageUrl : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        imageUrl = json["image_url"].stringValue
    }
 }
 class PopularDestination{

    var countryId : Int!
    var countryName : String!
    var image : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
     }

}
class Speciality {
 
    var specialityId : String!
    var specialityName : String!
    var totalListcount : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        specialityId = json["speciality_id"].stringValue
        specialityName = json["speciality_name"].stringValue
        totalListcount = json["total_listcount"].stringValue
     }
}
class Doctor {
       var averageRating : String!
       var doctorId : String!
       var doctorImage : String!
       var doctorName : String!
       var isliked : Bool!
       var totalReview : String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
               averageRating = json["average_rating"].stringValue
               doctorId = json["doctor_id"].stringValue
               doctorImage = json["doctor_image"].stringValue
               doctorName = json["doctor_name"].stringValue
               isliked = json["isliked"].boolValue
               totalReview = json["total_review"].stringValue
     }
}
class ExploreListing: Equatable{

    var accommodates : Int!
    var averageRating : Int!
    var bedrooms : Int!
    var beds : Int!
    var currency : String!
    var descriptionField : String!
    var durationType : String!
    var hostId : Int!
    var hostImage : String!
    var hostName : String!
    var lat : String!
    var liked : String!
    var listCurrency : String!
    var listId : String!
    var listName : String!
    var listPhotos : [ListPhoto]!
    var lon : String!
    var price : Float!
    var propertyType : String!
    var roomType : String!
    var totalReviews : Double!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        accommodates = json["accommodates"].intValue
        averageRating = json["average_rating"].intValue
        bedrooms = json["bedrooms"].intValue
        beds = json["beds"].intValue
        currency = json["currency"].stringValue
        descriptionField = json["description"].stringValue
        durationType = json["duration_type"].stringValue
        hostId = json["host_id"].intValue
        hostImage = json["host_image"].stringValue
        hostName = json["host_name"].stringValue
        lat = json["lat"].stringValue
        liked = json["liked"].stringValue
        listCurrency = json["list_currency"].stringValue
        listId = json["list_id"].stringValue
        listName = json["list_name"].stringValue
        listPhotos = [ListPhoto]()
        let listPhotosArray = json["list_photos"].arrayValue
        for listPhotosJson in listPhotosArray{
            let value = ListPhoto(fromJson: listPhotosJson)
            listPhotos.append(value)
        }
        lon = json["lon"].stringValue
        price = json["price"].floatValue
        propertyType = json["property_type"].stringValue
        roomType = json["room_type"].stringValue
        totalReviews = json["total_reviews"].doubleValue
    }
    static func == (lhs: ExploreListing, rhs: ExploreListing) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
}
class Banner{

    var bannerDes : String!
    var bannerImage : String!
    var bannerName : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bannerDes = json["banner_des"].stringValue
        bannerImage = json["banner_image"].stringValue
        bannerName = json["banner_name"].stringValue
    }

}
