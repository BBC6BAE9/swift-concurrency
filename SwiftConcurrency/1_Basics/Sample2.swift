//
//  Sample2.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

// 结构化并发：提供并发的运行环境，负责正确的函数调度、取消和执行顺序以及任务的生命周期。
// 如果想使用结构化并发可以使用 异步绑定 async let，或者使用 withThrowingTaskGroup
class Sample2 {
    
    struct NoSignatureError: Error {}
    
    var results: [String] = []
    
    func demoProcessFromScratch() async throws {
        do{
            let strings = try await loadFromDatabase()
            if let signature = try await loadSignature() {
                strings.forEach {
                    addAppending(signature, to: $0)
                }
            }
        } catch {
            throw NoSignatureError()
        }
    }

    func processFromScratch() async throws {
        // async let 被称为异步绑定
        // loadFromDatabase 和 loadSignature 并行执行
        async let loadStrings = loadFromDatabase()
        async let loadSignature = loadSignature()
        results = []
        let strings = try await loadStrings
        if let signature = try await loadSignature {
            strings.forEach {
                addAppending(signature, to: $0)
            }
        } else {
            throw NoSignatureError()
        }
    }
    
    func someSyncMethod() {
        Task {
            await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    try await self.loadResultRemotely()
                }
                group.addTask(priority: .low) {
                    try await self.processFromScratch()
                }
            }
            print("Done: \(results)")
        }
    }

    func loadResultRemotely() async throws {
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
        results = ["data1^sig", "data2^sig", "data3^sig"]
    }
    
    func loadFromDatabase() async throws -> [String] {
        let results = ["data1^sig", "data2^sig", "data3^sig"]

        return results
    }
    
    func loadSignature() async throws -> String? {
        return "sig"
    }
    
    func addAppending(_ signature: String, to: String) {
        let newString = "\(to)^\(signature)"
        results.append(newString)
    }
}
