//
//  OptionsButton.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct OptionsButton: View {
    @Binding var appState: AppState
    @EnvironmentObject var viewModel: LocationSearchViewModel

    var body: some View {
        Button{
            withAnimation(.spring()){
                actionForState(appState)
            }
        } label: {
            Image(systemName: imageNameForState(appState))
                .font(.title2)
                .foregroundColor(AppColors.darkBlue)
                .padding()
                .background(.white)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
    }
    func actionForState(_ state: AppState){
        switch state{
        case .noInput:
            break
        case .searchingForLocation:
            appState = .noInput
        case .locationSelected, .polylineaddded, .categorySelected:
            //solve bug of keeping a past location
            appState = .noInput
            viewModel.selectedLocation = nil
        case .businessDetailed,.booking,.payment, .commentList, .serviceList:
            break
        }
    }
    func imageNameForState(_ state: AppState)-> String{
        switch state{
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected, .polylineaddded, .categorySelected, .businessDetailed, .booking, .payment, .commentList, .serviceList:
            return "arrow.left"
        }
    }
}

#Preview {
    OptionsButton(appState: .constant(.noInput))
}
