//
//  WebService.swift
//  Alive 2020
//
//  Created by Mark Stultz on 5/13/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

enum HTTPResponse: UInt {
    case success = 200
    case unauthorized = 401
    case unprocessable = 422
}

enum HTTPMethod<Body> {
    case get
    case post(Body)
}

extension HTTPMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
    
    func map<T>(f: (Body) -> T) -> HTTPMethod<T> {
        switch self {
        case .get: return .get
        case .post(let body): return .post(f(body))
        }
    }
}

struct Resource<T> {
    let url: URL
    let method: HTTPMethod<Data>
    let parse: (Data) -> T?
}

extension Resource {
    init(url: URL, method: HTTPMethod<Any>, parseJSON: @escaping (Any) -> T?) {
        self.url = url
        self.method = method.map { json in
            try! JSONSerialization.data(withJSONObject: json, options: [])
        }
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            return json.flatMap(parseJSON)
        }
    }
}

extension URLRequest {
    init<T>(resource: Resource<T>) {
        self.init(url: resource.url)
        self.httpMethod = resource.method.method
        if case let .post(data) = resource.method {
            httpBody = data
        }
    }
}
