//
//  Api.swift
//  hkExemplare
//
//  Created by Anderson Santos Gusmao on 26/09/17.
//  Copyright © 2017 Heuristisk. All rights reserved.
//

import Foundation
import TMDBSwift
import RxSwift
import RxCocoa

class Api {

    private static let unknownErrorMessage = "Unknown error"

    enum MoviesResponse {
        case sucess(movies: Variable<[MovieMDBCacheable]>)
        case error(reason: String)
    }

    static func getMovies(callback: @escaping (_ moviesResponse: MoviesResponse) -> Void) {

        if Cache.isAvailable {
            callback(Api.MoviesResponse.sucess(movies: Variable.init(Cache.get())))
        } else {
            MovieMDB.upcoming(Config.apiKey, page: 1, language: "en") { (client, data) in

                if client.error != nil {
                    callback(Api.MoviesResponse.error(reason: client.error?.description ?? unknownErrorMessage))
                } else if let dataSet = data {
                    Cache.set(movies: dataSet)
                    callback(Api.MoviesResponse.sucess(movies: Variable.init(
                        Cache.convertToCacheable(movies: dataSet))))
                }
            }
        }
    }

}
