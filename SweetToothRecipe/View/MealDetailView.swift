//
//  MealDetailView.swift
//  SweetToothRecipe
//
//  Created by Gefei Shen on 3/9/23.
//

import SwiftUI

struct MealDetailView: View {
    @StateObject var viewModel: MealDetailViewModel
    
    init(mealId: String) {
        
        self._viewModel = StateObject(wrappedValue: .init(mealId: mealId))
    }
    
    var body: some View {
        Group {
            if let meal = viewModel.meal {
                ScrollView {
                    if let thumb = meal.thumb {
                        AsyncImage(url: thumb) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "photo")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    }
                    
                    VStack (alignment:.leading, spacing: 16){
                        VStack(alignment: .center){
                            Text(meal.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)

                            HStack{
                                if let category = meal.category {
                                    Text(category)
                                }
                                if let area = meal.area {
                                    Text(area)
                                }
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        
                        if let instructions = meal.instructions {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Instructions")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(instructions)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        if !meal.ingredients.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Ingredients")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                ForEach(meal.ingredients, id: \.self) { ingredient in
                                    HStack {
                                        Text("\(ingredient.name)")
                                        Spacer()
                                        Text("\(ingredient.amount)")
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            } else {
                VStack{
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(viewModel.meal?.name ?? "")
        .alert(isPresented: $viewModel.isError) {
            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "AAA"), dismissButton: .default(Text("OK"), action: {
                viewModel.isError = false
            }))
        }
        .onAppear {
            viewModel.getMealDetail()
        }
    }
}

class MealDetailViewModel: ObservableObject {
    private let mealId: String
    private let api: APIService
    
    @Published var meal: MealDetail?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isError = false
    
    init(mealId: String, api: APIService = APIService()) {
        self.mealId = mealId
        self.api = api
    }
    
    func getMealDetail() {
        withAnimation {
            self.isLoading = true
        }
        Task {
            do {
                let meal = try await api.getDessertDetail(mealId: mealId)
                DispatchQueue.main.async {
                    withAnimation {
                        self.meal = meal
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

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(mealId: "52854")
    }
}

