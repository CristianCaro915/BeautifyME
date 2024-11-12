//
//  BusinessSelectedCard.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 8/10/24.
//

import SwiftUI

struct BusinessSelectedCard: View {
    @Binding var appState: AppState
    
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(AppColors.mediumGrey)
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            //trip info
            HStack{
                Button(action: {
                    // Acción a realizar cuando se hace clic en la imagen
                    withAnimation(.spring()){
                        actionState(appState)
                    }
                }) {
                    Image("salon_belleza1") // Reemplaza con el nombre de tu imagen
                        .resizable()
                        .scaledToFit() // Ajusta la imagen al espacio disponible
                        .frame(width: 150, height: 150) // Cambia el tamaño según sea necesario
                        .cornerRadius(10) // Opcional: redondear esquinas
                        .shadow(radius: 5) // Opcional: agregar sombra
                }
                .buttonStyle(PlainButtonStyle())
                
                
                VStack{
                    VStack{
                        Text("Beauty Salon")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("122 Riverside Rd. Eacho City, NY 34856")
                            .foregroundColor(AppColors.mediumGrey)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppColors.orange)
                        Text("4.7 (2.7k)")
                        
                        Spacer()
                        
                        Image(systemName: "lock")
                            .foregroundColor(AppColors.orange)
                        Text("40%")
                            .font(.caption)
                            .foregroundColor(AppColors.orange)
                    }
                }
            }
            .padding()
            
            
        }
        .padding(.bottom)
        .background(AppColors.white)
        .cornerRadius(18)
    }
    func actionState(_ state: AppState){
        if state == .polylineaddded{
            appState = .businessDetailed
        }
    }
}


#Preview {
    BusinessSelectedCard(appState: .constant(.polylineaddded))
}

