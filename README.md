# E-Health Enterprise Application

This project is an enterprise-grade refactoring of the Poliklinik application. It adheres to Clean Architecture, CQRS, and advanced State Management using Provider, all while being powered entirely by MockAPI.

## Features Added During Refactoring
* **Clean Architecture Folder Structure**
* **Dynamic API Endpoint Resolver**
* **API Interceptors & Result Handling**
* **Real-time Synchronization via Polling**
* **Intelligent Data Caching & Diff Checking**
* **Queue Management System (Persistent)**
* **CQRS Pattern Implementation**
* **Smart Debounced Search for Doctors & Medicines**

---

## Diagrams

### 1. Architecture Diagram
```mermaid
graph TD
    UI[Presentation Layer] --> Providers[State Management / Providers]
    Providers --> CQRS[CQRS Handlers]
    Providers --> RT[Realtime Service]
    RT --> PM[Polling Manager]
    CQRS --> Repos[Repositories]
    Repos --> API[Api Client / Network]
    API --> Mock[MockAPI REST]
    RT --> Cache[Cache Manager]
```

### 2. Provider Flow
```mermaid
graph LR
    Action[UI Action] --> Provider[Provider Method]
    Provider --> Loading[Set Loading State]
    Loading --> Fetch[Execute CQRS Handler]
    Fetch --> Success{ApiResult}
    Success -- Success --> Update[Update State & Cache]
    Success -- Error --> Err[Set Error State]
    Update --> Notify[notifyListeners]
    Err --> Notify
    Notify --> Rebuild[UI Rebuild]
```

### 3. CQRS Diagram
```mermaid
graph TD
    Client[Provider / UI] --> QueryH[Query Handler]
    Client --> CmdH[Command Handler]
    
    QueryH --> GET[GET Request]
    CmdH --> POST[POST / PUT / DELETE]
    
    GET --> Repo[Repository]
    POST --> Repo
    
    Repo --> API[MockAPI]
```

### 4. Polling Flow
```mermaid
sequenceDiagram
    participant P as Provider
    participant RT as RealtimeService
    participant PM as PollingManager
    participant Cache as CacheManager
    participant API as MockAPI

    P->>RT: startPolling()
    RT->>PM: start(interval)
    loop Every interval
        PM->>RT: _poll()
        RT->>API: fetchData()
        API-->>RT: newData
        RT->>Cache: get()
        Cache-->>RT: cachedData
        alt !SyncEngine.isDataIdentical
            RT->>Cache: save(newData)
            RT->>P: onDataChanged(newData)
            P->>P: notifyListeners()
        end
    end
```

### 5. Queue Synchronization Diagram
```mermaid
sequenceDiagram
    participant UI as Appointment UI
    participant P as AppointmentProvider
    participant QM as QueueManager
    participant API as MockAPI

    UI->>P: createAppointment(data)
    P->>QM: getNextQueueNumber()
    QM->>API: GET /appointments
    API-->>QM: List<Appointments>
    QM->>QM: Find highest queueNumber
    QM-->>P: highestQueue + 1
    P->>P: Attach new queueNumber to data
    P->>API: POST /appointments (data)
    API-->>P: Success
    P-->>UI: Show Success
```

### 6. Folder Structure
```text
lib/
├── core/
│   ├── cqrs/
│   └── utils/
├── config/
├── network/
├── services/
├── realtime/
├── cache/
├── repositories/
├── providers/
├── models/
├── entities/
└── presentation/
    ├── screens/
    ├── widgets/
    └── shared/
```

### 7. Class Diagram (Core Network & CQRS)
```mermaid
classDiagram
    class ApiClient {
        +get(url)
        +post(url, body)
        +put(url, body)
        +delete(url)
    }
    
    class QueryHandler {
        <<interface>>
        +handle(params) ApiResult
    }
    
    class CommandHandler {
        <<interface>>
        +handle(params) ApiResult
    }
    
    class RealtimeService {
        +start()
        +stop()
        -_poll()
    }
    
    class PollingManager {
        +start(key, interval, task)
        +stop(key)
    }
    
    QueryHandler ..> ApiClient
    CommandHandler ..> ApiClient
    RealtimeService --> PollingManager
```
