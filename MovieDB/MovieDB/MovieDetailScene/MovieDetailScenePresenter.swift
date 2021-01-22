//
//  MovieDetailScenePresenter.swift
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

protocol MovieDetailScenePresentationLogic {
    func presentMovieDetail(response: MovieDetailScene.Something.Response)
}

class MovieDetailScenePresenter: MovieDetailScenePresentationLogic {
    weak var viewController: MovieDetailSceneDisplayLogic?
  
    // MARK: Do something
  
    func presentMovieDetail(response: MovieDetailScene.Something.Response) {
        let viewModel = MovieDetailScene.Something.ViewModel(movieDetail: response.movieDetail, credits: response.credits)
        viewController?.displayMovieDetail(viewModel: viewModel)
    }
}
