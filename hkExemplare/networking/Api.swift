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
    static let cache = NSCache<NSString, Cache>()
    private static var cachedObject = Cache()
    
    enum MoviesResponse {
        case sucess(movies: Variable<[MovieMDB]>)
        case error(reason: String)
    }
    
    static func getMovies(callback: @escaping (_ moviesResponse: MoviesResponse) -> Void) {
        
        if let cachedVersion = cache.object(forKey: "CachedObject") {
             callback(Api.MoviesResponse.sucess(movies: Variable.init(cachedVersion.source)))
        } else {
            MovieMDB.upcoming("9a74372440cacf0cd102b3521edbbd0c", page: 1, language: "en") { (client, data) in
                
                if client.error != nil {
                    callback(Api.MoviesResponse.error(reason: client.error?.description ?? unknownErrorMessage))
                } else if let dataSet = data {
                    cachedObject.source = dataSet
                    cache.setObject(cachedObject, forKey: "CachedObject")
                    callback(Api.MoviesResponse.sucess(movies: Variable.init(dataSet)))
                }
            }
        }
        
        
    }
}
