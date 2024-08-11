//
//  ContentView.swift
//  EasyDefaultsTestApp
//
//  Created by Greg Ross on 11/08/2024.
//

import SwiftUI

struct ContentView: View {
    @State var counter = UserDefaults.standard.integer(forKey: "counter") + 1
    var body: some View {
        VStack {
            Text("Use this app bundle ID in the Easy Defaults app: com.test.EasyDefaultsTestApp\n\nAnd select the simulator that is running this test app.")
                .font(.title2)
                .fontWeight(.regular)
                .padding(.vertical)
                .frame(maxHeight: .infinity)
            Button {
                UserDefaults.standard.setValue("Easy Defaults Test Value", forKey: "\(counter)")
                counter += 1
            } label: {
                Text("Save to User Defaults")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .buttonStyle(ScaleButtonStyle())
            
            Button {
                clearUserDefaults()
            } label: {
                Text("Clear User Defaults")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding()
    }
    
    func clearUserDefaults() {
        let defaults = UserDefaults.standard
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
            defaults.synchronize()
        }
    }
}

struct ScaleButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
    }
}

#Preview {
    ContentView()
}
