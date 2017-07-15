//
//  Api.swift
//  Alive 2020
//
//  Created by Mark Stultz on 5/14/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

typealias JsonDictionary = [String: Any]

enum HttpResponse: Int {
    case success = 200
    case unauthorized = 401
    case unprocessable = 422
}

enum Api {
    // Users
    case create(username: String, email: String, password: String)
    case login(username: String, password: String)
    
    // Stories
    case primaryStory(userId: UInt)
    case createStoryJob()
}

extension Api {
    func path() -> String {
        switch self {
        case .create(_, _, _): return "users"
        case .login(_, _): return "login"
        case .primaryStory(let userId): return "users/\(userId)/stories/primary_story"
        case .createStoryJob: return "story_jobs"
        }
    }
    
    func httpMethod() -> String {
        switch self {
        case .create(_, _, _): return "POST"
        case .login(_, _): return "POST"
        case .primaryStory(_): return "GET"
        case .createStoryJob: return "POST"
        }
    }
    
    func baseUrl() -> URL? {
        return URL(string: "http://dev-api.alive2020.com/api/v1/")
    }
    
    func url() -> URL? {
        return URL(string: path(), relativeTo: baseUrl())
    }
    
    func parameters() -> JsonDictionary? {
        switch self {
        case .create(let username, let email, let password):
        return [
            "username": username,
            "email": email,
            "password": password
        ]
        case .login(let username, let password):
        return [
            "username": username,
            "password": password
        ]
        default:
            return nil
        }
    }
    
    func request() -> URLRequest? {
        guard let url = url() else { return nil }
       
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters() {
            request.httpBody = try? JSONSerialization.data(
                withJSONObject: parameters,
                options: [])
        }
       
        return request
    }
}

class Service {
    let session = URLSession.shared
    
    public var authorization: String? = nil
   
    func create(username: String, email: String, password: String, completion: ((User?) -> ())?) {
        let api = Api.create(
            username: username,
            email: email,
            password: password)
        guard let request = api.request() else { return }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch HttpResponse(rawValue: response.statusCode) {
                case .success?: print("success")
                case .unauthorized?: print("unauthorized")
                case .unprocessable?: print("unprocessable")
                    /*data -> "message" */
                case nil: print("Unknown \(response.statusCode)")
                }
            }
            
            var user: User? = nil
          
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonDict = json as? JsonDictionary,
                let userDict = jsonDict["user"] as? JsonDictionary {
                user = User(json: userDict)
            }
            
            completion?(user)
        }
        
        task.resume()
    }
    
    func login(username: String, password: String, completion: ((User?) -> ())?) {
        let api = Api.login(username: username, password: password)
        guard let request = api.request() else { return }
       
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch HttpResponse(rawValue: response.statusCode) {
                case .success?: print("success")
                case .unauthorized?: print("unauthorized")
                case .unprocessable?: print("unprocessable")
                    /*data -> "message" */
                case nil: print("Unknown \(response.statusCode)")
                }
            }
            
            var user: User? = nil
          
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonDict = json as? JsonDictionary,
                let userDict = jsonDict["user"] as? JsonDictionary {
                user = User(json: userDict)
            }
            
            completion?(user)
        }
        
        task.resume()
    }
    
    func primaryStory(userId: UInt, completion: ((Story?) -> ())?) {
        let api = Api.primaryStory(userId: userId)
        guard let request = api.request() else { return }
       
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch HttpResponse(rawValue: response.statusCode) {
                case .success?: print("success")
                case .unauthorized?: print("unauthorized")
                case .unprocessable?: print("unprocessable")
                    /*data -> "message" */
                case nil: print("Unknown \(response.statusCode)")
                }
            }
            
            var story: Story? = nil

            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonDict = json as? JsonDictionary,
                let storyDict = jsonDict["story"] as? JsonDictionary {
                story = Story(json: storyDict)
            }
            
            completion?(story)
        }
        
        task.resume()
    }
    
    func createStoryJob(completion: ((StoryJob?, AwsCredentials?) ->())?) {
        let api = Api.createStoryJob()
        guard var request = api.request() else { return }
        request.authorize(authorization: authorization)
       
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch HttpResponse(rawValue: response.statusCode) {
                case .success?: print("success")
                case .unauthorized?: print("unauthorized")
                case .unprocessable?: print("unprocessable")
                    /*data -> "message" */
                case nil: print("Unknown \(response.statusCode)")
                }
            }
            
            var storyJob: StoryJob? = nil
            var credentials: AwsCredentials? = nil

            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonDict = json as? JsonDictionary,
                let storyJobDict = jsonDict["storyJob"] as? JsonDictionary,
                let awsDict = jsonDict["aws"] as? JsonDictionary,
                let credentialsDict = awsDict["credentials"] as? JsonDictionary {
                storyJob = StoryJob(json: storyJobDict)
                credentials = AwsCredentials(json: credentialsDict)
            }
            
            completion?(storyJob, credentials)
        }
        
        task.resume()
    }
}

extension URLRequest {
    mutating func authorize(authorization: String?) {
        guard let authorization = authorization else { return }
        setValue("JWT \(authorization)", forHTTPHeaderField: "Authorization")
    }
}
