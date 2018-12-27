//
//  DogAPI.swift
//  Randog
//
//  Created by Oti Oritsejafor on 12/23/18.
//  Copyright © 2018 Magloboid. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {
    enum Endpoint {
        case allBreedsURL //= URL(string: "https://dog.ceo/api/breeds/list/all")
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case.allBreedsURL:
                return "https://dog.ceo/api/breeds/list/all"
            
            }
        }
    }
    
    class func requestDogBreedsList(completionHandler: @escaping ([String]?, Error?) -> Void) {
        let listURL = DogAPI.Endpoint.allBreedsURL.url
        let task = URLSession.shared.dataTask(with: listURL) {
            (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            var listData: DogBreed
            var dogBreeds: [String]
            do {
                listData = try decoder.decode(DogBreed.self, from: data)
                //dogBreeds = listData.message
                dogBreeds = Array(listData.message.keys)
                completionHandler(dogBreeds, nil)
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    class func requestRandomImage(breed: String,
                                  completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndpoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) {
            (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let imageData = try decoder.decode(DogImage.self, from: data)
                completionHandler(imageData, nil)

            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    class func requestImageFile(imageFileURL: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: imageFileURL, completionHandler: {
            (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })
        
        task.resume()
    }
    
}
