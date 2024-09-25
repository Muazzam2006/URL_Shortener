//
//  File.swift
//  
//
//  Created by Nexus on 8/5/24.
//

import Foundation

let chars = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

func randUrl(from chars: String, length: Int) -> String {
    var randUrl = ""
    let charArray = Array(chars)
    
    for _ in 0..<length {
        let randInd = Int.random(in: 0..<charArray.count)
        randUrl += String(charArray[randInd])
    }
    
    return randUrl
}
