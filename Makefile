KIND_CLUSTER_NAME = oslab
NAMESPACE = os-lab
PODS_DIR = pods

all: help

cluster-up:
	kind create cluster --name $(KIND_CLUSTER_NAME)
	kubectl create namespace $(NAMESPACE)

cluster-down:
	kind delete cluster --name $(KIND_CLUSTER_NAME)

deploy:
	kubectl apply -k $(PODS_DIR)

verify:
	kubectl get pods -n $(NAMESPACE) -o wide
	kubectl wait --for=condition=Ready pod --all -n $(NAMESPACE) --timeout=120s

ubuntu:
	kubectl exec -it -n $(NAMESPACE) ubuntu-pod -- bash

debian:
	kubectl exec -it -n $(NAMESPACE) debian-pod -- bash

alpine:
	kubectl exec -it -n $(NAMESPACE) alpine-pod -- sh

centos:
	kubectl exec -it -n $(NAMESPACE) centos-pod -- bash

kali:
	kubectl exec -it -n $(NAMESPACE) kali-pod -- bash

lab:
	@for pod in ubuntu debian alpine centos kali; \
	do \
	  echo ">> Probando $$pod..."; \
	  kubectl exec -n $(NAMESPACE) -it $$pod-pod -- sh -c 'cat /etc/os-release | grep ^NAME='; \
	done

clean:
	kubectl delete -k $(PODS_DIR)

help:
	@echo "Comandos disponibles:"
	@echo "  make cluster-up      -> Crear clúster kind y namespace"
	@echo "  make deploy          -> Desplegar todos los Pods"
	@echo "  make verify          -> Verificar estado de Pods"
	@echo "  make lab             -> Ejecutar smoke test en todas las distros"
	@echo "  make ubuntu/debian/alpine/centos/kali -> Acceso interactivo a cada Pod"
	@echo "  make clean           -> Borrar Pods del laboratorio"
	@echo "  make cluster-down    -> Eliminar el clúster kind"
