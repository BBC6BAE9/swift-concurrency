//
//  Sample3.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation


// Sample3 是对Sample2的线程安全问题的改进
class Sample3 {

    class Holder {
        private let queue = DispatchQueue(label: "resultholder.queue")
        private var results: [String] = []
        func getResults() -> [String] {
            queue.sync { results }
        }
        func setResults(_ results: [String]) {
            queue.sync { self.results = results }
        }
        func append(_ value: String) {
            queue.sync { self.results.append(value) }
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
        holder.setResults([])
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
            print("Done: \(holder.getResults())")
        }
    }

    func loadResultRemotely() async throws {
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
        holder.setResults(["data1^sig", "data2^sig", "data3^sig"])
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
        holder.append(newString)
    }
}
