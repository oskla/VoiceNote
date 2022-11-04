import SwiftUI

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
                }//.padding()
                } else {
                    
                        Button(action: {
                            self.audioPlayer.stopPlayback()
                            print("Stop playing audio")
                        }) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        }//.padding()
                }
            }.frame(width: 40, height: 40)
            .padding()
                Spacer()
                
                HStack {
                    ScrollView(.horizontal) {
                    Text(selectedRecording?.name ?? "No name") // TODO: What should recording be called?
                        .lineLimit(1)
                        .padding()
                    }
                    Spacer()
                }
            }
        }.frame(maxWidth: .infinity).background(.ultraThinMaterial)
            .border(Color.black, width: 1)


    }
}


struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(audioPlayer: AudioPlayer(), selectedRecording: .constant( UserDocumentRecording(id: "234", name: "Gitarrlåt nummer 1 (ny refräng)")))
    }
}
