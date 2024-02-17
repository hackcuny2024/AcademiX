//
//  CustomTabBar.swift
//  AcademiX
//
//  Created by Olti Gjoni on 2/16/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case book //books.vertical
    case calendar //calendar.circle
    case gearshape //gearshape
    
    // A computed property to return the system image name
    var systemImageName: String {
        switch self {
        case .book: return "books.vertical"
        case .calendar: return "calendar.circle"
        case .gearshape: return "gearshape"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    private var tabColor: Color{
        switch selectedTab {
        case .book:
            return .blue
        case .calendar:
            return .green
        case .gearshape:
            return .indigo
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? tab.systemImageName + ".fill" : tab.systemImageName)
                        .scaleEffect(selectedTab == tab ? 1.85 : 1.5)
                            .foregroundColor(selectedTab == tab ? tabColor : .gray)
                            .font(.system(size: 22))
                            .onTapGesture{
                                withAnimation(.easeIn(duration: 0.1)){
                                    selectedTab = tab
                                }
                            }
                    Spacer()
                }
                
            }
            .frame(width: nil, height: 65)
            .background(.thinMaterial)
        }
        
        
        
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.book))
}
