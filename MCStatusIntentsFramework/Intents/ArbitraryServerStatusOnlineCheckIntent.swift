//
//  File.swift
//  MCStatusIntentsFramework
//
//  Created by Tomer Shemesh on 9/8/23.
//

import Foundation
import AppIntents
import MCStatusDataLayer

struct ArbitraryServerStatusOnlineCheckIntent: AppIntent {
        
    static var title: LocalizedStringResource = "Arbitrary Minecraft Server Status Check"
    
    static var description =
           IntentDescription("Checks the status of an arbitrary Minecraft Server and returns either \"Online\",\"Offline\", or \"Unknown\" if the device if not connected to the internet or another error occurs")
    
    @Parameter(title: "Server Type")
    var serverType: ShortCutsServerType
    
    @Parameter(title: "Server Address/IP")
    var serverAddress: String
    
    @Parameter(title: "Server Port (Optional)")
    var serverPort: Int?
    
    
    func perform() async throws -> some IntentResult & ReturnsValue<ServerStatusEntity>{
        
        let convertedServerType: ServerType = switch serverType {
            case .java:
                .Java
            case .bedrock:
                .Bedrock
        }
        
       
        let container = SwiftDataHelper.getModelContainter()

        // do something about this port shit
        let tempServer = SavedMinecraftServer.initialize(id: UUID(), serverType: convertedServerType, name: "", serverUrl: serverAddress, serverPort: serverPort ?? 25565)
       
        // need to change this if we are on watch!!
        let status = await ServerStatusChecker.checkServer(server: tempServer)
        
        print("container:" + container.schema.debugDescription)

        let res = ServerStatusEntity(serverName: serverAddress, id: UUID())
        res.playerCount = status.onlinePlayerCount
        res.onlineStatus = status.status.rawValue
        
        return .result(value: res)
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Check online status for \(\.$serverType) server at \(\.$serverAddress) and port \(\.$serverPort)")
    }
}

enum ShortCutsServerType: String, AppEnum {
    static var typeDisplayRepresentation = TypeDisplayRepresentation("Server Type")

    
    static var caseDisplayRepresentations: [ShortCutsServerType: DisplayRepresentation] = [
        .java: "Java",
        .bedrock: "Bedrock/MCPE",
    ]
    case java
    case bedrock
    
    static var typeDisplayName: LocalizedStringResource = "Server Type"
}
