from diagrams import Diagram, Cluster, Edge
from diagrams.gcp.compute import Run
from diagrams.gcp.analytics import Bigquery, Pubsub
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.iac import Terraform


if __name__ == "__main__":
	with Diagram("Arquitectura con Pub/Sub, BigQuery y Cloud Run", show=True):
		# Cluster de GitHub y GitHub Actions
		with Cluster("CI/CD"):
			github = Github("GitHub")
			actions = GithubActions("GitHub Actions")

		# Cluster para Infraestructura gestionada con Terraform
		with Cluster("Infraestructura"):
			terraform = Terraform("Terraform")
			cloud_run = Run("Cloud Run")
			pubsub = Pubsub("Pub/Sub Topic")
			subscription = Pubsub("Pub/Sub Subscription")
			bigquery = Bigquery("BigQuery Dataset")

		# GitHub Actions construye y despliega la aplicación en Cloud Run
		github >> actions >> cloud_run

		# Terraform provisiona los recursos
		terraform >> pubsub
		terraform >> subscription
		terraform >> bigquery
		terraform >> cloud_run

		# API en Cloud Run publica mensajes a Pub/Sub
		cloud_run >> pubsub

		# Pub/Sub Subscription carga los datos en BigQuery
		subscription >> bigquery

		# El usuario interactúa con la API en Cloud Run
		cloud_run << Edge(label="Usuario/API") << Edge(label="Consulta de Datos", color="blue") << bigquery
