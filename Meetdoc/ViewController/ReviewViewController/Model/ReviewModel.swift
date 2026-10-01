//
//  ReviewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 17/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReviewModelList{
    
    var averageRating : String!
    var review : [ReviewModel]!
    var status : Bool!
    var totalReviews : String!
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        averageRating = json["average_rating"].stringValue
        review = [ReviewModel]()
        let reviewArray = json["review"].arrayValue
        for reviewJson in reviewArray{
            let value = ReviewModel(fromJson: reviewJson)
            review.append(value)
        }
        status = json["status"].boolValue
        totalReviews = json["total_reviews"].stringValue
    }
}

class ReviewModel{
   
   var bookingId : String!
   var reviewDate : Int!
   var reviewId : String!
   var reviewRating : String!
   var reviewerId : String!
   var reviewerImage : String!
   var reviewerName : String!
   var userReview : String!

    init(fromJson json: JSON!){
       if json.isEmpty{
           return
       }
       bookingId = json["booking_id"].stringValue
       reviewDate = json["review_date"].int ?? json["date"].intValue
       reviewId = json["review_id"].stringValue
        reviewRating = json["review_rating"].stringValue

        if json["review_rating"].stringValue == "" {
            reviewRating = json["rating"].stringValue
        }
       reviewerId = json["reviewer_id"].stringValue
       reviewerImage = json["reviewer_image"].string ?? json["profile_image"].stringValue
       reviewerName = json["reviewer_name"].string ?? json["username"].stringValue
       userReview = json["user_review"].string ?? json["review"].stringValue
   }
   init(bookingId : String, reviewDate : Int, reviewId : String, reviewRating : String, reviewerId : String, reviewerImage : String, reviewerName : String, userReview : String) {
       self.bookingId = bookingId
       self.reviewDate = reviewDate
       self.reviewId = reviewId
       self.reviewRating = reviewRating
       self.reviewerId = reviewerId
       self.reviewerImage = reviewerImage
       self.reviewerName = reviewerName
       self.userReview = userReview
   }

}
