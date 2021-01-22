//
//  SearchSceneInteractor.swift
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

protocol SearchSceneBusinessLogic {
    func discoverMovies(page: Int)
    func discoverPeople(page: Int)
    func discoverGenres()
    
    func searchMovies(text: String, page: Int)
    func searchPeople(text: String, page: Int)
}

protocol SearchSceneDataStore {
    //var name: String { get set }
}

class SearchSceneInteractor: SearchSceneBusinessLogic, SearchSceneDataStore {
    var presenter: SearchScenePresentationLogic?
    var worker: SearchSceneWorker?
    //var name: String = ""
  
    // MARK: - Discover Functions
  
    func discoverMovies(page: Int) {
        worker = SearchSceneWorker()
        
        guard let worker = worker else { return }
        
        worker.discoverMovie(page: page).done { result in
            let response = SearchScene.Movies.Response(movies: result, message: nil)
            self.presenter?.presentMovies(response: response)
        }.catch{ error in
            let response = SearchScene.Movies.Response(movies: nil, message: error.localizedDescription)
            self.presenter?.presentMovies(response: response)
        }
    }
    
    func discoverPeople(page: Int) {
        worker = SearchSceneWorker()
        
        guard let worker = worker else { return }
        
        worker.discoverPeople(page: page).done { result in
            let response = SearchScene.People.Response(people: result, message: nil)
            self.presenter?.presentPeople(response: response)
        }.catch { error in
            let response = SearchScene.People.Response(people: nil, message: error.localizedDescription)
            self.presenter?.presentPeople(response: response)
        }
    }
    
    func discoverGenres() {
        worker = SearchSceneWorker()
        
        guard let worker = worker else { return }
        
        worker.discoverGenre().done { result in
            let response = SearchScene.Genres.Response(genres: result, message: nil)
            self.presenter?.presentGenres(response: response)
        }.catch { error in
            let response = SearchScene.Genres.Response(genres: nil, message: error.localizedDescription)
            self.presenter?.presentGenres(response: response)
        }
    }
    
    // MARK: - Search Functions
    func searchMovies(text: String, page: Int) {
        worker = SearchSceneWorker()
        
        guard let worker = worker else { return }
        
        worker.searchMovie(text: text, page: page).done { result in
            let response = SearchScene.Movies.Response(movies: result, message: nil)
            self.presenter?.presentMovies(response: response)
        }.catch{ error in
            let response = SearchScene.Movies.Response(movies: nil, message: error.localizedDescription)
            self.presenter?.presentMovies(response: response)
        }
    }
    
    func searchPeople(text: String, page: Int) {
        worker = SearchSceneWorker()
        
        guard let worker = worker else { return }
        
        worker.searchPeople(text: text, page: page).done { result in
            let response = SearchScene.People.Response(people: result, message: nil)
            self.presenter?.presentPeople(response: response)
        }.catch { error in
            let response = SearchScene.People.Response(people: nil, message: error.localizedDescription)
            self.presenter?.presentPeople(response: response)
        }
    }
}
