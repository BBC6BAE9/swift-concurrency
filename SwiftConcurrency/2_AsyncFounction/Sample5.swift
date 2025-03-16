//
//  Sample5.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

class Sample5 {
    
    func calculate(input: Int, completion: @escaping (Int) -> Void) {
        completion(input + 100)
    }
    
    func calculate(input: Int) async -> Int {
        return input + 100
    }
    
}
