# Aetram — Real-Time Market Watchlist & Portfolio App

Aetram is a premium real-time market watchlist and paper portfolio tracking application built with Flutter. The application is designed around a modern fintech experience inspired by platforms like Zerodha, Groww, TradingView, and Binance, while maintaining strong architectural discipline and high-performance realtime rendering.

---

## 📌 Assignment Build Tag

TV-WL-2026-Q3

---

## 🚀 Features

### 📡 Real-Time Market Streaming
- Live Socket.IO ticker integration using `socket_io_client`
- Real-time LTP updates
- Real-time absolute and percentage change updates
- Efficient websocket subscription management
- Graceful socket reconnection handling

### 📈 Advanced Realtime Charts
- Realtime candlestick chart rendering
- Historical chart ranges:
  - 1D (live replay session)
  - 1W historical
  - 1M historical
- Fullscreen landscape chart support
- Responsive chart interactions
- Live candle aggregation
- Smooth tick-by-tick updates

### ⭐ Watchlist & Symbol Search
- Symbol catalog integration
- Real-time symbol search
- Add/remove watchlist symbols
- Persistent watchlist storage
- Live market updates directly inside watchlist rows

### 💼 Paper Portfolio
- Local paper holdings
- Quantity and average buy price tracking
- Real-time portfolio valuation
- Unrealised P&L calculations
- Live portfolio updates using websocket prices
- Persistent local portfolio storage

### 📊 Dashboard Analytics
- Total portfolio value
- Total invested value
- Total unrealised P&L
- Per-stock breakdown
- VWAP vs LTP insights
- Market analytics cards

### 🎨 UI & Experience
- Responsive layouts for mobile/tablet/web
- Dark & Light themes
- Modern fintech-inspired UI
- Premium gradients and cards
- Smooth animations and transitions

---

## 🛠 Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform framework |
| GetX | State management & dependency injection |
| Dio | REST API networking |
| Socket.IO | Realtime market feed |
| GetStorage | Local persistence |
| fl_chart | Interactive chart rendering |
| Firebase Hosting | Web deployment |

---

## 🧱 Architecture

The project follows a strict feature-first clean architecture.

```text
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── network/
│   ├── routes/
│   ├── socket/
│   ├── storage/
│   ├── theme/
│   └── utils/
│
├── features/
│   ├── about/
│   ├── chart/
│   ├── dashboard/
│   ├── portfolio/
│   ├── splash/
│   ├── symbol_search/
│   └── watchlist/
│
└── shared/
```

---

## 🧱 Clean Architecture Flow

```text
Presentation
   ↓
UseCases
   ↓
Repositories
   ↓
DataSources
   ↓
API / WebSocket / Local Storage
```

### Architectural Principles

- Feature-first modularization
- Strict separation of concerns
- No business logic inside UI widgets
- Repository/usecase abstraction
- Reusable presentation widgets
- Reactive realtime state management
- Persistent local caching

---

## 🔌 Realtime Socket Handling

The realtime layer is designed to correctly handle:

- Initial replay burst subscriptions
- Continuous live streaming
- Incremental candle aggregation
- Duplicate tick protection
- Market session rollover
- Reconnection scenarios
- Realtime chart updates without full widget rebuilds

The websocket architecture ensures smooth chart rendering even during heavy replay bursts and rapid tick streams.

---

## ⚡ Performance Engineering

### 1. Targeted Reactivity

Heavy UI sections use carefully scoped reactive rebuilds (`Obx`, `GetBuilder`) to prevent unnecessary widget tree refreshes during live streaming.

### 2. Incremental Candle Updates

Candles are updated incrementally rather than rebuilding entire datasets for every incoming tick.

### 3. Responsive Layout System

Desktop/tablet/mobile layouts adapt fluidly using responsive constraints and scalable grid structures.

### 4. Persistent Local Storage

Watchlist and portfolio state are persisted using `GetStorage` for fast cold-start recovery.

---

## 📦 Setup & Run

### Prerequisites

- Flutter SDK `>=3.11`
- Dart SDK
- Firebase CLI (for web deployment)

---

## 🔧 Installation

### 1. Clone Repository

```bash
git clone https://github.com/DeviOSFlutter/aetram.git
```

### 2. Navigate Into Project

```bash
cd aetram
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run Application

```bash
flutter run
```

---

## 🌐 Firebase Hosting Deployment

### Build Flutter Web

```bash
flutter build web
```

### Deploy

```bash
firebase deploy
```

---

## 📖 Assumptions Made

- The 1D chart mode uses the live Socket.IO replay stream instead of historical REST snapshots because the simulator already replays the current market session from market open.
- ATP from the websocket ticker feed is treated as VWAP for dashboard analytics.
- Portfolio holdings are stored locally using GetStorage because no backend portfolio persistence API was provided.
- BUY actions are intentionally placed inside the chart detail screen rather than watchlist rows to match standard trading application UX patterns.
- Historical ranges use REST snapshots while realtime intraday candles continue through websocket aggregation.

---

## 🧪 Assignment Testing Notes

### 1. RELIANCE `total_records`

The Historical Data API for RELIANCE returned `No records found` during testing for certain higher historical ranges (`1W` / `1M`) from the mock environment. The application gracefully handles this scenario by rendering appropriate empty/loading states without crashing.

### 2. Approximate TCS Initial Burst Tick Count

During raw socket testing (without throttling), the initial replay burst for TCS produced approximately **746 ticks** before transitioning into the continuous live stream phase.

For production rendering stability, the application intentionally applies a socket-layer aggregation/throttling strategy that compresses high-frequency replay bursts into controlled UI emissions. After optimization, the UI layer emitted approximately **4 aggregated updates**, with the final aggregated emission containing the latest replay state from the original 746-tick burst.

This approach was intentionally implemented to:
- prevent excessive widget rebuilds
- reduce rendering overhead during replay bursts
- maintain smooth chart interactions
- avoid UI flickering under high-frequency websocket streams
- preserve realtime responsiveness while keeping the application performant

## 🎥 Demo Walkthrough

### Hosted Web App

[Aetram Live Demo](https://tasktealvue.web.app/)

---

## 🚧 What I’d Improve With More Time

- Introduce websocket-driven price alerts with local notifications.
- Implement offline-first candle persistence using Hive or Isar for faster cold starts.
- Add portfolio allocation analytics and sector exposure visualizations.
- Integrate Firebase Analytics and Crashlytics for production monitoring.
- Add widget, integration, and realtime stream stress testing coverage.
- Move candle aggregation into isolate-based processing for extremely high-frequency streams.
- Add advanced market depth simulation and lightweight order book visualization.
- Improve accessibility and keyboard navigation for desktop/web users.
- Add dynamic stream throttling based on device performance characteristics.

---

## ✅ Quality Standards

- Clean feature-first architecture
- Strong separation of concerns
- Self-documenting code structure
- Reusable widget composition
- Responsive design across platforms
- Realtime-safe rendering architecture
- Incremental meaningful git commits

---

## 📱 Supported Platforms

The application is architected to support all Flutter-supported platforms:

- Android
- iOS
- Web
- Windows
- macOS
- Linux

Primary development and testing for this assignment were performed on Flutter Web/Desktop environments.

---

## 🙌 Final Notes

This project was built as a practical exploration of high-performance realtime Flutter engineering, focusing heavily on:

- websocket architecture
- realtime rendering
- chart lifecycle handling
- clean architecture discipline
- scalable UI composition

The primary goal was to create a smooth realtime market experience while maintaining production-grade code organization and performance characteristics.