//
//  callAPI.swift
//  InstagramDownload
//
//  Created by Vo Thanh Sang on 16/04/2021.
//

import SwiftUI
import FBSDKCoreKit
import SwiftyJSON
import Alamofire
import Combine
import PhotosUI

class APIGraph: NSObject, ObservableObject {
    // Aler...
    @Published var alertMsg = ""
    @Published var showAlert = false
    @Published var author_name = ""
    @Published var linkVideo = ""
    @Published var dataTask : URLSessionDataTask?
    @Published var downloadProgress : CGFloat = 0
    @Published var image : Data = .init(count: 0)
    @Published var observation : NSKeyValueObservation?
    @Published var showDownloadProgess = false
    
    var managedObjectContext = PersistenceController.shared.container.viewContext

    func fetchData(_ url: String) {
        
        let connection = GraphRequestConnection()
        
        let access_token = "317899746424100|W4PKDI7RUIkGkcxcyuVGCFihdJc"
        
        let params : [String: Any] = ["fields":"author_name, thumbnail_url, thumbnail_width, thumbnail_height", "url": url, "access_token" : access_token]
        
        let request = GraphRequest(graphPath: "/instagram_oembed", parameters: params, tokenString: AccessToken.current?.tokenString, version: .none, httpMethod: .get)
        
        connection.add(request) { (connection, result, error) in
            
            if error != nil {
                
                print("error \(error!)")
                self.reportError(error: "\(error!)")
                
            } else {
                print("Fetch success")

                let json = JSON(result!)
                
                let thumbnail_url = json["thumbnail_url"].string!
                                
                self.author_name = json["author_name"].string!

                DispatchQueue.main.async {
                    self.startDownload(urlString: thumbnail_url)
                    
                }
                print(json["thumbnail_url"])
                
            }
            
        }
        connection.start()
        
    }

    
    func startDownloadVideo(urlString: String) {
                
        guard let baseURL = URL(string: "http://localhost:3001/api/download") else {
            self.reportError(error: "URL null")
            return
        }
                
        let body = ["url" : urlString]
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        var request = URLRequest(url: baseURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
                print(error.localizedDescription)
            } else if let data = data {
                // Handle HTTP request response
                let json = JSON(data)
                self.linkVideo = json["downloadLink"].string!
                
            } else {
                // Handle unexpected error
            }
        }
        task.resume()

    }
    
    func startDownload(urlString: String) {
        
        // check for valid URL
        guard let ValidURL = URL(string: urlString) else {
            self.reportError(error: "URL null")
            return
            
        }
        
        self.showDownloadProgess = true
        
        dataTask = URLSession.shared.dataTask(with: ValidURL) { (Data, URLResponse, Error) in
            
            self.observation?.invalidate()
            
            guard let data = Data else { return }
            
            DispatchQueue.main.async {
                self.image = data
                print(self.image)
            }
        }
        
        observation = dataTask?.progress.observe(\.fractionCompleted) { (observationProgress, _) in
            
            DispatchQueue.main.async {
                self.downloadProgress = CGFloat(observationProgress.fractionCompleted)
                
                print(self.downloadProgress)
                
                if self.downloadProgress == 1 {
                    self.showDownloadProgess = false
                }
            }
        }
        dataTask?.resume()

    }
        
    func saveImage(_ image: Data) {
        
        let inputImage = UIImage(data: image)
        writeToPhotoAlbum(image: inputImage!)
        
        let newItem = Insta(context: managedObjectContext)
        newItem.user = self.author_name
        newItem.img = image
        newItem.uid = UUID().uuidString
        PersistenceController.shared.save()
    }

    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        
    }
    
    func saveVideoToAlbum(urlVideo: String ) {
        
        DispatchQueue.global(qos: .background).async {
            
          if let url = URL(string: urlVideo), let urlData = NSData(contentsOf: url) {
             let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
             let filePath="\(galleryPath)/nameX.mp4"
              
              DispatchQueue.main.async {
                urlData.write(toFile: filePath, atomically: true)
                   PHPhotoLibrary.shared().performChanges({
                   PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:
                   URL(fileURLWithPath: filePath))
                }) {
                   success, error in
                   if success {
                       DispatchQueue.main.async {
                           self.reportSucces(success: "Succesfully Saved")
                       }
                   } else {
                       self.reportError(error: error!.localizedDescription)
                   }
                }
             }
          }
       }
    }
    

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        reportSucces(success: "Save finished!")
    }
    

    func reportError(error: String) {
        self.alertMsg = error
        self.showAlert.toggle()
    }
    
    func reportSucces(success: String) {
        self.alertMsg = success
        self.showAlert.toggle()
    }

}



