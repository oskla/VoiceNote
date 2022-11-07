//
//  PickerView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-11-07.
//

import SwiftUI

struct PickerView: View {
    @Binding var notesOrRecordings: String
    var body: some View {
       
        VStack {
            Picker("What view", selection: $notesOrRecordings) {
                Text("Notes").tag("notes")
                Text("Recordings").tag("recordings")
            }.pickerStyle(.segmented)
        }
        
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(notesOrRecordings: .constant("notes"))
    }
}
