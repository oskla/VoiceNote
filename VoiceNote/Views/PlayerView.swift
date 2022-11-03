//
//  PlayerView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-11-03.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    @Binding var selectedRecording: UserDocumentRecording
    @Binding var recordingName: String
    
    var body: some View {
        
        ZStack {
            VStack {
                Button(action: {
                    
                    audioPlayer.startPlayback(audio: name)
            
                }) {
                    Image(systemName: "play.fill")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }.padding()
            }
            
        }.frame(maxWidth: .infinity).background(.blue)
        
        
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(selectedRecording: .constant( UserDocumentRecording(id: "234", name: "låt 1")))
    }
}
