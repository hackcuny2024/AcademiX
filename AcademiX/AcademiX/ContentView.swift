//
//  ContentView.swift
//  AcademiX
//
//  Created by Olti Gjoni on 2/16/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .book
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @ViewBuilder
    func tabView(for tab: Tab) -> some View {
        switch tab {
        case .book:
            CourseView() // This is where you want to show the CourseView
        case .calendar:
            CalendarView()
        case .gearshape:
            TestView()
        }
    }
    
    var body: some View {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        tabView(for: tab)
                            .tag(tab)
                    }
                }
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
}

#Preview {
    ContentView()
}
