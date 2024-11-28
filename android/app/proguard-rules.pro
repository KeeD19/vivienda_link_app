# Mantener clases de Stripe PushProvisioning
-keep class com.stripe.android.** { *; }
-keep class com.reactnativestripesdk.** { *; }

# Evitar advertencias
-dontwarn com.stripe.android.**
-dontwarn com.reactnativestripesdk.**

# Evitar la optimización de clases críticas
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes EnclosingMethod
