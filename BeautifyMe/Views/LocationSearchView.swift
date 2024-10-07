//
//  LocationSearchView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @State private var previousQueryFragment = ""
    @Binding var appState: AppState
    @EnvironmentObject var viewModel: LocationSearchViewModel

    var body: some View {
        NavigationView{
            VStack{
                //Header
                HStack{
                    
                    VStack{
                        Circle()
                            .fill(Color(.red))
                            .frame(width: 6, height: 6)
                            
                        Rectangle()
                            .fill(AppColors.black)
                            .frame(width: 1, height: 24)
                        Rectangle()
                            .fill(AppColors.darkBlue)
                            .frame(width: 6, height: 6)
                    }
                    
                    VStack{
                        TextField("  Current location", text: $startLocationText)
                            .frame(height: 32)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(15)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20) // Match the corner radius with the fill
                                        .stroke(AppColors.black, lineWidth: 1) // Apply stroke as overlay
                                )
                            .padding(.bottom)
                            .disabled(true) //no editable
                        
                        TextField("  Where to?", text: $viewModel.queryFragment)
                            .frame(height: 32)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(15)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20) // Match the corner radius with the fill
                                        .stroke(AppColors.darkBlue, lineWidth: 1) // Apply stroke as overlay
                                )
                    }
                }
                .padding(.horizontal)
                .padding(.top,64)

                Divider()
                    .padding(.vertical)
                //list
                ScrollView{
                    VStack(alignment: .leading){
                        ForEach(viewModel.results, id: \.self){
                            result in
                            LocationCell(
                                title: result.title,
                                subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    viewModel.selectLocation(result)
                                    appState = .locationSelected
                                }
                            }//Object cell
                        }
                    }
                }
            }
            .background(Color.clear)
    }
}
}

//#Preview {
//    LocationSearchView(mapState: .constant(.searchingForLocation))
//}
