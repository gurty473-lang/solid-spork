ZYLO BALANCE TRACKER — Fabric 1.21.11

WHAT IT DOES
- Press RIGHT SHIFT to open the custom balance screen.
- Watches normal (non-action-bar) server chat for lines containing words such as
  "Balance", "Bal", "Money", "Cash", "Purse", or "Wallet".
- Understands values such as $1,234, 1.5M, 2B, and 3.2 trillion.
- Saves current/previous balance and session totals in:
  .minecraft/config/zylo-balance-tracker.json

IMPORTANT
This is a client-side tracker. It does not read private server data or change your
real server balance. It can only update when the server sends a matching balance
message to your chat. If your server uses a different /bal message format, that
format may need to be added to the parser.

BUILDING THE MOD
Easiest (Windows): install Java 21, then double-click build.bat.
  - It checks Java, downloads Gradle 9.2.1 automatically if you don't have it,
    builds the mod, and opens build\libs\ with the finished jar.
  - First build downloads Minecraft + Fabric, so it needs internet and takes a few minutes.
Linux/macOS: run ./build.sh
IntelliJ IDEA: open this folder as a Gradle project, run the "build" task
  (after the first build.bat run, gradlew.bat also exists).

Output: build/libs/zylo-balance-tracker-1.0.0.jar
(ignore the -sources jar). Put it in .minecraft/mods alongside Fabric API.

Required in Minecraft:
- Fabric Loader for 1.21.11
- Fabric API for 1.21.11
