import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    if (project.name != "app") {
        project.afterEvaluate {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val method = android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                    method.invoke(android, 36)
                    println("Successfully set compileSdkVersion(36) on ${project.name}")
                } catch (e: Exception) {
                    try {
                        val method = android.javaClass.getMethod("setCompileSdkVersion", Int::class.javaPrimitiveType)
                        method.invoke(android, 36)
                        println("Successfully set setCompileSdkVersion(36) on ${project.name}")
                    } catch (e2: Exception) {
                        println("Failed to set compileSdk on ${project.name}: $e2")
                    }
                }

                // Align Java and Kotlin JVM targets across plugin subprojects
                // (fixes "Inconsistent JVM Target Compatibility" e.g. flutter_timezone).
                try {
                    val compileOptions = android.javaClass.getMethod("getCompileOptions").invoke(android)
                    val jv = JavaVersion.VERSION_11
                    compileOptions.javaClass.getMethod("setSourceCompatibility", JavaVersion::class.java)
                        .invoke(compileOptions, jv)
                    compileOptions.javaClass.getMethod("setTargetCompatibility", JavaVersion::class.java)
                        .invoke(compileOptions, jv)
                } catch (e: Exception) {
                    println("Could not set compileOptions on ${project.name}: $e")
                }
            }

            project.tasks.withType(KotlinCompile::class.java).configureEach {
                compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

