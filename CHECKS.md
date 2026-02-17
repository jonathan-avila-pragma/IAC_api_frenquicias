# Checklist Pre-Despliegue

Antes de ejecutar `terraform apply`, verifica lo siguiente:

## ✅ Requisitos Previos

- [ ] Terraform >= 1.0 instalado (`terraform version`)
- [ ] AWS CLI configurado (`aws configure`)
- [ ] Credenciales de AWS con permisos adecuados
- [ ] Cuenta de AWS activa con límites adecuados

## ✅ Configuración

- [ ] Archivo `terraform.tfvars` creado desde `terraform.tfvars.example`
- [ ] Variables completadas en `terraform.tfvars`:
  - [ ] `aws_region` configurada
  - [ ] `environment` configurado (dev/staging/prod)
  - [ ] `mongodb_host` configurado
  - [ ] `mongodb_username` configurado
  - [ ] `mongodb_password` configurado
  - [ ] `mongodb_database` configurado

## ✅ Recursos que se Crearán

### Red
- [x] VPC nueva
- [x] 2 Subnets públicas (una por AZ)
- [x] 2 Subnets privadas (una por AZ)
- [x] Internet Gateway
- [x] NAT Gateways (2, uno por AZ) - **Costoso (~$32/mes cada uno)**
- [x] Route Tables
- [x] Security Groups

### Computación
- [x] Cluster ECS
- [x] Task Definition
- [x] Servicio ECS
- [x] Application Load Balancer
- [x] Target Group

### Contenedores
- [x] Repositorio ECR
- [x] CloudWatch Log Groups

### API
- [x] API Gateway HTTP
- [x] VPC Link
- [x] Stage y rutas

### Seguridad
- [x] Secrets Manager (credenciales MongoDB)
- [x] IAM Roles (ECS Task Execution, ECS Task, API Gateway)
- [x] IAM Policies

### Escalado
- [x] Auto Scaling Target
- [x] Auto Scaling Policies (CPU y Memoria)

## ⚠️ Costos Estimados (Mensual)

Para una cuenta nueva/prueba:

- **NAT Gateway**: ~$32/mes cada uno (2 = ~$64/mes) - Puedes deshabilitar con `enable_nat_gateway = false`
- **ALB**: ~$16/mes + uso de datos
- **ECS Fargate**: ~$0.04/hora por tarea (512 CPU, 1GB RAM) = ~$29/mes por tarea
- **ECR**: Gratis hasta 500MB/mes
- **API Gateway**: Primer millón de requests gratis, luego $3.50/millón
- **CloudWatch**: Primeros 5GB gratis
- **Secrets Manager**: $0.40/secret/mes

**Total estimado**: ~$110-150/mes (con 2 tareas ECS y NAT Gateways habilitados)

Para reducir costos en pruebas:
- Deshabilita NAT Gateway: `enable_nat_gateway = false` (los contenedores necesitarán estar en subnets públicas)
- Reduce `desired_count` a 1
- Reduce `min_capacity` y `max_capacity` del auto-scaling

## 🔧 Comandos Útiles

```bash
# Inicializar Terraform
terraform init

# Validar configuración
terraform validate

# Ver plan de ejecución
terraform plan

# Aplicar cambios
terraform apply

# Ver outputs después del despliegue
terraform output

# Destruir todo (¡cuidado!)
terraform destroy
```

## 📝 Notas Importantes

1. **NAT Gateway**: Si deshabilitas los NAT Gateways, los contenedores ECS deben estar en subnets públicas (`assign_public_ip = true`). Esto es aceptable para pruebas pero menos seguro para producción.

2. **Health Check**: El health check del contenedor está deshabilitado por defecto (`enable_container_health_check = false`). Habilítalo solo si tu imagen Docker tiene `wget` o `curl` instalado.

3. **Imagen Docker**: Asegúrate de tener una imagen Docker construida y subida a ECR antes de que el servicio ECS intente ejecutarla.

4. **Secrets Manager**: Las credenciales se almacenan de forma segura. Asegúrate de que el secreto se crea correctamente antes de ejecutar el servicio ECS.

5. **VPC Link**: Puede tardar hasta 10 minutos en establecerse. Ten paciencia durante el primer despliegue.

## 🚀 Después del Despliegue

1. Obtén la URL del API Gateway: `terraform output api_gateway_url`
2. Obtén la URL del ALB: `terraform output alb_dns_name`
3. Verifica los logs en CloudWatch: `/ecs/api-franquicias`
4. Verifica el estado del servicio ECS en la consola de AWS
