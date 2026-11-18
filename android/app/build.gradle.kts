plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // [GANTI SAAT RESPONSI: Namespace harus sesuai dengan applicationId di bawah]
    namespace = "com.responsi.responsi_template"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // [GANTI SAAT RESPONSI: Jika pakai flutter_local_notifications, pastikan minimal Java 8]
        // Tambahkan: coreLibraryDesugaringEnabled = true
        // Dan di dependencies: coreLibraryDesugaring("com.android.tools.build:desugaring:2.1.4")
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // [GANTI SAAT RESPONSI: Application ID unik, biasanya com.<nama_tim>.<nama_app>]
        applicationId = "com.responsi.responsi_template"

        // [GANTI SAAT RESPONSI: minSdk minimal 21 untuk http & hive, minimal 23 untuk notifikasi]
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // [GANTI SAAT RESPONSI: Untuk build release asli, tambahkan signing config yang benar]
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

// ─── DEPENDENCIES ANDROID (opsional) ─────────────────────────────────────────
// [GANTI SAAT RESPONSI: Uncomment jika pakai flutter_local_notifications]
// dependencies {
//     coreLibraryDesugaring("com.android.tools.build:desugaring:2.1.4")
// }
