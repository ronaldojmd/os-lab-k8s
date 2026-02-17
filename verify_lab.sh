#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="os-lab"
PODS=("ubuntu" "debian" "alpine" "centos" "kali")

echo "🔎 Verificando namespace..."
if ! kubectl get ns $NAMESPACE >/dev/null 2>&1; then
  echo "❌ Namespace $NAMESPACE no existe. Corre 'make cluster-up' primero."
  exit 1
fi
echo "✅ Namespace $NAMESPACE existe."

echo -e "\n🔎 Verificando Pods..."
for pod in "${PODS[@]}"; do
  if ! kubectl get pod "$pod-pod" -n $NAMESPACE >/dev/null 2>&1; then
    echo "❌ Pod $pod-pod no encontrado."
    exit 1
  fi

  STATUS=$(kubectl get pod "$pod-pod" -n $NAMESPACE -o jsonpath='{.status.phase}')
  READY=$(kubectl get pod "$pod-pod" -n $NAMESPACE -o jsonpath='{.status.containerStatuses[0].ready}')

  if [[ "$STATUS" == "Running" && "$READY" == "true" ]]; then
    echo "✅ $pod-pod está Running y Ready"
  else
    echo "❌ $pod-pod no está listo (STATUS=$STATUS, READY=$READY)"
    exit 1
  fi
done

echo -e "\n🔎 Verificando /etc/os-release en cada Pod..."
for pod in "${PODS[@]}"; do
  NAME=$(kubectl exec -n $NAMESPACE "$pod-pod" -- sh -c 'grep ^NAME= /etc/os-release' || true)
  if [[ -n "$NAME" ]]; then
    echo "✅ $pod-pod: $NAME"
  else
    echo "❌ No se pudo leer /etc/os-release en $pod-pod"
  fi
done

echo -e "\n🔎 Verificando instalación de editor (vim o nano)..."
for pod in "${PODS[@]}"; do
  if kubectl exec -n $NAMESPACE "$pod-pod" -- sh -c 'command -v vim || command -v nano' >/dev/null 2>&1; then
    echo "✅ $pod-pod tiene editor instalado"
  else
    echo "⚠️  $pod-pod no tiene editor (quizás no hicieron la actividad de paquetes)"
  fi
done

echo -e "\n🔎 Verificando creación de usuario 'estudiante'..."
for pod in "${PODS[@]}"; do
  if kubectl exec -n $NAMESPACE "$pod-pod" -- sh -c "grep '^estudiante:' /etc/passwd" >/dev/null 2>&1; then
    echo "✅ Usuario 'estudiante' existe en $pod-pod"
  else
    echo "⚠️  Usuario 'estudiante' NO encontrado en $pod-pod"
  fi
done

echo -e "\n🎉 Verificación finalizada."
