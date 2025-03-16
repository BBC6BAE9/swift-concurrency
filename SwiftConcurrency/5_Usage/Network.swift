//
//  Usage.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation

class Network {
    // 传统的URLSession使用方式1
    func request1(){
        let task = URLSession.shared.dataTask(with: URL(string:"https://www.baidu.com")!) {
            data, response, error in
            if let error {
                print("Error: \(error)")
                return
            }
            if let data {
                print("Data: \(data.count) bytes.")
            }
        }
        task.resume()
    }
    
    // 传统的URLSession使用方式2
    func request2() {
        let session = URLSession(
            configuration: .default,
            delegate: Delegate(),
            delegateQueue: nil
        )
        let task = session.dataTask(with: URL(string:"https://www.baidu.com")!)
        task.resume()
    }
    
    // URLSession的使用新方式：异步 URLSession 方法
    func request3() async throws {
        let (data, response) = try await URLSession.shared.data(from: URL(string:"https://www.baidu.com")!)
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
        }
        print("Data: \(data.count) bytes.")
    }
    
    // 基于Bytes的异步序列
    func request4() async throws {
        let url = URL(string: "https://example.com")!
        let session = URLSession.shared
        let (bytes, _) = try await session.bytes(from: url)
        for try await byte in bytes {
            print(byte, terminator: ",")
        }
    }
    
    /// 基于Bytes的异步序列实战`
    /// - Returns: 判断图片是不是PNG
    func isPNG() async throws -> Bool {
        let url = URL(string: "https://example.com")!
        let session = URLSession.shared
        let (bytes, _) = try await session.bytes(from: url)
        var pngHeader: [UInt8] = [137, 80, 78, 71, 13, 10, 26, 10]
        for try await byte in bytes.prefix(8) {
            if byte != pngHeader.removeFirst() {
                return false
            }
        }
        return true
    }
    
    func printBaiduByLine() async throws {
        let url = URL(string: "https://baidu.com")!
        let session = URLSession.shared
        let (bytes, _) = try await session.bytes(from: url)
        for try await line in bytes.lines {
            print(line)
        }
    }
}

class Delegate: NSObject, URLSessionDataDelegate {
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler:
        @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        print("Receive response")
        completionHandler(.allow)
    }
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        print("Data chunk: \(data.count)")
    }
}


class Delegate1: NSObject, URLSessionDataDelegate {
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler:
        @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        if let scheme = response.url?.scheme,
           scheme.starts(with: "https")
        {
            completionHandler(.allow)
            
        }
        completionHandler(.cancel)
    }
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        print("Data chunk: \(data.count)")
    }
}


protocol P {
    func doSomething(completionHandler: @escaping (Bool) -> Void)
    func doSomething() async -> Bool
}

extension P {
    func doSomething() async -> Bool {
        await withUnsafeContinuation { continuation in
            doSomething { v in
                continuation.resume(returning: v)
            }
        }
    }
}

class S: P {
    func doSomething(completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
}

protocol P1 {
    func doSomething() async -> Bool
}

struct S1: P1 {
    func doSomething() -> Bool {
        return true
    }
}
