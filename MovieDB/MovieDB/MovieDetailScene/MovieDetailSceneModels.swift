//
//  MovieDetailSceneModels.swift
//  MovieDB
//
//  Created by Tolga Taş on 20.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import TMDBSwift

enum MovieDetailScene {
    // MARK: Use cases
  
    enum Something {
        struct Request {}
        struct Response {
            var movieDetail: MovieDetailedMDB?
            var credits: MovieCreditsMDB?
            var message: String?
        }
        struct ViewModel {
            var movieDetail: MovieDetailedMDB?
            var credits: MovieCreditsMDB?
        }
    }
}