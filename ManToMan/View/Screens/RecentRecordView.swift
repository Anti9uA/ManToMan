//
//  RecentRecordView.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/05/13.
//

import SwiftUI

struct RecentRecordView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var recent: FetchedResults<Recent>
    @State var recentOpacity = 0.0
    @Binding var isRecentPresented: Bool
    @Binding var text: String
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                ZStack{
                    HStack{
                        Spacer()
                        
                        Text("번역기록")
                            .font(.customTitle())
                        
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            self.isRecentPresented = false
                        }, label: {
                            Text("취소")
                                .font(.customSubBody())
                                .foregroundColor(.blue)
                        })
                    }
                    .padding(.trailing, 20)
                }
                .padding(.top, 30)
                
                List {
                    ForEach(recent, id: \.self) { sen in
                        Text(sen.sentence ?? "error")
                            .lineLimit(1)
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                            .font(.customBody())
                            .opacity(recentOpacity)
                            .onTapGesture {
                                text = sen.sentence ?? "error"
                                self.isRecentPresented = false
                            }
                            .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteItem)
                }
                .listStyle(.plain)
                
                
            }
            .onAppear {
                withAnimation(.easeIn) {
                    recentOpacity = 1.0
                }
            }
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let sen = recent[index]
            managedObjContext.delete(sen)
        }
        DataController().save(context: managedObjContext)
    }
}

struct RecentRecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecentRecordView(isRecentPresented: .constant(true), text: .constant("asdf"))
    }
}
