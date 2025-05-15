# --- STRIPE SDK: Evita que R8 elimine clases necesarias ---
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**
