//
//  PersonDetailSceneWorker.swift
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
import PromiseKit

class PersonDetailSceneWorker {
    
    func getPersonDetail(personId: Int) -> Promise<PersonMDB> {
        return Promise { seal in
            PersonMDB.person_id(personID: personId) { (result, person) in
                guard let person = person else {
                    if let error = result.error {
                        seal.reject(error)
                    }
                    return
                }
                seal.fulfill(person)
            }
        }
    }
    
    func getPersonCredits(personId: Int) -> Promise<PersonMovieCredits> {
        return Promise { seal in
            PersonMDB.movie_credits(personID: personId, language: "en") { (result, credits) in
                guard let credits = credits else {
                    if let error = result.error {
                        seal.reject(error)
                    }
                    return
                }
                seal.fulfill(credits)
            }
        }
    }
}
