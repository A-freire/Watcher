//
//  ShowsView.swift
//  Watcher
//
//  Created by Adrien Freire on 18/12/2024.
//

import SwiftUI
import Kingfisher

struct ShowsView: View {
    @ObservedObject var gsManager = GridSizeManager(userDefaultsKey: "ShowsGrid")
    // swiftlint:disable:next identifier_name
    @ObservedObject var vm: ShowsVM

    init(serviceConfig: ServiceConfig) {
        self.vm = ShowsVM(sonarr: serviceConfig)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if !vm.shows.isEmpty {
                    LazyVGrid(columns: gsManager.selectedSize.gridItems) {
                        ForEach(vm.searchedShows, id: \.self) { show in
                            ShowCardView(
                                vm: vm.initShowVM(
                                    show: show
                                ),
                                eraseMode: $vm.eraseMode,
                                status: vm.getShowStatus(
                                    id: show.getId
                                )
                            )
                                .simultaneousGesture(TapGesture().onEnded({ _ in
                                    vm.modifyDelete(id: show.getId)
                                }), isEnabled: vm.eraseMode)
                                .border(vm.isSelected(id: show.getId) ? .red : .clear, width: 10)
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .onAppear(perform: {
                vm.fetchInit()
                vm.getSizeLeft()
            })
            .refreshable(action: {
                vm.fetchInit()
            })
            .searchable(text: $vm.search, prompt: "Search")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "trash")
                        .foregroundStyle(vm.eraseMode ? .red : .white)
                        .onTapGesture {
                            vm.manageDelete()
                        }
                }
                if UIDevice.current.userInterfaceIdiom == .pad {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: gsManager.selectedSize.gridImage)
                            .onTapGesture {
                                gsManager.changeColumns()
                            }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(vm.spaceLeft) GB left")
                        .onTapGesture {
                            vm.getSizeLeft()
                        }
                }
            }
            .alert("Do you want to erase the shows or emptying them ?", isPresented: $vm.confirmErase, actions: {
                Button("Empty", role: .destructive) { vm.deleteAll(erase: false) }
                Button("Erase", role: .destructive) { vm.deleteAll(erase: true) }
                Button("Cancel", role: .cancel) { vm.freeDelete() }
            })
        }
    }
}

struct ShowCardView: View {
    // swiftlint:disable:next identifier_name
    @ObservedObject var vm: ShowVM
    @Binding var eraseMode: Bool
    let status: Status
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            KFImage(vm.show.getPoster)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottomTrailing) {
                    DotStatus(color: status.color)
                        .padding(2)
                }
        }
        .onTapGesture {
            if !eraseMode {
                withAnimation {
                    isPresented.toggle()
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            ShowSheetView(vm: vm, status: status)
        }
    }
}
