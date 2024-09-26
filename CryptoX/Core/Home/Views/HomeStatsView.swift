//
//  HomeStatsView.swift
//  CryptoX
//
//  Created by pritam on 2024-09-22.
//

import SwiftUI


struct HomeStatsView: View {
    
    @Environment (HomeViewModel.self) private var vm: HomeViewModel

    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, 
               alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false))
        .environment(DeveloperPreview.instance.homeVM)
}
