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
    private let myDictKey = "my_dict"
    @State private var myString = UserDefaults.standard.string(forKey: "my_string") ?? ""
    @State private var myBool = UserDefaults.standard.bool(forKey: "my_bool").description
    @State private var myDict : [String : Any]?
    
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
                    Text("myDict: \(myDict)")
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
                
                button("Set myDict value") {
                    saveDictionaryToUserDefaults(myDictKey)
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
        .onAppear {
            self.myDict = retrieveDictionaryFromUserDefaults(myDictKey)
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
        let dict = retrieveDictionaryFromUserDefaults(myDictKey)
        withAnimation {
            myString = string ?? ""
            myBool = bool
            myDict = dict
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

// MARK: Save/Retrieve Dictionary
private extension ContentView {
    func saveDictionaryToUserDefaults(_ key: String) {
        let sampleDictionary: [String: Any] = [
            "username": "john_doe",
            "age": 30,
            "isLoggedIn": true,
            "lastLoginDate": Date(),
            "settings": ["volume": 80, "notificationsEnabled": true]
        ]
        
        // Convert the dictionary to Data using PropertyListSerialization
        if let data = try? PropertyListSerialization.data(fromPropertyList: sampleDictionary, format: .binary, options: 0) {
            UserDefaults.standard.set(data, forKey: key)
            print("Dictionary saved to UserDefaults")
        } else {
            print("Failed to serialize dictionary")
        }
    }

    func retrieveDictionaryFromUserDefaults(_ key: String) -> [String: Any]? {
        let userDefaults = UserDefaults.standard
        
        // Retrieve the Data from UserDefaults
        if let data = userDefaults.data(forKey: key) {
            // Convert the Data back to a dictionary using PropertyListSerialization
            if let dictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
                return dictionary
            } else {
                print("Failed to deserialize dictionary")
            }
        } else {
            print("No data found for key: \(key)")
        }
        
        return nil
    }
}

#Preview {
    ContentView()
}
