//
//  ContentView.swift
//  okashi
//
//  Created by masaya ishigami on 2021/09/25.
//

import SwiftUI

struct ContentView: View {
    //お菓子データを参照する状態変数
    @ObservedObject var okashiDataList = OkashiData()
    @State var inputText = ""//入力した文字列を保持する状態変数
    
    var body: some View {
        VStack{
            TextField("キーワードを入力してください",text: $inputText,onCommit:{
                okashiDataList.searchOkashi(keyword: inputText)//入力直後に検索する
            
            })
            .padding()
            List(okashiDataList.okashiList){ okashi in
                
                HStack{
                    Image(uiImage: okashi.image)
                    
                    
                    //
                    Text(okashi.name)
                    
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
