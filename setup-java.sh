#!/bin/bash
# =============================================================================
# Java Development Environment Setup (Aliyun Maven/Gradle Mirrors)
# Usage: ./setup-java.sh
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Java Setup (Maven/Gradle + Aliyun)"
echo "=========================================="

# ------------------------------------------
# Maven mirror: ~/.m2/settings.xml
# ------------------------------------------
mkdir -p "$HOME/.m2"
cat > "$HOME/.m2/settings.xml" << 'MAVEN_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <mirror>
      <id>aliyun-maven-public</id>
      <mirrorOf>central</mirrorOf>
      <name>Aliyun Maven Public</name>
      <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
    <mirror>
      <id>aliyun-spring</id>
      <mirrorOf>spring</mirrorOf>
      <name>Aliyun Spring</name>
      <url>https://maven.aliyun.com/repository/spring</url>
    </mirror>
    <mirror>
      <id>aliyun-google</id>
      <mirrorOf>google</mirrorOf>
      <name>Aliyun Google</name>
      <url>https://maven.aliyun.com/repository/google</url>
    </mirror>
    <mirror>
      <id>aliyun-aliyun</id>
      <mirrorOf>aliyun</mirrorOf>
      <name>Aliyun Alibaba</name>
      <url>https://maven.aliyun.com/repository/alibaba</url>
    </mirror>
    <mirror>
      <id>aliyun-thirdparty</id>
      <mirrorOf>thirdparty</mirrorOf>
      <name>Aliyun Thirdparty</name>
      <url>https://maven.aliyun.com/repository/thirdparty</url>
    </mirror>
  </mirrors>
</settings>
MAVEN_EOF
log_info "Maven mirror configured ( ~/.m2/settings.xml )"

# ------------------------------------------
# Gradle mirror: ~/.gradle/init.gradle
# ------------------------------------------
mkdir -p "$HOME/.gradle"
cat > "$HOME/.gradle/init.gradle" << 'GRADLE_EOF'
allprojects {
    buildscript {
        repositories {
            maven { url 'https://maven.aliyun.com/repository/public/' }
            maven { url 'https://maven.aliyun.com/repository/spring/' }
            maven { url 'https://maven.aliyun.com/repository/google/' }
            mavenLocal()
            mavenCentral()
        }
    }
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/spring/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
        mavenLocal()
        mavenCentral()
    }
}

settingsEvaluated { settings ->
    settings.pluginManagement {
        repositories {
            maven { url 'https://maven.aliyun.com/repository/public/' }
            maven { url 'https://maven.aliyun.com/repository/gradle-plugin/' }
            mavenLocal()
            gradlePluginPortal()
        }
    }
}
GRADLE_EOF
log_info "Gradle mirror configured ( ~/.gradle/init.gradle )"

# ------------------------------------------
# Update ~/.bashrc
# ------------------------------------------
if ! grep -q "JAVA_HOME" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Java Configuration" >> "$HOME/.bashrc"
    echo "export JAVA_HOME=\"$JAVA_HOME\"" >> "$HOME/.bashrc"
    echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\"" >> "$HOME/.bashrc"
    log_info "Added Java environment variables to ~/.bashrc"
fi

log_info "Java setup complete."
