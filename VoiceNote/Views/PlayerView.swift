import SwiftUI

struct PlayerView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    @Binding var selectedRecording: UserDocumentRecording?


    var body: some View {

        ZStack {
            VStack {
                if audioPlayer.isPlaying == false {
                Button(action: {
                    
                        if let url = URL(string: selectedRecording?.name ?? "") {
                            audioPlayer.startPlayback(audio: url)
                            print("url is: \(url)")
                        }

                }) {
                    Image(systemName: "play.fill")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }.padding()
                } else {
                    
                        Button(action: {
                            self.audioPlayer.stopPlayback()
                            print("Stop playing audio")
                        }) {
                            Image(systemName: "stop.fill")
                                .imageScale(.large)
                                .foregroundColor(.black)
                        }.padding()
                }
            }

        }.frame(maxWidth: .infinity).background(.blue)


    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(audioPlayer: AudioPlayer(), selectedRecording: .constant( UserDocumentRecording(id: "234", name: "låt 1")))
    }
}
