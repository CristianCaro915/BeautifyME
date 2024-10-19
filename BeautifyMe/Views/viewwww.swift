//
//  viewwww.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//

import SwiftUI

struct URLImage: View{
    var body: some View{
        Image("")
    }
}

struct viewwww: View {
    @StateObject private var viewModel = ExampleVM()
    
    
    var body: some View {
        
        
        //Section 0: Trying fetch
        if viewModel.services.isEmpty{
            Text("EMPTY")
        } else{
            Text("NOT EMPTY")
            Text(viewModel.services[0].name)
        }
        Text("New section")
        
        HStack{
            List(viewModel.services) { service in
                VStack(alignment: .leading) {
                    Text(service.name).font(.headline)
                    Text(service.description).font(.subheadline)
                    Text("Price: \(service.price)").font(.caption)
                    
                    if let iconURL = URL(string: "http://localhost:1337"+service.icon) {
                        AsyncImage(url: iconURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    viewwww()
}
