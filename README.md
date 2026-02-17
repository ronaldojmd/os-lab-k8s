# Laboratorio de Sistemas Operativos en Kubernetes (multi-distro)

Este laboratorio permite desplegar contenedores de distintas distribuciones Linux (Ubuntu, Debian, Alpine, CentOS Stream y Kali) en un clúster de Kubernetes.  
El objetivo es que los estudiantes puedan **comparar diferencias y similitudes** entre sistemas operativos en cuanto a gestión de paquetes, procesos, usuarios, servicios y configuraciones básicas.

---

## 🎯 Objetivos

1. Comprender cómo ejecutar diferentes distribuciones Linux en Kubernetes mediante Pods.
2. Explorar las particularidades de cada distribución en cuanto a:
   - Gestores de paquetes.
   - Manejo de procesos y servicios.
   - Administración de usuarios y permisos.
   - Estructura de directorios y archivos de configuración.
3. Familiarizarse con el uso de `kubectl` para desplegar, administrar y conectarse a Pods.
4. Comparar y reflexionar sobre la diversidad del ecosistema Linux.

---

## 🛠️ Requisitos previos

- PC con al menos **2 CPU y 4 GB de RAM libres**.
- **Docker** o motor de contenedores compatible.
- **kubectl** instalado y configurado.
- **kind** para crear el clúster de Kubernetes local.

---

## 🚀 Instalación

### Linux (Ubuntu/Debian)
```bash
sudo apt-get update && sudo apt-get install -y docker.io
sudo usermod -aG docker $USER && newgrp docker

curl -fsSLo kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -m 0755 kubectl /usr/local/bin/kubectl

curl -Lo kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.23.0/kind-linux-amd64"
chmod +x kind && sudo mv kind /usr/local/bin/
```

### macOS
```bash
brew install colima docker kubectl kind
colima start --cpu 2 --memory 4
```

### Windows (WSL2)
- Instalar **Docker Desktop** con soporte WSL2.
- Instalar `kubectl` y `kind` con winget:
```powershell
winget install -e --id Kubernetes.kubectl
winget install -e --id Kubernetes.kind
```

---

## 📂 Estructura del repo

```
os-lab-k8s/
├── pods/
│   ├── ubuntu.yaml
│   ├── debian.yaml
│   ├── alpine.yaml
│   ├── centos.yaml
│   ├── kali.yaml
│   └── kustomization.yaml
├── Makefile
├── verify_lab.sh
└── README.md
```

---

## ▶️ Uso básico

```bash
make cluster-up     # 1. Crear clúster kind y namespace
make deploy         # 2. Desplegar los Pods
make verify         # 3. Verificar que estén corriendo
make lab            # 4. Smoke test en todas las distros
make ubuntu         # 5. Entrar a Ubuntu (igual para las demás distros)
./verify_lab.sh     # 6. Verificar automáticamente el laboratorio
make clean          # 7. Borrar los Pods
make cluster-down   # 8. Eliminar el clúster
```

---

## 📚 Actividades sugeridas

### 1. Identificación del sistema operativo
```bash
cat /etc/os-release
uname -a
```

### 2. Gestores de paquetes
- Ubuntu/Debian/Kali:
  ```bash
  apt-get update && apt-get install -y vim
  ```
- Alpine:
  ```bash
  apk add vim
  ```
- CentOS:
  ```bash
  dnf install -y vim
  ```

📌 Completar una **tabla comparativa**:

| Distro  | Gestor   | Instalar             | Buscar         | Eliminar          |
|---------|----------|----------------------|----------------|------------------|
| Ubuntu  | apt-get  | apt-get install pkg  | apt-cache search | apt-get remove pkg |
| Debian  | apt-get  | apt-get install pkg  | apt-cache search | apt-get remove pkg |
| Alpine  | apk      | apk add pkg          | apk search pkg   | apk del pkg        |
| CentOS  | dnf      | yum install pkg      | yum search pkg   | yum remove pkg     |
| Kali    | apt      | apt install pkg      | apt search pkg   | apt remove pkg     |

---

### 3. Procesos y monitoreo
```bash
ps aux
top -b -n1 | head -20
```

Preguntas:
1. ¿Qué proceso aparece como PID 1?
2. ¿Por qué no se usa `systemd` en los contenedores?

---

### 4. Usuarios y permisos
```bash
cat /etc/passwd | head
adduser estudiante     # en Ubuntu/Debian/Kali
apk add shadow && adduser estudiante   # en Alpine
useradd estudiante && passwd estudiante # en CentOS
```

📌 Compara la sintaxis y discute diferencias.

---

### 5. Estructura de directorios
```bash
ls /bin
ls /usr/bin
du -sh /
```
📌 Comparar tamaño de imagen y utilidades instaladas por defecto.

---

### 6. Red básica
```bash
ping -c 2 8.8.8.8
curl -I https://example.com || echo "instala curl"
```

---

## ✅ Evaluación

- Despliegue correcto de los 5 Pods.
- Evidencias de actividades (capturas/tablas).
- Creación del usuario `estudiante`.
- Instalación de un editor (`vim` o `nano`).
- Análisis comparativo final entre distros.

---

## 🧹 Limpieza

```bash
make clean
make cluster-down
```

---

¡Listo! Ahora puedes explorar, comparar y aprender sobre distintas distribuciones Linux sin salir de Kubernetes 🚀.
