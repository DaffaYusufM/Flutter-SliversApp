pipeline {
  agent any

  environment {
    // Ganti dengan username dan nama repo Docker Hub kamu
    IMAGE_NAME = 'daffayusufm/flutter-sliversapp'

    // ID credential Docker Hub yang kamu buat di Jenkins
    REGISTRY_CREDENTIALS = 'dockerhub-credentials'
  }

  stages {
    stage('Checkout') {
      steps {
        echo "📦 Checking out source code..."
        checkout scm
      }
    }

    stage('Build Info') {
      steps {
        bat 'echo Building on Windows Agent...'
      }
    }

    stage('Build Docker Image') {
      steps {
        echo "🔧 Building Docker image..."
        bat """
          docker build -t %IMAGE_NAME%:%BUILD_NUMBER% .
          docker tag %IMAGE_NAME%:%BUILD_NUMBER% %IMAGE_NAME%:latest
        """
      }
    }

    stage('Push Docker Image') {
      steps {
        echo "🚀 Pushing image to Docker Hub..."
        withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          // Gunakan login yang aman lewat stdin
          bat """
            echo %PASS% | docker login -u %USER% --password-stdin
            docker push %IMAGE_NAME%:%BUILD_NUMBER%
            docker push %IMAGE_NAME%:latest
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ SUCCESS: Image pushed as ${IMAGE_NAME}:${BUILD_NUMBER}"
    }
    failure {
      echo "❌ BUILD FAILED"
    }
  }
}
