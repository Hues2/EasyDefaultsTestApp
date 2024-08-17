//
//  ContentView.swift
//  EasyDefaultsTestApp
//
//  Created by Greg Ross on 11/08/2024.
//

import SwiftUI

struct ContentView: View {
    private let myBoolKey = "my_bool"
    private let myIntKey = "my_int"
    private let myStringKey = "my_string"
    private let myDateKey = "my_date"
    private let myDataKey = "my_data"
    private let myDictKey = "my_dict"
    @State private var myInt : Int?
    @State private var myBool : Bool?
    @State private var myString : String?
    @State private var myDate : Date?
    @State private var myData : [String : Any] = [:]
    @State private var myDict : [String : Any]?
    private let numberOfTestStrings : Int = 100
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Use this app bundle ID in the Easy Defaults app: com.test.EasyDefaultsTestApp\n\nAnd select the simulator that is running this test app.")
                    .font(.title2)
                    .fontWeight(.regular)
                    .padding(.vertical)
                    .frame(maxHeight: .infinity)
                
                Divider()
                
                VStack(spacing: 16) {
                    if let myBool {
                        Text("myBool: \(myBool.description)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if let myInt {
                        Text("myInt: \(myInt)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if let myString {
                        Text("myString: \(myString)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if let myDate {
                        Text("myDate: \(myDate.description)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Text("myData: \(myData)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let myDict {
                        Text("myDict: \(String(describing: myDict))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .font(.title3)
                .padding(16)
                
                Divider()
                    .padding(.vertical)
                
                button("Reload") {
                    reloadValues()
                }
                
                button("Set myBool") {
                    UserDefaults.standard.setValue(true, forKey: myBoolKey)
                    reloadValues()
                }
                
                button("Save myInt") {
                    UserDefaults.standard.setValue(Int.random(in: 0..<100), forKey: myIntKey)
                }
                
                button("Set myString") {
                    UserDefaults.standard.setValue("My test string", forKey: myStringKey)
                    reloadValues()
                }
                
                button("Save myDate") {
                    UserDefaults.standard.setValue(Date(), forKey: myDateKey)
                }
                
                button("Save myData") {
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(CustomObject()) {
                        UserDefaults.standard.setValue(encoded, forKey: myDataKey)
                    }
                }
                
                button("Set myDict") {
                    saveDictionaryToUserDefaults(myDictKey)
                    reloadValues()
                }
                
                button("Save \(numberOfTestStrings) Strings") {
                    for counter in 0..<numberOfTestStrings {
                        UserDefaults.standard.setValue("Easy Defaults Test Value - \(counter)", forKey: "\(counter)")
                    }
                }
                
                button("Clear User Defaults", .pink) {
                    clearUserDefaults()
                }
            }
            .padding()
        }
        .onAppear {
            self.myBool = UserDefaults.standard.bool(forKey: myBoolKey)
            self.myInt = UserDefaults.standard.integer(forKey: myIntKey)
            self.myString = UserDefaults.standard.string(forKey: myStringKey) ?? ""
            self.myDate = UserDefaults.standard.value(forKey: myDateKey) as? Date
            if let data = UserDefaults.standard.data(forKey: myDataKey) {
                self.myData = Utils.decodeDataToDictionary(data)
            }
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
        let userDefaults = UserDefaults.standard
        let bool = userDefaults.bool(forKey: myBoolKey)
        let int = userDefaults.integer(forKey: myIntKey)
        let string = userDefaults.string(forKey: myStringKey)
        let date = userDefaults.value(forKey: myDateKey) as? Date
        let data = userDefaults.data(forKey: myDataKey)
        let dict = retrieveDictionaryFromUserDefaults(myDictKey)
        withAnimation {
            myBool = bool
            myInt = int
            myString = string ?? ""
            myDict = dict
            myDate = date
            if let data {
                myData = Utils.decodeDataToDictionary(data)
            }
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
        var myString : String = "my test string value"
        var myInt : Int = 10
        var myBool : Bool = Bool.random()
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
