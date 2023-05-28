import SwiftUI
import UI
import Services
import Core

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
//            BaseButton(
//                isEnabled: false,
//                kind: .primary,
//                text: Text("Tap on me"),
//                accessory: .none,
//                onPress: {  }
//            )
//            BaseButton(
//                isEnabled: true,
//                kind: .primary,
//                text: Text("Tap on me"),
//                accessory: .loader(.rightTitleEdge),
//                onPress: {  }
//            )
            VStack {
            }
            .overlay( RoundedRectangle(cornerRadius: 16)
                .stroke(Color.red, lineWidth: 1)
        )
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
