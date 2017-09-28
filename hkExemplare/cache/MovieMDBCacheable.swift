//
//  MovieMDBCacheable.swift
//  hkExemplare
//
//  Created by Anderson Santos Gusmao on 27/09/17.
//  Copyright © 2017 Heuristisk. All rights reserved.
//

import Foundation
import TMDBSwift

class MovieMDBCacheable: NSObject, NSCoding {

    var title: String?
    var voteAverage: Double?
    var overview: String?

    init(title: String?, voteAverage: Double?, overview: String?) {
         self.title = title
         self.voteAverage = voteAverage
         self.overview = overview
    }

    init(movie: MovieMDB) {
        self.title = movie.title
        self.voteAverage = movie.vote_average
        self.overview = movie.overview
    }

    required convenience init(coder aDecoder: NSCoder) {
        let titleCoder = aDecoder.decodeObject(forKey: "title") as? String
        let vote_averageCoder = aDecoder.decodeObject(forKey: "vote_average") as? Double
        let overviewCoder = aDecoder.decodeObject(forKey: "overview") as? String
        self.init(title: titleCoder, voteAverage: vote_averageCoder, overview: overviewCoder)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(voteAverage, forKey: "vote_average")
        aCoder.encode(overview, forKey: "overview")
    }
}
