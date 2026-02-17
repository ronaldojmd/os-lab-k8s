# Laboratorio de Sistemas Operativos en Kubernetes (multidistro)

Este laboratorio permite desplegar contenedores de distintas distribuciones Linux (Ubuntu, Debian, Alpine, CentOS Stream y Kali) en un clúster de Kubernetes. El objetivo es que los estudiantes puedan comparar diferencias y similitudes entre sistemas operativos en cuanto a gestión de paquetes, procesos, usuarios, servicios y configuraciones básicas.

## 🛠️ Requisitos previos
* PC con al menos 2 CPU y 4 GB de RAM libres.
* Compatible con Docker o motor de contenedores.
* **kubectl** instalado y configurado.
* **Kind** para crear el clúster de Kubernetes local.

## 🚀 Instalación

### Linux (Ubuntu/Debian)
```bash
sudo apt-get update && sudo apt-get install -y docker.io
sudo usermod -aG docker $USER && newgrp docker

curl -fsSLo kubectl "[https://dl.k8s.io/release/](https://dl.k8s.io/release/)\$(curl -L -s [https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl](https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl)"
sudo install -m 0755 kubectl /usr/local/bin/kubectl

curl -Lo kind "[https://github.com/kubernetes-sigs/kind/releases/download/v0.23.0/kind-linux-amd64](https://github.com/kubernetes-sigs/kind/releases/download/v0.23.0/kind-linux-amd64)"
chmod +x kind && sudo mv kind /usr/local/bin/
macOS
Bash
brew install colima docker kubectl kind
colima start --cpu 2 --memory 4
Windows (WSL2)
Instale Docker Desktop con soporte WSL2.

Instale kubectl y kind con winget:

PowerShell
winget install -e --id Kubernetes.kubectl
winget install -e --id Kubernetes.kind
▶️ Uso básico
make cluster-up     # 1. Crear clúster kind y namespace

make deploy         # 2. Desplegar los Pods

make verify         # 3. Verificar que estén corriendo

make lab            # 4. Smoke test en todas las distros

make ubuntu         # 5. Entrar a Ubuntu (igual para las demás distros)

./verify_lab.sh     # 6. Verificar automáticamente el laboratorio

make clean          # 7. Borrar los Pods

make cluster-down   # 8. Eliminar el clúster
