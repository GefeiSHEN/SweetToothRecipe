//
//  ContentView.swift
//  SweetToothRecipe
//
//  Created by Gefei Shen on 3/8/23.
//

import SwiftUI

struct MealListView: View {
    @StateObject var viewModel = MealListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.desserts.count < 1 {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.desserts) { dessert in
                            
                            NavigationLink {
                                MealDetailView(mealId: dessert.id)
                            } label: {
                                AsyncImage(url: dessert.thumb) { image in
                                    image.resizable()
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .imageScale(.large)
                                        .foregroundColor(.gray)
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(width:40, height: 40)
                                .clipped()
                                Text(dessert.name)
                            }

                        }
                    }
                    .refreshable {
                        viewModel.getDesserts()
                        print("User Triggered Refresh")
                    }
                }
            }
            .navigationTitle("Desserts")
            .onAppear {
                viewModel.getDesserts()
            }
            .alert("Fetching Failed", isPresented: $viewModel.isError) {
                Button("Dismiss") {
                    print("User Dismissed Alert")
                    viewModel.isError = false
                }
                Button("Retry") {
                    viewModel.getDesserts()
                    print("User Dismissed Alert with Refresh")
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "An Error Occured")
            }
        }
    }
}

class MealListViewModel: ObservableObject {
    ///list of desserts sorted alphabetically
    @Published var desserts = [MealInfo]()
    ///wheather a network request is in progress
    @Published var isLoading = false
    ///the error thrown, if any
    @Published var error: Error?
    ///wheather encountered an error
    @Published var isError = false
    var api: APIService
    
    init(api: APIService = APIService()) {
        self.api = api
    }
    
    func getDesserts() {
        withAnimation {
            self.isLoading = true
        }
        Task {
            do {
                let desserts = try await self.api.getDessert()
                let sortedDesserts = desserts.sorted(by: { $0.name < $1.name }) 
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.desserts = sortedDesserts
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    withAnimation {
                        self.error = error
                        self.isError = true
                    }
                }
            }
            DispatchQueue.main.async {
                withAnimation {
                    self.isLoading = false
                }
            }
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
