//
//  Sample4.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

// Sample4 是对 Sample3 的改进，引入了action
class Sample4 {

    actor Holder {
        var results: [String] = []
        func setResults(_ results: [String]) {
            self.results = results
        }
        func append(_ value: String) {
            results.append(value)
        }
    }
    
    struct NoSignatureError: Error {}
    
    var holder = Holder()
    
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
        await holder.setResults([])
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
            print("Done: \(await holder.results)")
        }
    }

    func loadResultRemotely() async throws {
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
        await holder.setResults(["data1^sig", "data2^sig", "data3^sig"])
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
        Task{
            await holder.append(newString)
        }
    }
}


// ⚠️ 代码写到现在为止，只保证了程序不会崩溃，但是数据仍有可能出错
