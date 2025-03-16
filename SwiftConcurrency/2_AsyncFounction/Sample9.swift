//
//  Sample9.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

import Foundation

// 定义文件操作错误类型
enum FileError: Error, CustomStringConvertible {
    case corrupted
    case fileNotFound
    case invalidAccess
    case calculationFailed
    
    var description: String {
        switch self {
        case .corrupted:
            return "文件已损坏"
        case .fileNotFound:
            return "文件不存在"
        case .invalidAccess:
            return "无访问权限"
        case .calculationFailed:
            return "文件大小计算失败"
        }
    }
}

class File {
    
    var corrupted = false
    
    var size: Int {
        get async throws {
            if corrupted {
                throw FileError.corrupted
            }
            return try await heavyOperation()
        }
    }
    
    func heavyOperation() async throws -> Int {
        return 100
    }
    
    typealias AttributeKey = String
    typealias Attribute = String?
    
    subscript(_ attribute: AttributeKey) -> Attribute {
        // 比如 await file[.readonly] == true
        get async {
            let attributes = await loadAttributes()
            return attributes[attribute] ?? nil
        }
    }
    
    func loadAttributes() async -> [AttributeKey: Attribute] {
        return [:]
    }
}
