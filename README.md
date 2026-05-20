# Aetram - Real-Time Market Portfolio Tracker

Aetram is a premium, real-time stock and cryptocurrency portfolio tracking application built with **Flutter**. Designed with a stunning **TealVue** visual brand theme, the app delivers a native, buttery-smooth experience across mobile, tablet, and desktop/web.

## 🚀 Features

- **Real-Time Market Data:** Live WebSocket integration (`socket_io_client`) streaming ticker prices directly into the application.
- **Performance Optimized:** Advanced state management and 2-second stream throttling ensures millisecond socket updates don't overheat the CPU, while keeping UI rebuilds strictly optimal.
- **Premium Dashboard:** A comprehensive, responsive dashboard showcasing Total Portfolio Value, P&L, Market Insights, and dynamic performance cards.
- **Advanced Charting:** Custom-built interactive candlestick and line charts using `fl_chart`. Supports zooming, panning, and multiple historical timeframes (1D, 1W, 1M).
- **Watchlist & Search:** Real-time symbol search, bookmarking, and live tracking of your favorite assets.
- **Portfolio Management:** Buy holdings, record average prices, and effortlessly track live investments versus current market values.
- **Responsive Design:** Adapts fluidly between mobile constraints and expansive grid architectures on Web/Desktop.
- **Dark/Light Themes:** Elegant dual-mode aesthetic built on Material 3.

## 🛠 Tech Stack & Architecture

Aetram is built upon a highly modular, clean architecture.

* **Framework:** Flutter (Material 3)
* **State Management:** GetX (Controllers, Bindings, and highly targeted reactive `GetBuilder` / `Obx` widgets)
* **Networking:** WebSockets (`socket_io_client`) and `dio` for HTTP operations
* **Local Storage:** `get_storage` for persistence (Watchlist, Portfolio)
* **Charting:** `fl_chart`
* **Architecture:** Feature-first modularization

```text
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── routes/
│   ├── socket/
│   ├── theme/
│   └── utils/
├── features/
│   ├── about/
│   ├── chart/
│   ├── dashboard/
│   ├── portfolio/
│   ├── symbol_search/
│   └── watchlist/
└── shared/
```

## ⚡ Performance Engineering

1. **WebSocket Throttling:** 
   Raw market data is streamed in milliseconds. Aetram employs a highly efficient periodic buffering mechanism within `SocketService` to digest ticks and emit them precisely every 2 seconds.
2. **Targeted Reactivity:**
   Utilizing `GetBuilder` in heavy parent containers (like `DashboardPage`) and tying `liveTicks` refreshes manually avoids the Flutter tree from experiencing frame drops during heavy data ingestion.
3. **Impeccable Visual Bounds:**
   Extensive use of `clipBehavior: Clip.antiAlias` and custom shapes ensures hover effects and ink splashes are bound cleanly to borders, rendering a gorgeous, glitch-free UI.

## 📦 Getting Started

### Prerequisites
- Flutter SDK `^3.11.5` or higher

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/DeviOSFlutter/aetram.git
   ```
2. Navigate into the project:
   ```bash
   cd aetram
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 🧪 Quality Standards

- `flutter analyze` returns **0 issues** across the entire codebase.
- No redundant comments; self-documenting code.
- Clean widget trees through robust separation of concerns (`StatelessWidget` extractions).

---
*Built as a showcase for high-performance, real-time Flutter development.*
