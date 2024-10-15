# Challenge DevSecOps/SRE
​
## Descripción General
En Advanced Analytics se construyen productos de datos que al ser consumidos añaden valor a diferentes áreas de nuestra aerolínea. Los servicios exhiben datos obtenidos por procesos de analítica mediante APIs, tablas y procesos recurrentes. Uno de los principales pilares de nuestra cultura es la resiliencia y calidad de lo que construimos. Esto nos permite preservar la correcta operación de nuestros servicios y no deteriorar el valor añadido hacia el resto de áreas.​
## Instrucciones de entrega:
1. Enviar un POST request tipo JSON al endpoint: https://advana-challenge-check-api-cr-k4hdbggvoq-uc.a.run.app/devops con tu nombre, mail y repositorio git:
2. Se aceptarán cambios en el repositorio hasta el día especificado en el e-mail junto a este desafío.
```json
    {
      "name": "Pedro Picapiedra",
      "mail": "Pedro.picapiedra@example.com",
      "github_url": "https://github.com/ppicapiedra/latam-challenge.git"
    }
```

3. El plazo máximo de entrega del challenge son **4 días corridos completos** a partir de la recepción del challenge.
   Por ejemplo: Si recibiste el challenge el día jueves 21 de Septiembre a las 3 pm, tienes plazo hasta el martes 26 de septiembre a las 23:59.
Siguiendo la logica del correo, en este caso el plazo maximo seria el lunes 14 de Octubre a las 23:59, ya que fue recibido el miercoles.

## Instrucciones previas
1) Utiliza un repositorio público de git para resolver el desafío (GitHub, BitBucket, GitLab, etc).
2) Utiliza una rama master y otra develop al resolver el problema. Opcionalmente, utilizar alguna práctica de desarrollo de GitFlow.
3) En el repositorio deben estar todos los archivos utilizados para la resolución del desafío.
4) Ten en cuenta que nuestro lenguaje preferido es Python. De todas formas, usa el que más te acomode.
5) Escribe un README.md para responder cada punto del desafío. Escribe supuestos y cualquier comentario que nos ayude a entender tu solución y tu forma de resolver el problema.
6) Utiliza cualquier buena práctica que consideres en el repositorio, código o flujo de desarrollo para demostrar tu conocimiento.
7) No necesitas resolver por completo ni a la perfección el desafío, pero te recomendamos detallar claramente en el .md cómo mejorar cada parte de tu ejercicio en caso de que tenga opción de mejora o no te haya dado el tiempo para resolverlo como te hubiese gustado. Lo importante es demostrar tus conocimientos.

​
## Desafío Técnico DevSecOps/SRE
### Contexto
Se requiere un sistema para ingestar y almacenar datos en una DB con la finalidad de hacer analítica avanzada. Posteriormente, los datos almacenados deben ser expuestos mediante una API HTTP para que puedan ser consumidos por terceros.
### Objetivo
Desarrollar un sistema en la nube para ingestar, almacenar y exponer datos mediante el uso de IaC y despliegue con flujos CI/CD. Hacer pruebas de calidad, monitoreo y alertas para asegurar y monitorear la salud del sistema.
Tu desafío debe tener al menos 6 archivos python en la carpeta `src`. Cada uno de estos archivos correspondiente a la función del mismo nombre, con el mismo formato que se indica en las instrucciones de más abajo. Solo deja la función. Además de eso, debes tener un archivo `.ipynb` donde expliques con mayor claridad tu código. En este jupyter notebook puedes ejecutar tus funciones, medir el tiempo de ejecución, memoria en uso y explayarte según estimes conveniente. Te recomendamos fuertemente que utilices celdas markdown para que expliques el paso a paso de tu código.

**Parte 1:Infraestructura e IaC**
1. Identificar la infraestructura necesaria para ingestar, almacenar y exponer datos:
a. Utilizar el esquema Pub/Sub (no confundir con servicio Pub/Sub de Google)
para ingesta de datos
b. Base de datos para el almacenamiento enfocado en analítica de datos
c. Endpoint HTTP para servir parte de los datos almacenados
2. (Opcional) Deployar infraestructura mediante Terraform de la manera que más te acomode.
   Incluir código fuente Terraform.
   No requiere pipeline CI/CD.
   
**Comentarios:**

**- La estructura de datos no es relevante para el problema, asume cualquiera.**

**- Existen múltiples formas de resolver el problema y escoger la infraestructura, recomendamos
simplicidad.**


**Parte 2: Aplicaciones y flujo CI/CD**
1. API HTTP: Levantar un endpoint HTTP con lógica que lea datos de base de datos y los exponga al recibir una petición GET
2. Deployar API HTTP en la nube mediante CI/CD a tu elección. Flujo CI/CD y ejecuciones deben estar visibles en el repositorio git.
3. (Opcional) Ingesta: Agregar suscripción al sistema Pub/Sub con lógica para ingresar los datos recibidos a la base de datos. El objetivo es que los mensajes recibidos en un tópico se guarden en la base de datos. No requiere CI/CD.
4. Incluye un diagrama de arquitectura con la infraestructura del punto 1.1 y su interacción con los servicios/aplicaciones que demuestra el proceso end-to-end de ingesta hasta el consumo por la API HTTP

**Comentarios:**

**- Recomendamos usar un servicio serverless mediante Dockerfile para optimizar el tiempo de
desarrollo y deployment para la API HTTP.**

**- Es posible que lógica de ingesta se incluya nativamente por tu servicio en la nube. De ser así,
solo comentar cómo funciona.**

**- Al ser 1.3 opcional, el flujo de ingesta de datos quedará incompleto, está bien.**

**- Para el punto 1.4 no se requiere un diagrama profesional ni que siga ningún estándar de
diagramas en específico.**

### Arquitectura Propuesta para el Flujo de Datos

**Usuario/API → Cloud Run (API Docker) → Tópico de Pub/Sub:**

La API que se ejecuta en Cloud Run recibe una petición para publicar datos en el tópico de Pub/Sub.

**Tópico de Pub/Sub → Suscripción de Pub/Sub → BigQuery:**

La suscripción extrae los mensajes del tópico y los carga automáticamente en un conjunto de datos y tabla de BigQuery.

**Usuario/API → Cloud Run (API Docker) → BigQuery:**

La API también ofrece un endpoint para recuperar y exponer los datos almacenados en BigQuery.

**CI/CD:**

El código fuente está almacenado en GitHub, y GitHub Actions gestiona automáticamente la compilación y el despliegue de la imagen Docker a Cloud Run, con la infraestructura aprovisionada mediante Terraform.

![Diagrama de produccion y consumo de datos](/images/Diagrama.png)



**Parte 3: Pruebas de Integración y Puntos Críticos de Calidad**
1. Implementa en el flujo CI/CD en test de integración que verifique que la API efectivamente está exponiendo los datos de la base de datos. Argumenta.
2. Proponer otras pruebas de integración que validen que el sistema está funcionando correctamente y cómo se implementarían.
3. Identificar posibles puntos críticos del sistema (a nivel de fallo o performance) diferentes al punto anterior y proponer formas de testearlos o medirlos (no implementar)
4. Proponer cómo robustecer técnicamente el sistema para compensar o solucionar dichos puntos críticos.

**Comentarios:**
**Los test de integración no necesariamente deben cubrir todos los casos de uso.**

### 1. Implementar test de integración en CI/CD para verificar que la API expone datos de la base de datos:
- **Prueba de integración**: Crear un test automatizado que haga una solicitud `GET` a la API y verifique que los datos obtenidos son correctos y coherentes con los datos de la base de datos.
- **Argumento**: Esta prueba asegura que la API puede comunicarse correctamente con la base de datos y que los datos se están exponiendo adecuadamente. Un fallo en esta prueba indicaría problemas en la capa de datos o en la lógica de negocio.

### 2. Proponer otras pruebas de integración:
- **Prueba de autenticación**: Verificar que los usuarios autenticados pueden acceder a los endpoints protegidos y que los usuarios no autenticados reciben respuestas de error adecuadas (p. ej., 401).
  - **Implementación**: Realizar una solicitud autenticada (con token válido) y una no autenticada, verificando las respuestas.
  
- **Prueba de inserción de datos**: Verificar que la API permite realizar inserciones en la base de datos correctamente.
  - **Implementación**: Realizar un `POST` con datos válidos y verificar que estos se almacenan correctamente.

- **Prueba de consistencia de datos**: Tras realizar una operación (e.g., `DELETE`), verificar que la base de datos refleja el cambio esperado.
  - **Implementación**: Eliminar un dato y luego hacer un `GET` para asegurar que el dato ya no está disponible.

### 3. Identificar posibles puntos críticos del sistema y cómo testearlos o medirlos:
- **Latencia de la API**: Un aumento en la latencia puede indicar problemas de rendimiento en el backend o en la base de datos.
  - **Cómo medirlo**: Usar herramientas como `Locust` para realizar pruebas de carga y medir la latencia de las respuestas bajo diferentes niveles de tráfico.

- **Fallo en servicios externos (e.g., almacenamiento en Google Cloud)**: Dependencias de servicios externos pueden causar fallos o tiempos de espera elevados.
  - **Cómo medirlo**: Simular fallos en los servicios externos (e.g., Google Cloud Storage) usando `mocking` para verificar cómo responde el sistema.

- **Escalabilidad bajo alta carga**: A medida que el tráfico aumenta, el sistema puede volverse inestable si no está configurado para escalar adecuadamente.
  - **Cómo medirlo**: Usar pruebas de estrés para aumentar gradualmente el tráfico y observar en qué punto la API comienza a fallar o degradar su rendimiento.

### 4. Proponer cómo robustecer técnicamente el sistema:
- **Implementación de caché**: Utilizar un sistema de caché (como Redis) para almacenar respuestas de las API más solicitadas, reduciendo la carga en la base de datos.
  
- **Autoescalado**: Configurar autoescalado en la infraestructura de la API (Cloud Run o Kubernetes) para manejar aumentos de tráfico de forma automática, evitando saturaciones.

- **Monitoreo proactivo**: Implementar monitoreo con Prometheus para rastrear métricas clave (latencia, errores, uso de recursos) y configurar alertas para que el equipo sea notificado antes de que se afecte la disponibilidad.

- **Uso de patrones de resiliencia**: Aplicar patrones como "circuit breaker" para manejar fallos en servicios externos, evitando que un fallo en un servicio crítico afecte a toda la aplicación.


**Parte 4: Métricas y Monitoreo**
1. Proponer 3 métricas (además de las básicas CPU/RAM/DISK USAGE) críticas para entender la salud y rendimiento del sistema end-to-end
2. Proponer una herramienta de visualización y describe textualmente qué métricas mostraría, y cómo esta información nos permitiría entender la salud del sistema para tomar decisiones estratégicas
3. Describe a grandes rasgos cómo sería la implementación de esta herramienta en la nube y cómo esta recolectaría las métricas del sistema
4. Describe cómo cambiará la visualización si escalamos la solución a 50 sistemas similares y qué otras métricas o formas de visualización nos permite desbloquear este escalamiento.
5. Comenta qué dificultades o limitaciones podrían surgir a nivel de observabilidad de los sistemas de no abordarse correctamente el problema de escalabilidad

### 1. Proponer 3 métricas críticas (además de las básicas CPU/RAM/DISK USAGE) para entender la salud y rendimiento del sistema end-to-end:
- **Latencia de respuesta de la API**: Indica el tiempo que tarda la API en procesar una solicitud y devolver una respuesta. Valores elevados pueden revelar cuellos de botella en el sistema.
- **Errores de API (5xx, 4xx)**: Un aumento en estos errores puede reflejar problemas con la aplicación o con servicios externos.
- **Tasa de solicitudes por segundo (RPS)**: Mide la cantidad de solicitudes que el sistema está manejando por segundo, ayudando a evaluar la carga y capacidad de respuesta.

### 2. Proponer una herramienta de visualización y describir qué métricas mostraría:
- **Herramienta**: Grafana + Prometheus.
- **Métricas a mostrar**:
  - Latencia de la API en tiempo real.
  - Tasa de errores (5xx y 4xx) por endpoint.
  - Tasa de solicitudes por segundo (RPS) agregada y por endpoint.
- **Interpretación**: La combinación de estas métricas permite identificar rápidamente problemas de rendimiento (latencia alta), sobrecarga (elevada tasa de RPS), y fallos sistémicos (errores 5xx) que requieren intervención.

### 3. Descripción de la implementación en la nube:
- **Infraestructura**: Prometheus recolectaría métricas de los servicios usando endpoints de monitoreo (e.g., `/metrics` en la API) o integraciones nativas en GCP. Grafana se utilizaría para visualizar y crear dashboards personalizados con las métricas recolectadas.
- **Recolección de métricas**: Prometheus haría scrapes periódicos de las aplicaciones, contenedores, y bases de datos, recolectando datos sobre rendimiento y salud del sistema.

### 4. Cambio en la visualización al escalar a 50 sistemas similares:
- **Nuevas visualizaciones**: Al escalar a 50 sistemas, agregaríamos gráficos agregados y desglosados por sistema. También incluiríamos:
  - Promedios y percentiles de latencia.
  - Comparativa de errores por sistema.
  - Heatmaps de utilización de recursos entre los diferentes sistemas.
- **Desbloqueo**: Se podrían habilitar alertas basadas en anomalías detectadas al comparar el rendimiento de múltiples sistemas, facilitando una identificación rápida de outliers.

### 5. Dificultades o limitaciones en la observabilidad si no se aborda correctamente la escalabilidad:
- **Limitaciones**:
  - **Sobrecarga en la recolección de métricas**: Con 50 sistemas, Prometheus podría experimentar dificultades para mantener los tiempos de scraping o almacenar grandes volúmenes de datos.
  - **Alertas ruidosas**: Un mal diseño del sistema de alertas puede generar alertas falsas o innecesarias, dificultando la identificación de problemas reales.
  - **Cuellos de botella en la infraestructura**: Al no gestionar correctamente la escalabilidad de los sistemas de observabilidad, se puede introducir un cuello de botella en el propio sistema de monitoreo, impidiendo su correcto funcionamiento en entornos distribuidos y de gran escala.


**Comentarios:**
**No se requiere implementación**

**Parte 5: Alertas y SRE (Opcional)**
1. Define específicamente qué reglas o umbrales utilizarías para las métricas propuestas, de manera que se disparan alertas al equipo al decaer la performance del sistema. Argumenta.
2. Define métricas SLIs para los servicios del sistema y un SLO para cada uno de los SLIs. Argumenta por qué escogiste esos SLIs/SLOs y por qué desechaste otras métricas para utilizarlas dentro de la definición de SLIs.
**Comentarios:**
**No se requiere implementación**
   
### 1. Reglas o umbrales para disparar alertas al decaer la performance del sistema:
- **Latencia de respuesta de la API**:
  - **Umbral de alerta crítica**: Si la latencia media supera los 500 ms en 95% de las solicitudes en un intervalo de 5 minutos.
  - **Justificación**: La latencia alta afecta directamente la experiencia del usuario y puede indicar problemas de rendimiento o sobrecarga en la infraestructura.
  
- **Errores de API (5xx, 4xx)**:
  - **Umbral de alerta crítica**: Si la tasa de errores 5xx supera el 2% de las solicitudes totales en 1 minuto.
  - **Alerta de advertencia**: Si la tasa de errores 4xx supera el 5% durante un período de 5 minutos.
  - **Justificación**: Un aumento en errores 5xx refleja fallos graves en el backend, mientras que los 4xx indican problemas con solicitudes de los usuarios o mal uso del API.

- **Tasa de solicitudes por segundo (RPS)**:
  - **Umbral de alerta**: Si el RPS aumenta más del 20% en un intervalo de 1 minuto en comparación con el promedio de las últimas 24 horas.
  - **Justificación**: Un aumento brusco en el RPS puede saturar el sistema y causar fallos si no se escala adecuadamente.

### 2. Definir métricas SLIs y SLOs:
- **SLI (Latencia de la API)**: Tiempo promedio de respuesta de la API en solicitudes exitosas (p95).
  - **SLO**: El 95% de las solicitudes deben tener una latencia inferior a 300 ms durante un período de 30 días.
  - **Justificación**: La latencia es una métrica crítica que afecta directamente la experiencia del usuario. Se seleccionó el percentil 95 para capturar los peores casos, descartando el percentil 100 para evitar outliers extremos que puedan distorsionar el análisis.

- **SLI (Tasa de errores 5xx)**: Porcentaje de respuestas con código 5xx sobre el total de solicitudes.
  - **SLO**: Mantener la tasa de errores 5xx por debajo del 1% en un período de 30 días.
  - **Justificación**: Los errores 5xx son indicativos de problemas en el servidor y afectan seriamente la disponibilidad del servicio. Se excluyeron los errores 4xx, ya que no son fallos del sistema, sino de las solicitudes del usuario.

- **SLI (Disponibilidad del servicio)**: Porcentaje de tiempo que el servicio está disponible y responde correctamente (sin fallos 5xx).
  - **SLO**: Mantener una disponibilidad del 99.9% en un período mensual.
  - **Justificación**: La disponibilidad es una métrica clave para asegurar la fiabilidad del servicio. Se descartaron otras métricas como el uso de recursos (CPU/RAM), ya que estas afectan indirectamente la experiencia del usuario y no son tan críticas para medir la salud general del sistema.

Estas métricas permiten una visión clara y accionable de los problemas de rendimiento y estabilidad del sistema, enfocándose en lo que realmente impacta la experiencia del usuario.



