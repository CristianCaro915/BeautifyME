//
//  BusinessDetailedView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 8/10/24.
//

import SwiftUI

struct BusinessDetailedView: View {  
    
    let textImages6: [String:String] =
    ["pedro_profile":"Pedro","mariana_profile":"Mariana G.","maria_jose_profile":"Maria Jose","mariana_paz":"Mariana Paz","tomas_montaña":"Tomas M."]
    let haircuts = ["peinados1", "peinados2", "peinados3","peinados4"]
    let reviews: [Review] = [
        Review(name: "Tomas Whang", image: "tomas_montaña", rating: 4, timeAgo: "2 days ago", comment: "The place was clean, great serivce, staff are friendly. I will certainly recommend to my friends and visit again! :)"),
        Review(name: "Nathalie", image: "nathalie_profile", rating: 4, timeAgo: "1 weeks ago", comment: "Very nice service from the specialist. I always going here for my treatment.."),
        Review(name: "Julia Martha", image: "woman_profile", rating: 4, timeAgo: "2 weeks ago", comment: "This is my favourite place to treat my hair :)")
    ]
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header Image
                ZStack(alignment: .topLeading) {
                    Image("salon_belleza1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Beauty Salon")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("122 Riverside Rd. Eacho City, NY 34856")
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(AppColors.darkBlue)
                        Text("Open Today")
                            .padding(6)
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(AppColors.darkBlue)
                            .cornerRadius(4)
                        
                        Text("-58% (6 pax available)")
                            .foregroundColor(AppColors.darkBlue)
                            .padding(.horizontal,20)
                    }
                    
                    HStack {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(AppColors.orange)
                            Text("4.7 (2.7k)")
                        }
                        Spacer()
                        HStack {
                            HStack{
                                Image(systemName: "eye")
                                    .foregroundColor(AppColors.mediumGrey)
                                Text("10k views")
                            }
                            .padding(.horizontal,50)
                            
                            Spacer()
                                
                        }
                    }
                    
                    Group {
                        Text("About")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(8)
                        Text("Living up to our name Plush Beauty Lounge, the team is highly energetic and creative. We believe that if it matters to you, it matters to us.\n\nKeeping up to speed with the market's latest trends, Plush Beauty Lounge recognizes the need for constant improvements. Our team receives regular training from hairdressers all...")
                        
                        Button("Read more") {
                            // Action
                        }
                        .foregroundColor(.blue)
                    }
                    Text("Opening Hours")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                    HStack{
                        Circle()
                            .fill(Color(AppColors.darkBlue))
                            .frame(width: 8, height: 8)
                        VStack{
                            Text("Monday - Friday")
                                .fontWeight(.semibold)
                            Text("08:00am - 03:00pm")
                        }
                        Circle()
                            .fill(Color(AppColors.darkBlue))
                            .frame(width: 8, height: 8)
                        VStack{
                            Text("Saturday - Sunday")
                                .fontWeight(.semibold)
                            Text("09:00am - 02:00pm")
                        }
                    }
                    Text("Our Services")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                    ScrollView {
                        VStack(spacing: 16) {
                            ServiceCardView(imageName: "peinados1", title: "Woman Blunt Cut", price: "$50", duration: "2 hours", discount: "-20%", description: "A blunt cut bob is a shorter hairstyle.", iconButton: "plus.circle")
                            
                            ServiceCardView(imageName: "peinados2", title: "Bob/ Lob Cut", price: "$55", duration: "1.5 hours", discount: "-20%", description: "Lob haircut is a women's hairstyle.", iconButton: "plus.circle")
                            
                            
                        }
                        .padding(.horizontal)
                    }
                    Button(action: {
                        // Acción para "Book Now"
                    }) {
                        Text("View All Services")
                            .font(.headline)
                            .foregroundColor(AppColors.darkBlue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.white)
                            .overlay(Rectangle().stroke(AppColors.darkBlue, lineWidth: 2))
                            .cornerRadius(10)
                            
                    }
                    .padding(.horizontal)
                    
                    // Gallery
                    Text("Gallery")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // featured businesses
                            ForEach(haircuts, id: \.self) { image in
                                IconRectangleView(image: image)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Specialist
                    Text("Our Specialists")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // professionals
                            ForEach(Array(textImages6.keys), id: \.self) { key in
                                if let value = textImages6[key] {
                                    IconTextView(image: key, title: value)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Reviews
                    HStack {
                        Text("Reviews")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Button("View all") {
                            // Action for view all
                        }
                        .foregroundColor(AppColors.darkBlue)
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        
                        ForEach(reviews) { review in
                            ReviewCard(review: review)
                            if review.id != reviews.last?.id {
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    BusinessDetailedView()
}
