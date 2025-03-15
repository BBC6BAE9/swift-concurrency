//
//  Sample1.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

// 异步函数：提供语法工具，使用更简洁和高效的方式，表达异步行为。
class Sample1 {
    
    func test() {
        Task{
            let _ = await loadFromDatabase()
        }
    }
    
    // 异步函数
    func loadFromDatabase() async -> String {
        return ""
    }
}
