//
//  AliveAPI.swift
//  Alive 2020
//
//  Created by Mark Stultz on 5/14/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

protocol AliveAPI {
    // POST
    func create(username: String, email: String, password: String, completion: (User?) -> ())
    func login(username: String, password: String, completion: (User?) -> ())
    func createStoryJob(completion: (StoryJob?) -> ())
}

class AliveService: AliveAPI {
    let session = URLSession.shared
    let baseUrl = URL(string: "0.0.0.0")
    
    func create(username: String, email: String, password: String, completion: (User?) -> ()) {
        guard let url = URL(string: "/api/v1/users", relativeTo: baseUrl) else {
            completion(nil)
            return
        }
        let dictionary = [
            "username": username,
            "email": email,
            "password": password
        ]
        let resource = Resource<User>(
            url: url,
            method: .post(dictionary)) { (any) -> User? in
                guard let json = any as? JSONDictionary else { return nil }
                return User(json: json)
        }
        let request = URLRequest(resource: resource)
        session.dataTask(with: request).resume()
    }
    
    func login(username: String, password: String, completion: (User?) -> ()) {
        guard let url = URL(string: "/api/v1/sessions/login", relativeTo: baseUrl) else {
            completion(nil)
            return
        }
        let dictionary = [
            "username": username,
            "password": password
        ]
        let resource = Resource<User>(
            url: url,
            method: .post(dictionary)) { (any) -> User? in
                guard let json = any as? JSONDictionary else { return nil }
                return User(json: json)
        }
        let request = URLRequest(resource: resource)
        session.dataTask(with: request).resume()
    }
    
    func createStoryJob(completion: (StoryJob?) -> ()) {
        guard let url = URL(string: "/api/v1/story_jobs", relativeTo: baseUrl) else {
            completion(nil)
            return
        }
        let dictionary: [String: Any] = [:]
        let resource = Resource<StoryJob>(
            url: url,
            method: .post(dictionary)) { (any) -> StoryJob? in
                guard let json = any as? JSONDictionary else { return nil }
                return StoryJob(json: json)
        }
        let request = URLRequest(resource: resource)
        session.dataTask(with: request).resume()
    }
}
