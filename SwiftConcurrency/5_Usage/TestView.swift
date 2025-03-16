//
//  TestView.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                // 与view的生命周期无关
            }
            .task {
                // 与view的生命周期相关
            }
    }
}

#Preview {
    TestView()
}
