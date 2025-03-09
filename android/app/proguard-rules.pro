# Keep all classes in your app package
-keep class com.moodpanda.app.** { *; }

# Keep Retrofit, OkHttp, and Gson classes
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }
-keep class com.google.gson.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Prevent warnings for these libraries
-dontwarn okhttp3.**
-dontwarn retrofit2.**
-dontwarn com.google.gson.**
-dontwarn javax.annotation.**

# Preserve signatures
-keepattributes Signature
