//
//  Sample7.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

// Continution对付delegate的异步方式
protocol WorkDelegate {
    func workDidDone(values: [String])
    func workDidFailed(error: Error)
}

class Worker: WorkDelegate {
    var continuation: CheckedContinuation<[String], Error>?
    func doWork() async throws -> [String] {
        try await withCheckedThrowingContinuation({ continuation in
            self.continuation = continuation
            performWork(delegate: self)
        })
    }
 
    func performWork(delegate: Worker) {
        
    }
    
    func workDidDone(values: [String]) {
        continuation?.resume(returning: values)
        continuation = nil
    }
    
    func workDidFailed(error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
    
}

