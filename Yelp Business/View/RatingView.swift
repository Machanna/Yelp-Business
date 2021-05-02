//
//  RatingView.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/2/21.
//

import SwiftUI

struct RatingsView: View {
  private static let MAX_RATING: Float = 5
  private static let COLOR = Color.red

  let rating: Float
  let reviewCount: Int
  private let fullCount: Int
  private let emptyCount: Int
  private let halfFullCount: Int

    init(rating: Float, reviewCount: Int) {
    self.rating = rating
    self.reviewCount = reviewCount
    fullCount = Int(rating)
    emptyCount = Int(RatingsView.MAX_RATING - rating)
    halfFullCount = (Float(fullCount + emptyCount) < RatingsView.MAX_RATING) ? 1 : 0
  }

  var body: some View {
    HStack {
      ForEach(0..<fullCount, id: \.self) { _ in
         self.fullStar
       }
       ForEach(0..<halfFullCount, id: \.self) { _ in
         self.halfFullStar
       }
       ForEach(0..<emptyCount, id: \.self) { _ in
         self.emptyStar
       }
       Text(self.reviewCount > 0 ? String(self.reviewCount) : "")
        .font(.caption)
     }
  }

  private var fullStar: some View {
    Image(systemName: "star.fill").foregroundColor(RatingsView.COLOR)
  }

  private var halfFullStar: some View {
    Image(systemName: "star.lefthalf.fill").foregroundColor(RatingsView.COLOR)
  }

  private var emptyStar: some View {
    Image(systemName: "star").foregroundColor(RatingsView.COLOR)
  }
}


