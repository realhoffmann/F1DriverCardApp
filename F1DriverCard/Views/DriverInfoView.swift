import SwiftUI

struct DriverInfoView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var showDriverSettings: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(viewModel.flagImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Spacer()
                Text(viewModel.driver?.permanentNumber ?? "")
                    .font(.f1Bold(30))
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text(viewModel.driver?.givenName ?? "Loading...")
                    .font(.f1Wide(20))
                    .foregroundColor(.white)
                Spacer()
            }
            HStack {
                Text(viewModel.driver?.familyName.uppercased() ?? "Loading...")
                    .font(.f1Wide(20))
                    .foregroundColor(.white)
                Image(systemName: "chevron.down")
                    .foregroundStyle(.gray)
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showDriverSettings = true
            }
            .sheet(isPresented: $showDriverSettings) {
                DriverSettingsView()
                    .presentationDetents([.large])
            }
            
            HStack {
                Image(viewModel.helmetImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .padding(.leading, -30)
                Spacer()
            }
        }
    }
}

#Preview {
    DriverInfoView(viewModel: HomeViewModel(), showDriverSettings: .constant(false))
}
