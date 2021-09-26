//
//  SFSafariViewCOntroller.swift
//  okashi
//
//  Created by masaya ishigami on 2021/09/26.
//

import SwiftUI
import SafariServices

struct SadariView: UIViewControllerReprssentable {
    
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController{
        //Safariを起動する
        return SFSafariViewController(url: url)
        
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, Context: Context){
        
    }
    
}

