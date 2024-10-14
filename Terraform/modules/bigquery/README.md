# Bigquery Module

Este ejemplo muestra en que consiste el modulo `bigquery`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | El project ID del challenge | `string` | n/a | yes |
| dataset\_id | Nombre del dataset en bigquery | `string` | n/a | yes |
| table\_id | Nombre de la tabla en bigquery | `string` | n/a | yes |
| region | Region de gcp en donde se disponibilizara | `string` | us-central | yes |

## Outputs

| Name | Description |
|------|-------------|
| bigquery\_dataset\_id | identificador del dataset creado |
| bigquery\_table\_id | identificador de la tabla creada |
| bigquery\_table\_name | nombre de la tabla creada |

## Requirements

Esta seccion muestra los requerimientos para el uso de este modulo.

### Software

The following dependencies must be available:

- [Terraform](https://www.terraform.io/downloads.html) >= Terraform v1.9.7
