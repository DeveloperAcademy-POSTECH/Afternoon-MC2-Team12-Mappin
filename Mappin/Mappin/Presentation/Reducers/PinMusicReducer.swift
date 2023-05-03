//
//  PinMusicReducer.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import ComposableArchitecture
@preconcurrency import SwiftUI

enum Filter: LocalizedStringKey, CaseIterable, Hashable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}

struct Todos: ReducerProtocol {
    struct State: Equatable {
        var editMode: EditMode = .inactive
        var filter: Filter = .all
        var todos: IdentifiedArrayOf<Todo.State> = []
        
        var filteredTodos: IdentifiedArrayOf<Todo.State> {
            switch filter {
            case .active: return self.todos.filter { !$0.isComplete }
            case .all: return self.todos
            case .completed: return self.todos.filter(\.isComplete)
            }
        }
    }
    
    struct ViewState: Equatable {
        let editMode: EditMode
        let filter: Filter
        let isClearCompletedButtonDisabled: Bool
        
        init(state: Todos.State) {
            self.editMode = state.editMode
            self.filter = state.filter
            self.isClearCompletedButtonDisabled = !state.todos.contains(where: \.isComplete)
        }
    }
    
    
    enum Action: Equatable {
        case addTodoButtonTapped
        case clearCompletedButtonTapped
        case delete(IndexSet)
        case editModeChanged(EditMode)
        case filterPicked(Filter)
        case move(IndexSet, Int)
        case sortCompletedTodos
        case todo(id: Todo.State.ID, action: Todo.Action)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.uuid) var uuid
    private enum TodoCompletionID {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .addTodoButtonTapped:
                state.todos.insert(Todo.State(id: self.uuid()), at: 0)
                return .none
                
            case .clearCompletedButtonTapped:
                state.todos.removeAll(where: \.isComplete)
                return .none
                
            case let .delete(indexSet):
                let filteredTodos = state.filteredTodos
                for index in indexSet {
                    state.todos.remove(id: filteredTodos[index].id)
                }
                return .none
                
            case let .editModeChanged(editMode):
                state.editMode = editMode
                return .none
                
            case let .filterPicked(filter):
                state.filter = filter
                return .none
                
            case var .move(source, destination):
                if state.filter == .completed {
                    source = IndexSet(
                        source
                            .map { state.filteredTodos[$0] }
                            .compactMap { state.todos.index(id: $0.id) }
                    )
                    destination =
                    (destination < state.filteredTodos.endIndex
                     ? state.todos.index(id: state.filteredTodos[destination].id)
                     : state.todos.endIndex)
                    ?? destination
                }
                
                state.todos.move(fromOffsets: source, toOffset: destination)
                
                return .task {
                    try await self.clock.sleep(for: .milliseconds(100))
                    return .sortCompletedTodos
                }
                
            case .sortCompletedTodos:
                state.todos.sort { $1.isComplete && !$0.isComplete }
                return .none
                
            case .todo(id: _, action: .checkBoxToggled):
                return .run { send in
                    try await self.clock.sleep(for: .seconds(1))
                    await send(.sortCompletedTodos, animation: .default)
                }
                .cancellable(id: TodoCompletionID.self, cancelInFlight: true)
                
            case .todo:
                return .none
            }
        }
        .forEach(\.todos, action: /Action.todo(id:action:)) {
            Todo()
        }
    }
}
