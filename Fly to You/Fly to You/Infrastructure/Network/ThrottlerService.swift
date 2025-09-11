//
//  ThrottlerService.swift
//  Fly to You
//
//  Created by 최희진 on 9/11/25.
//

import Foundation

final class ThrottlerService {
    private let dueTime: TimeInterval
    private let latest: Bool
    private var task: Task<Void, Never>?
    
    init(dueTime: TimeInterval = 2.0, latest: Bool = false){
        self.dueTime = dueTime
        self.latest = latest
    }
    
    deinit {
        task?.cancel()
    }
    
    func callAsFunction(action: @escaping () async -> Void){
        self.execute(action: action)
    }
    
    func cancel(){
        self.task?.cancel()
        self.task = nil
    }
}

private extension ThrottlerService {
    func execute(action: @escaping () async -> Void){

        guard self.task?.isCancelled ?? true else{return}
        
        if !self.latest {
            Task{
                await action()
            }
        }
        
        self.task = Task{ [weak self] in
            guard let self else { return }
            
            do{
                try await Task.sleep(for: .seconds(Int(self.dueTime)))
            } catch {
                return
            }

            self.task = nil
        }
    }
}
