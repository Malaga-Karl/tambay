# Keep Flutter
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep WebView
-keep class android.webkit.** { *; }
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(...);
}
-keepclassmembers class * extends android.webkit.WebChromeClient {
    public void *(...);
}

# Keep Google Play services (if used)
-keep class com.google.android.gms.** { *; }

# Flutter / Play Core keep rules
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**