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

**1. Implementa en el flujo CI/CD un test de integración que verifique que la API efectivamente está exponiendo los datos de la base de datos. Argumenta.**

En el flujo CI/CD actual, una prueba clave de integración es verificar que la API despliega correctamente los datos almacenados en la base de datos. Esto es fundamental, ya que garantiza que la aplicación está cumpliendo su propósito principal: servir datos de forma accesible y correcta.

Implementación de prueba de integración:

La prueba debería consistir en ejecutar solicitudes a los endpoints de la API después de desplegar la aplicación en un entorno temporal o de desarrollo.
Se puede usar herramientas como pytest o Postman junto con newman para automatizar las pruebas de API.
El flujo CI/CD se puede integrar con servicios de testing como pytest ejecutando un script que haga peticiones HTTP GET y verifique las respuestas contra datos conocidos en la base de datos.

**2. Proponer otras pruebas de integración que validen que el sistema está funcionando correctamente y cómo se implementarían.**

Además de la prueba de exposición de datos de la API, otras pruebas de integración podrían incluir:

Prueba de autenticación y autorización: Verificar que el sistema de autenticación y los permisos de acceso a la API están funcionando correctamente. Esto podría incluir pruebas para asegurarse de que los usuarios no autenticados no puedan acceder a datos protegidos.

Prueba de inserción de datos: Asegurarse de que la API permite realizar inserciones en la base de datos de manera correcta. 

Prueba de consistencia de la base de datos: Validar que, después de realizar operaciones en la API (como POST, PUT o DELETE), la base de datos mantiene la consistencia de los datos. Esto implica realizar una operación y luego verificar que la base de datos refleja el cambio esperado.

**3. Identificar posibles puntos críticos del sistema (a nivel de fallo o performance) diferentes al punto anterior y proponer formas de testearlos o medirlos.**

Algunos puntos críticos que podrían ser un problema en el sistema:

Latencia y rendimiento de la API: En producción, la API podría experimentar problemas de rendimiento debido a la carga o la complejidad de las consultas a la base de datos.

Cómo medirlo: Utilizar herramientas como Locust o Apache JMeter para realizar pruebas de carga y medir la latencia de las respuestas. De esta manera, podrías simular múltiples usuarios accediendo a la API y medir cómo afecta el rendimiento.
Test de estrés: Medir cómo se comporta el sistema bajo una carga extrema y observar en qué punto la API empieza a fallar o degradar su rendimiento.
Escalabilidad del servicio: Dependiendo de la cantidad de datos o tráfico, la escalabilidad de la API puede convertirse en un problema.

Cómo medirlo: Simular un aumento progresivo de tráfico utilizando herramientas de pruebas de carga. Observar en qué momento los tiempos de respuesta se vuelven inaceptables o cuándo comienzan a ocurrir fallos.
Errores en la interacción con servicios externos (e.g., Google Cloud Storage): Si el sistema depende de servicios externos como Google Cloud, los errores en la conectividad o problemas de red pueden causar fallos en la aplicación.

Cómo medirlo: Implementar pruebas que simulen fallos en la conexión con servicios externos. Usar mocking en las pruebas para simular respuestas de error del servicio de Google Cloud y observar cómo responde la aplicación.

**4. Proponer cómo robustecer técnicamente el sistema para compensar o solucionar dichos puntos críticos.**

Uso de caché: Para reducir la carga en la base de datos y mejorar la latencia, podrías implementar un sistema de caché (como Redis o Memcached) para almacenar temporalmente las respuestas de la API más solicitadas.

Autoescalado: Configurar el autoescalado en Google Cloud Run o Kubernetes (si el sistema lo permite) para garantizar que la API puede manejar incrementos en la carga. Esto ayudaría a prevenir tiempos de inactividad en momentos de alto tráfico.

Monitoreo y alertas: Implementar un sistema de monitoreo (como Prometheus + Grafana o Stackdriver) que te permita observar métricas clave del rendimiento de la API (tiempos de respuesta, uso de CPU, uso de memoria) y configurar alertas para detectar problemas antes de que afecten a los usuarios.

Implementación de Circuit Breaker: En caso de dependencias con servicios externos, un patrón de "circuit breaker" puede ayudar a que la API degrade su servicio de manera controlada en lugar de fallar completamente cuando un servicio externo no esté disponible.

**Parte 4: Métricas y Monitoreo**
1. Proponer 3 métricas (además de las básicas CPU/RAM/DISK USAGE) críticas para entender la salud y rendimiento del sistema end-to-end
2. Proponer una herramienta de visualización y describe textualmente qué métricas mostraría, y cómo esta información nos permitiría entender la salud del sistema para tomar decisiones estratégicas
3. Describe a grandes rasgos cómo sería la implementación de esta herramienta en la nube y cómo esta recolectaría las métricas del sistema
4. Describe cómo cambiará la visualización si escalamos la solución a 50 sistemas similares y qué otras métricas o formas de visualización nos permite desbloquear este escalamiento.
5. Comenta qué dificultades o limitaciones podrían surgir a nivel de observabilidad de los sistemas de no abordarse correctamente el problema de escalabilidad

**Comentarios:**
**No se requiere implementación**

**Parte 5: Alertas y SRE (Opcional)**
1. Define específicamente qué reglas o umbrales utilizarías para las métricas propuestas, de manera que se disparan alertas al equipo al decaer la performance del sistema. Argumenta.
2. Define métricas SLIs para los servicios del sistema y un SLO para cada uno de los SLIs. Argumenta por qué escogiste esos SLIs/SLOs y por qué desechaste otras métricas para utilizarlas dentro de la definición de SLIs.
**Comentarios:**
**No se requiere implementación**


