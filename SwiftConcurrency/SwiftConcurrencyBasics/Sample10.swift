//
//  Sample10.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

struct FibonacciSequence: Sequence {
    struct Iterator: IteratorProtocol {
        var state = (0, 1)
        mutating func next() -> Int? {
            let upcomingNumber = state.0
            state = (state.1, state.0 + state.1)
            return upcomingNumber
        }
    }
    
    func makeIterator() -> Iterator {
        .init()
    }
}

struct AsyncFibonacciSequence: AsyncSequence {
    typealias Element = Int
    
    struct AsyncIterator: AsyncIteratorProtocol {
        // 添加对外层序列的引用
        let sequence: AsyncFibonacciSequence
        var currentIndex = 0
        
        mutating func next() async throws -> Int? {
            defer { currentIndex += 1 }
            // 通过持有的序列引用调用方法
            return try await sequence.loadFibNumber(at: currentIndex)
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        // 创建迭代器时传入当前序列的引用
        AsyncIterator(sequence: self)
    }
    
    // 以下保持原样不变...
    func loadFibNumber(at index: Int) async throws -> Int {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC)
        return fibNumber(at: index)
    }
    
    func fibNumber(at index: Int) -> Int {
        if index == 0 { return 0 }
        if index == 1 { return 1 }
        return fibNumber(at: index - 2) + fibNumber(at: index - 1)
    }
}
