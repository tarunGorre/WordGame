//
//  WordModel.swift
//  WordGame
//
//  Created by Tarun Gorre on 16.07.19.
//  Copyright © 2019 Tarun Gorre. All rights reserved.
//

import Foundation

struct WordModel: Codable {
    let wordEng: String
    let wordSpa: String
    enum CodingKeys: String, CodingKey {
        case wordEng = "text_eng"
        case wordSpa = "text_spa"
    }
}
