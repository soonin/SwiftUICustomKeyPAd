//
//  CustomKeyPad.swift
//  SwiftUICustomKeyPAd
//
//  Created by Amir Hatami on 2022-06-12.
//

import SwiftUI


struct CustomKeyPad : View {
    @Binding var string : String
    @Binding var show : Bool
    let maxDigits : Int
    var keyPadtype : KeyPadType = .int
    let updateCallback : ()->()
    let updateMessage : ()->()
    
    var body: some View {
        VStack(spacing: 9){
            
            VStack(spacing: 7){
                KeyPadRow(keys: KeyPadConstants.keyPadRow1)
                KeyPadRow(keys: KeyPadConstants.keyPadRow2)
                KeyPadRow(keys: KeyPadConstants.keyPadRow3)
                switch keyPadtype {
                case .minus:
                    KeyPadRow(keys: KeyPadConstants.keyPadRow4Minus)
                case .float:
                    KeyPadRow(keys: KeyPadConstants.keyPadRow4Float)
                default:
                    KeyPadRow(keys: KeyPadConstants.keyPadRow4)
                }
            }.frame(width: KeyPadConstants.keyPadWidth, height: KeyPadConstants.keyPadHeight, alignment: .center)
                .background(Color.white).cornerRadius(5)
            
            HStack{
                Button {
                    updateCallback()
                } label: {
                    Text("DONE")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .frame(width: KeyPadConstants.keyPadDoneWidth, height: KeyPadConstants.keyPadDoneHeight, alignment: .center)
                }
                .background(Color.white).cornerRadius(5)
                .accessibilityIdentifier("KeyPadDone")
            }.frame(width: KeyPadConstants.keyPadDoneWidth + 10 , height: KeyPadConstants.keyPadDoneHeight + 10, alignment: .center)
                .background(Color.white).cornerRadius(5)
            
        }
        .environment(\.keyPadButtonAction, self.keyWasPressed(_:))
    }
    
    private func keyWasPressed(_ key: String) {
        if ( string.trimmingCharacters(in: .whitespacesAndNewlines).count > maxDigits-1 && key != "⌫" ) {
            print("passed max digits \(string.count) ")
            return
        }
        switch key {
        case "." where string.contains("."): break
        case "." where string == "0": string += key
        case "-" where string.contains("-"): string.removeFirst()
        case "-" where !string.contains("-"): string = "-"+string
        case "⌫":
            if string.isEmpty { string = "0" } else {
                string.removeLast()
            }
            if string.isEmpty { string = "0" }
        case _ where string == "0": string = key
        default: string += key
        }
        show = true
        updateMessage()
    }
    
}



enum KeyPadType {
    case int
    case float
    case minus
}

struct KeyPadKey :Hashable {
    let role : String
    let text: String
    let subText : String
}




struct KeyPadRow : View {
    var keys : [KeyPadKey]
    
    var body: some View {
        HStack{
            ForEach(keys, id: \.self) { item in
                KeyPadButton(key: item.text, subKey: item.subText)
            }
        }
    }
}


struct KeyPadButton : View {
    var key : String
    var subKey : String
    
    var body: some View {
        Button {
            self.action(self.key)
        } label : {
            VStack(spacing: 0){
                Text(key)
                    .font(key == "⌫" ? .system(size: 28) : .system(size: 25) )
                    .foregroundColor(.black)
                if subKey != "-1" && subKey != "-2" {
                    Text(subKey)
                        .font(.system(size: 10))
                        .foregroundColor(.blue)
                }
            }.frame(width: KeyPadConstants.keyPadButtonWidth, height: KeyPadConstants.keyPadButtonHeight, alignment: .center)
                .accessibilityIdentifier("keyPadButton\(self.key)")
                .background(RoundedRectangle(cornerRadius: 5)
                                .fill(subKey != "-1" ? Color.white : Color.clear )
                                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 0)
                                .mask(Rectangle().padding(.bottom, -1))
                )
        }
    }
    
    enum ActionKey: EnvironmentKey {
        static var defaultValue: (String)-> Void{{ _ in}}
    }
    
    @Environment(\.keyPadButtonAction) var action : (String)-> Void
}


extension EnvironmentValues {
    var keyPadButtonAction : (String) -> Void {
        get {
            self[KeyPadButton.ActionKey.self]
        }
        set {
            self[KeyPadButton.ActionKey.self] = newValue
        }
    }
}



struct KeyPadConstants {
    static let keyPadRow1 : [KeyPadKey] = [
        KeyPadKey(role: "add", text: "1", subText: ""),
        KeyPadKey(role: "add", text: "2", subText: "ABC"),
        KeyPadKey(role: "add", text: "3", subText: "SEF"),
    ]
    static let keyPadRow2 : [KeyPadKey] = [
        KeyPadKey(role: "add", text: "4", subText: "GHI"),
        KeyPadKey(role: "add", text: "5", subText: "JKL"),
        KeyPadKey(role: "add", text: "6", subText: "MNO"),
    ]
    static let keyPadRow3 : [KeyPadKey] = [
        KeyPadKey(role: "add", text: "7", subText: "PQRS"),
        KeyPadKey(role: "add", text: "8", subText: "TUV"),
        KeyPadKey(role: "add", text: "9", subText: "WXYZ"),
    ]
    static let keyPadRow4 : [KeyPadKey] = [
        KeyPadKey(role: "", text: "", subText: "-1"),
        KeyPadKey(role: "add", text: "0", subText: "-2"),
        KeyPadKey(role: "del", text: "⌫", subText: "-1"),
    ]

    
    static let keyPadRow4Float : [KeyPadKey] = [
        KeyPadKey(role: "", text: ".", subText: ""),
        KeyPadKey(role: "add", text: "0", subText: "-2"),
        KeyPadKey(role: "del", text: "⌫", subText: "-1"),
    ]
    
    static let keyPadRow4Minus : [KeyPadKey] = [
        KeyPadKey(role: "", text: "-", subText: ""),
        KeyPadKey(role: "add", text: "0", subText: "-2"),
        KeyPadKey(role: "del", text: "⌫", subText: "-1"),
    ]
    
    
    static let keyPadWidth = 321.0
    static let keyPadHeight = 234.0
    static let keyPadDoneWidth = 284.0
    static let keyPadDoneHeight = 38.0
    static let keyPadButtonWidth = 99.0
    static let keyPadButtonHeight = 46.0
    static let KeyPadHeightWithDoneButton = keyPadHeight + keyPadDoneHeight + 20
    
}
