## 2024-10-24 - Search Input Throttling vs Debouncing
**Learning:** This codebase used `.throttle` for the search input, causing intermediate API requests while typing.
**Action:** Always prefer `.debounce` for search inputs to trigger requests only after the user stops typing.
