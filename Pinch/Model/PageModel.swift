//
//  PageModel.swift
//  Pinch
//
//  Created by Hugo Vázquez Paleo on 12/12/24.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String { "thumb-\(imageName)" }
}
