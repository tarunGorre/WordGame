//
//  JsonParser.swift
//  WordGame
//
//  Created by Tarun Gorre on 16.07.19.
//  Copyright © 2019 Tarun Gorre. All rights reserved.
//

import Foundation

public class JsonParser {
    
    class func fetchTheWords(completion: @escaping (_ words: [WordModel]) -> ()) {
        // Fetch the data from bundle
        
        guard let jsonUrl = Bundle.main.url(forResource: "words", withExtension: "json") else { return }
        
        URLSession.shared.dataTask(with: jsonUrl) { (data, response, error) in
            guard let data = data else { return }
            do {
                let results = try JSONDecoder().decode([WordModel].self, from: data)
                completion(results)
            } catch let error {
                print("unable to serialize the json: ", error)
            }
        }.resume()
    }
}
