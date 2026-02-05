## 2024-10-26 - Unsafe URL Construction
**Vulnerability:** User input was directly interpolated into API URL strings, creating risks of Query Parameter Injection and Path Traversal.
**Learning:** Developers often default to string interpolation for simplicity, overlooking that URL components require specific encoding (e.g., space to %20, & to %26).
**Prevention:** Always use the networking library's parameter encoding for query parameters. For path parameters, explicitly apply `addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)`.
