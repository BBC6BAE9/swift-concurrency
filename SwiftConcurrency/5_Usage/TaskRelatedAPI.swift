//
//  TaskRelatedAPI.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

func asyncMethod() async throws -> Bool {
    try await Task.sleep(nanoseconds: NSEC_PER_SEC)
    return true
}

func syncMethod() throws {
    Task {
        try await asyncMethod()
    }
}

func anotherAsyncMethod() async throws {
    let task = Task {
        try await asyncMethod()
    }
    let result = try await task.value
    print(result) // true
}
