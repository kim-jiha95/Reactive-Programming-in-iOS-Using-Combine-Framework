//
//  String+Extensions.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/6/24.
//


import Foundation

extension String {
    
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }    
}

