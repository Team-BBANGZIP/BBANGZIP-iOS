import SwiftUI

public struct ContentView: View {
    public init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(.labelAssistive))
    }

    public var body: some View {
        TabView {
            Text("빵굽기")
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
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
