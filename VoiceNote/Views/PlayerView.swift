import SwiftUI


struct PlayListView: View {
    
    @ObservedObject var audioPlayer: AudioPlayer
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var allRecordings: AllRecordings
    @Binding var selectedNote: Note
    @Binding var selectedRecording: UserDocumentRecording?
    @Binding var showPlayer: Bool
    @Binding var showPlayList: Bool
    // @State var selectedRecording: UserDocumentRecording?
    
    var body: some View {
        
        if let selectedNoteRecordings = allRecordings.getRecordingArrayById(id: "\(selectedNote.id)", db: firestoreConnection) {
            
          //  VStack {
            ZStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                
                Rectangle().frame(height: 1).foregroundColor(.black)
                ForEach(selectedNoteRecordings, id: \.self) { recording in
                    
                    PlayListRow(selectedRecording: recording)
                        .onTapGesture {
                            withAnimation {
                                showPlayList = false
                            }
                            
                        showPlayer = true
                            selectedRecording = recording
                        }
                        
                    
                    
                }
            }
                  //  .border(width: 1, edges: [.leading, .bottom, .trailing, .top], color: .black)
                    
            }//.frame(minHeight: 40, maxHeight: 140)
           // .border(width: 1, edges: [.leading, .bottom, .trailing, .top], color: .blue)
         //   }.frame(minHeight: 40, maxHeight: 320).border(width: 1, edges: [.leading, .bottom, .trailing, .top], color: .red)
            }.ignoresSafeArea()
                .background(.ultraThinMaterial)
        }
    }
}

struct PlayListRow: View {
    
    var selectedRecording: UserDocumentRecording?
    
    var body: some View {
        
        ZStack {
            HStack {
                
                Spacer()
                
                HStack {
                    ScrollView(.horizontal) {
                        Text(selectedRecording?.nickname ?? "nil")
                            .lineLimit(1)
                            .padding()
                    }
                    Spacer()
                }
            }
        }.frame(maxWidth: .infinity).background(.ultraThinMaterial)
            .border(width: 1, edges: [.leading, .bottom, .trailing], color: .black)
        
    }
}


struct PlayerView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    @Binding var selectedRecording: UserDocumentRecording?
    
    
    var body: some View {
        
        ZStack {
            HStack {
                
                VStack {
                    if audioPlayer.isPlaying == false {
                        Button(action: {
                            
                            if let url = URL(string: selectedRecording?.name ?? "") {
                                audioPlayer.startPlayback(audio: url)
                                print("url is: \(url)")
                            }
                            
                        }) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        }
                    } else {
                        
                        Button(action: {
                            self.audioPlayer.stopPlayback()
                            print("Stop playing audio")
                        }) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        }
                    }
                }.frame(width: 40, height: 40)
                    .padding()
                Spacer()
                
                HStack {
                    ScrollView(.horizontal) {
                        Text(selectedRecording?.nickname ?? "nil")
                            .lineLimit(1)
                            .padding()
                    }
                    Spacer()
                }
            }
        }.frame(maxWidth: .infinity).background(.white)
            .border(Color.black, width: 1)
        
        
    }
}



struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        //        PlayerView(audioPlayer: AudioPlayer(), selectedRecording: .constant( UserDocumentRecording(id: "234", name: "Gitarrlåt nummer 1 (ny refräng)")))
        
        PlayListView(audioPlayer: AudioPlayer(), selectedNote: .constant(Note(noteTitle: "hej", noteContent: "Hej")), selectedRecording: .constant(UserDocumentRecording()), showPlayer: .constant(true), showPlayList: .constant(false)).environmentObject(FirestoreConnection())
        
       // PlayListRow(selectedRecording: .constant(UserDocumentRecording()))
    }
}
