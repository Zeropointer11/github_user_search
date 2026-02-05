## 2024-10-26 - Missing Accessibility Context for Stats
**Learning:** The app displays raw numbers for followers/following counts, which is confusing for screen readers.
**Action:** Always wrap statistical numbers in `accessibilityLabel` with descriptive text (e.g., "\(count) followers") while keeping the visual label minimal.
