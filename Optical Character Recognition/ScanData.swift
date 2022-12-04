//
//  ScanData.swift
//  Optical Character Recognition
//
//  Created by Minh Quan on 04/12/2022.
//

import Foundation

struct ScanData: Identifiable {
    var id = UUID()
    let content: String
    
    init(content: String) {
        self.content = content
    }
}
