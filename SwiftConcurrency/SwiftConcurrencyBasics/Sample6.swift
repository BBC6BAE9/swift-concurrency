//
//  Sample.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

// Continution对付block的异步方式
class Sample6 {
    
    func load(completion: @escaping ([String]?, Error?) -> Void) {
        completion(["aaa", "bbb"], nil)
    }
    
    func load() async throws -> [String] {
        try await withUnsafeThrowingContinuation { continuation in
            load { values, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let values {
                    continuation.resume(returning: values)
                } else {
                    assertionFailure("Both parameters are nil")
                }
            }
        }
    }
    
    // 控制台输出：
    // SWIFT TASK CONTINUATION MISUSE: load() leaked its continuation!”
    func load1() async throws -> [String] {
        try await withCheckedThrowingContinuation { continuation in
            load { values, error in
                // 什么都不做
            }
        }
    }
    
    // ⚠️ 预期会崩溃
    func load2() async throws -> [String] {
        try await withCheckedThrowingContinuation { continuation in
            load { values, error in
                if let values {
                    // 多次调用 `resume`
                    continuation.resume(returning: values)
                    continuation.resume(returning: values)
                }
            }
        }
    }
    
}

// 由于 Checked 的一系列特性都和运行时相关，因此对续体的使用情况进行检查 (以及存储额外的调试信息)，会带来额外的开销。因此，在一些性能关键的地方，在确认无误的情况下，使用 Unsafe 版本会提升一些性能。因为除了 Checked 和 Unsafe 之外，两个API 在语法上并没有区别，所以按照 Debug 版本和 Release 版本的编译条件进行互换也并不困难。不过需要记住的是，就算使用 Checked 版本，也不意味着万事大吉，它只是一个很弱的运行时检查：对于没有调用 resume 的情况，虽然异步函数会在续体超出捕获域后自动继续，但是没有 resume 的任务依然被泄漏了；对于多次调用 resume 的情况，运行时崩溃的严重性更是不言而喻。无论如何，它们依然是程序运行的重大错误，Checked 能做的只是帮助我们更容易地发现这些错误，而不是帮我们直接解决这些错误。
