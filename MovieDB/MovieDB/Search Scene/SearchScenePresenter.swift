//
//  SearchScenePresenter.swift
//  MovieDB
//
//  Created by Tolga Taş on 19.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchScenePresentationLogic {
    func presentMovies(response: SearchScene.Movies.Response)
    func presentPeople(response: SearchScene.People.Response)
    func presentGenres(response: SearchScene.Genres.Response)
}

class SearchScenePresenter: SearchScenePresentationLogic {
    weak var moviesViewController: SearchSceneMoviesDisplayLogic?
    weak var peopleViewController: SearchScenePeopleDisplayLogic?
    weak var genresViewController: SearchSceneGenresDisplayLogic?
  
    // MARK: Do something
  
    func presentMovies(response: SearchScene.Movies.Response) {
        let viewModel = SearchScene.Movies.ViewModel(movies: response.movies)
        moviesViewController?.displayMovies(viewModel: viewModel)
    }
    
    func presentPeople(response: SearchScene.People.Response) {
        let viewModel = SearchScene.People.ViewModel(people: response.people)
        peopleViewController?.displayPeople(viewModel: viewModel)
    }
    
    func presentGenres(response: SearchScene.Genres.Response) {
        let viewModel = SearchScene.Genres.ViewModel(genres: response.genres)
        genresViewController?.displayGenres(viewModel: viewModel)
    }
}
