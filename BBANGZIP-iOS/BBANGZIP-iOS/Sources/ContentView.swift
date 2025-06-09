import SwiftUI

public struct ContentView: View {
    public init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(Color(.componentAlternative))
        appearance.shadowColor = UIColor(Color(.labelDisable))
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(.labelAssistive))
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    public var body: some View {
        
        return TabView {
            Text("빵 굽기")
                .tabItem {
                    Image(.icTimer)
                        .renderingMode(.template)
                    Text("빵굽기")
                }
            
            Text("할 일")
                .tabItem {
                    Image(.icBook)
                        .renderingMode(.template)
                    Text("할 일")
                }
            
            Text("이웃")
                .tabItem {
                    Image(.icChat)
                        .renderingMode(.template)
                    Text("이웃")
                }
            
            Text("마이")
                .tabItem {
                    Image(.icPerson)
                        .renderingMode(.template)
                    Text("마이")
                }
        }
        .accentColor(Color(.staticblack))
        .toolbarBackground(
            Color(.componentAlternative),
            for: .tabBar
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
