//
//  Cache.swift
//  hkExemplare
//
//  Created by Anderson Santos Gusmao on 27/09/17.
//  Copyright © 2017 Heuristisk. All rights reserved.
//

import Foundation
import TMDBSwift

class Cache {

    static var isAvailable: Bool {
        return UserDefaults.standard.dictionaryRepresentation().keys.contains("movies")
    }

    static func set(movies: [MovieMDB]) {

        let moviesMDBCacheable = convertToCacheable(movies: movies)

        let data = NSKeyedArchiver.archivedData(withRootObject: moviesMDBCacheable)
        UserDefaults.standard.setValue(data, forKey: "movies")
    }

    static func convertToCacheable(movies: [MovieMDB]) -> [MovieMDBCacheable] {
        var moviesMDBCacheable = [MovieMDBCacheable]()

        for movie in movies {
            moviesMDBCacheable.append(MovieMDBCacheable(movie: movie))
        }
        return moviesMDBCacheable
    }

    static func get() -> [MovieMDBCacheable] {
        if let rawData = UserDefaults.standard.value(forKey: "movies") as? Data {
            if let movies = NSKeyedUnarchiver.unarchiveObject(with: rawData) as? [MovieMDBCacheable] {
                return movies
            }
        }
        return [MovieMDBCacheable]()
    }
}
