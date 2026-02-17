# Infrastructure as Code - API Franquicias

Este directorio contiene la infraestructura como código (IaC) para desplegar la API de Franquicias en AWS usando Terraform.

## Arquitectura

La infraestructura incluye:

- **VPC**: Red virtual con subnets públicas y privadas
- **ECS Fargate**: Servicio de contenedores sin servidores
- **Application Load Balancer**: Balanceador de carga para distribuir tráfico
- **API Gateway**: Gateway HTTP para exponer la API
- **ECR**: Repositorio para imágenes Docker
- **Secrets Manager**: Almacenamiento seguro de credenciales
- **CloudWatch**: Logs y monitoreo
- **IAM Roles**: Roles y políticas necesarias
- **Auto Scaling**: Escalado automático basado en CPU y memoria

## Requisitos Previos

1. **Terraform** >= 1.0 instalado
2. **AWS CLI** configurado con credenciales
3. **Cuenta de AWS** con permisos adecuados

## Configuración

1. Copia el archivo de ejemplo de variables:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edita `terraform.tfvars` con tus valores específicos:
   - Región de AWS
   - Credenciales de MongoDB
   - Configuración de recursos (CPU, memoria, etc.)

3. Inicializa Terraform:
   ```bash
   terraform init
   ```

4. Revisa el plan de ejecución:
   ```bash
   terraform plan
   ```

5. Aplica la infraestructura:
   ```bash
   terraform apply
   ```

## Variables Importantes

- `aws_region`: Región donde se desplegarán los recursos
- `environment`: Ambiente (dev, staging, prod)
- `mongodb_host`, `mongodb_username`, `mongodb_password`: Credenciales de MongoDB
- `container_cpu`, `container_memory`: Recursos del contenedor
- `desired_count`: Número inicial de instancias
- `min_capacity`, `max_capacity`: Límites de auto-scaling
- `enable_nat_gateway`: Habilitar NAT Gateway (true por defecto, costoso ~$64/mes)
- `enable_container_health_check`: Habilitar health check del contenedor (false por defecto)

## Despliegue de la Aplicación

Después de crear la infraestructura:

1. Construye y etiqueta tu imagen Docker:
   ```bash
   docker build -t api-franquicias .
   docker tag api-franquicias:latest <ECR_REPOSITORY_URL>:latest
   ```

2. Autentica Docker con ECR:
   ```bash
   aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <ECR_REPOSITORY_URL>
   ```

3. Sube la imagen:
   ```bash
   docker push <ECR_REPOSITORY_URL>:latest
   ```

4. El servicio ECS detectará automáticamente la nueva imagen y actualizará las tareas.

## URLs Importantes

Después del despliegue, obtén las URLs con:
```bash
terraform output
```

- **API Gateway URL**: Endpoint principal de la API
- **ALB DNS**: DNS del balanceador de carga (acceso directo)

## Estructura de Archivos

- `main.tf`: Configuración principal y proveedor AWS
- `variables.tf`: Variables configurables
- `vpc.tf`: Red VPC, subnets y security groups
- `ecs.tf`: Cluster ECS, servicio y task definition
- `api_gateway.tf`: API Gateway HTTP
- `iam.tf`: Roles y políticas IAM
- `ecr.tf`: Repositorio ECR
- `secrets.tf`: Secrets Manager para credenciales
- `outputs.tf`: Valores de salida
- `terraform.tfvars.example`: Plantilla de variables

## Destrucción de Recursos

Para eliminar toda la infraestructura:
```bash
terraform destroy
```

**⚠️ ADVERTENCIA**: Esto eliminará todos los recursos creados, incluyendo datos almacenados.

## Notas

- Las credenciales de MongoDB se almacenan en AWS Secrets Manager de forma segura
- El auto-scaling está configurado para escalar basado en CPU (70%) y memoria (80%)
- Los logs se almacenan en CloudWatch con retención de 7 días
- El API Gateway está configurado con CORS habilitado para todos los orígenes (ajusta según necesidad)

## Optimización de Costos para Pruebas

Para reducir costos en una cuenta de prueba:

1. **Deshabilitar NAT Gateway**: Cambia `enable_nat_gateway = false` en `terraform.tfvars`
   - Ahorra ~$64/mes
   - Los contenedores ECS se ejecutarán en subnets públicas (aceptable para pruebas)

2. **Reducir instancias**: Cambia `desired_count = 1` y `min_capacity = 1`

3. **Health Check**: Mantén `enable_container_health_check = false` a menos que tu imagen tenga wget/curl

Ver `CHECKS.md` para más detalles sobre costos y configuración.
