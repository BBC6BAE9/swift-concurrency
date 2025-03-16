//
//  Sample10Tests.swift
//  SwiftConcurrencyTests
//
//  Created by hong on 3/16/25.
//

import Testing

struct Sample10Tests {
    
    @Test func TestFibonacciSequence() async throws {
        var fib = FibonacciSequence().makeIterator()
        #expect(fib.next() == 0)
        #expect(fib.next() == 1)
        #expect(fib.next() == 1)
        #expect(fib.next() == 2)
        #expect(fib.next() == 3)
        #expect(fib.next() == 5)
    }
    
    @Test func TestAsyncFibonacciSequence1() async throws {
        let asyncFib = AsyncFibonacciSequence()
        for try await v in asyncFib {
            if v < 20 {
                print("Async Fib: \(v)")
            } else {
                break
            }
        }
    }
    
    @Test func TestAsyncFibonacciSequence2() async throws {
        let asyncFib = AsyncFibonacciSequence()
        var iter = asyncFib.makeAsyncIterator()
        while let v = try await iter.next() {
            print("Async Fib: \(v)")
        }
    }
    
    @Test func TestAsyncFibonacciSequence3() async throws {
        let asyncFib = AsyncFibonacciSequence()
        for try await v in asyncFib {
            if v < 20 {
                // continue
            } else {
                break
            }
        }
        for try await v in asyncFib {
            print("Next value: \(v)")
        }
    }
    
    // TODO：能中继的迭代器
    @Test func TestAsyncFibonacciSequence4() async throws {
        
    }
    
    @Test func TestAsyncFibonacciSequence5() async throws {
        let seq = AsyncFibonacciSequence()
        .filter { $0.isMultiple(of: 2) }
        .prefix(5)
        .map { $0 * 2 }
        for try await v in seq {
            print(v)
        }
    }
}
