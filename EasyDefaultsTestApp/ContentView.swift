//
//  ContentView.swift
//  EasyDefaultsTestApp
//
//  Created by Greg Ross on 11/08/2024.
//

import SwiftUI

struct ContentView: View {
    @State var counter = UserDefaults.standard.integer(forKey: "counter") + 1
    private let myStringKey = "my_string"
    private let myBoolKey = "my_bool"
    @State private var myString = UserDefaults.standard.string(forKey: "my_string") ?? ""
    @State private var myBool = UserDefaults.standard.bool(forKey: "my_bool").description
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Use this app bundle ID in the Easy Defaults app: com.test.EasyDefaultsTestApp\n\nAnd select the simulator that is running this test app.")
                    .font(.title2)
                    .fontWeight(.regular)
                    .padding(.vertical)
                    .frame(maxHeight: .infinity)
                
                Divider()
                
                VStack {
                    Text("myString: \(myString)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("myBool: \(myBool)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.title3)
                .padding(16)
                
                Divider()
                
                button("Save String") {
                    UserDefaults.standard.setValue("Easy Defaults Test Value", forKey: "\(counter)")
                    counter += 1
                }
                
                button("Save Int") {
                    UserDefaults.standard.setValue(Int.random(in: 0..<100), forKey: "\(counter)")
                    counter += 1
                }
                
                button("Save Bool") {
                    UserDefaults.standard.setValue(Bool.random(), forKey: "\(counter)")
                    counter += 1
                }
                
                button("Save Date") {
                    UserDefaults.standard.setValue(Date(), forKey: "\(counter)")
                    counter += 1
                }
                
                button("Save Data") {
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(CustomObject()) {
                        UserDefaults.standard.setValue(encoded, forKey: "\(counter)")
                        counter += 1
                    }
                }
                
                button("Set myString value") {
                    UserDefaults.standard.setValue("My test string", forKey: myStringKey)
                    reloadValues()
                }
                
                button("Set myBool value") {
                    UserDefaults.standard.setValue(true, forKey: myBoolKey)
                    reloadValues()
                }
                
                button("Reload") {
                    reloadValues()
                }
                
                button("Clear User Defaults", .pink) {
                    clearUserDefaults()
                }
            }
            .padding()
        }
    }
    
    func button(_ title : String, _ color : Color = .green, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .font(.title3)
                .fontWeight(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .clipShape(.rect(cornerRadius: 12))
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    func clearUserDefaults() {
        let defaults = UserDefaults.standard
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }
        defaults.synchronize()
        reloadValues()
    }
    
    func reloadValues() {
        let string = UserDefaults.standard.string(forKey: myStringKey)
        let bool = UserDefaults.standard.bool(forKey: myBoolKey).description
        withAnimation {
            myString = string ?? ""
            myBool = bool
        }
    }
}

struct ScaleButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
    }
}

private extension ContentView {
    struct CustomObject : Codable {
        var objectString : String = "objectStringValue"
        var objectInt : Int = 10
        var objectBool : Bool = Bool.random()
    }
}

#Preview {
    ContentView()
}
