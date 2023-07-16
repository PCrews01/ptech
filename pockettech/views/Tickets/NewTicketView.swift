//
//  NewTicketView.swift
//  pockettech
//
//  Created by Paul Crews on 6/11/23.
//

import SwiftUI
import AVKit

struct NewTicketView: View {
    @State var new_ticket : Ticket
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @Binding var permission_granted : Bool
    @State var show_photo_option = false
    
    var body: some View {
        VStack{
            Text(new_ticket.TicketTitle == "" ? "New Ticket" : new_ticket.TicketTitle)
                .fontWeight(.heavy)
            TextField("Title", text: $new_ticket.TicketTitle)
                .padding()
                .background(.ultraThinMaterial)
            TextField("User Email", text: $new_ticket.EndUserEmail)
                .padding()
                .background(.ultraThinMaterial)
            //                        50 characters
            TextField("Issue", text: $new_ticket.FirstComment, axis: .vertical)
                .lineLimit(10)
                .multilineTextAlignment(.leading)
                .padding()
                .background(.ultraThinMaterial)
            HStack{
                Picker("Priority", selection: $new_ticket.TicketPriority) {
                    Text("Priority")
                        .tag("")
                    Text("Low")
                        .tag("Low")
                    Text("Medium")
                        .tag("Medium")
                    Text("High")
                        .tag("High")
                    Text("Critical")
                        .tag("Critical")
                }
                Spacer()
                Picker("Impact", selection: $new_ticket.TicketPriority){
                    Text("Impact")
                        .tag("")
                    Text("No Impact")
                        .tag("No Impact")
                    Text("Minor")
                        .tag("Minor")
                    Text("Major")
                        .tag("Major")
                    Text("Crisis")
                        .tag("Crisis")
                }
            }
            Button {
                withAnimation(.easeInOut(duration: 0.8)){
                    show_photo_option.toggle()
                }
            } label: {
                Text("Add Photo")
            }.frame(width: 200, height: 20)
            if show_photo_option{
                VStack{
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    }
                    LazyVGrid(columns: gridColumns(columns: 2)){
                        Button {
                            self.sourceType = .camera
                            self.isImagePickerDisplay.toggle()
                        } label: {
                            Image(systemName: "camera")
                                .resizable()
                                .padding(20)
                                .aspectRatio(contentMode: .fit)
                        }
                        .padding()
                        .frame(width: 200, height: 200, alignment: .center)
                        .background(Color("AccentColor"))
                        .cornerRadius(12)
                        
                        Button {
                            sourceType = .photoLibrary
                            isImagePickerDisplay = true
                        } label: {
                            Image(systemName: "photo.stack")
                                .resizable()
                                .padding(20)
                                .aspectRatio(contentMode: .fit)
                        }
                        .padding()
                        .frame(width: 200, height: 200, alignment: .center)
                        .background(Color("AccentColor"))
                        .cornerRadius(12)
                    }
                    .foregroundColor(.white)
                }
            }
            Spacer()
            if new_ticket.TicketTitle != "" && new_ticket.EndUserEmail.count > 5 && new_ticket.EndUserEmail.contains("@") && new_ticket.FirstComment.count > 10{
                Button {
                    print("New ticket \(new_ticket)")
                } label: {
                    Text("Open Ticket")
                }
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 30)
                .padding()
                .background(Color("light_green"))
                .cornerRadius(12)
                .transition(.opacity)
                
            }
        }
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
    }
    struct ImagePickerView: UIViewControllerRepresentable {
        
        @Binding var selectedImage: UIImage?
        @Environment(\.presentationMode) var isPresented
        var sourceType: UIImagePickerController.SourceType
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = self.sourceType
            imagePicker.delegate = context.coordinator // confirming the delegate
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
            
        }
        
        // Connecting the Coordinator class with this struct
        func makeCoordinator() -> Coordinator {
            return Coordinator(picker: self)
        }
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: ImagePickerView
        
        init(picker: ImagePickerView) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.picker.selectedImage = selectedImage
            self.picker.isPresented.wrappedValue.dismiss()
        }
        
    }
    
    func getCameraAccess(){
        AVCaptureDevice.requestAccess(for: .video) { access_granted in
            DispatchQueue.main.async {
                self.permission_granted = access_granted
            }
        }
    }
}


//struct NewTicketView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTicketView()
//    }
//}
