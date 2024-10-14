# PubSub Module

Este ejemplo muestra en que consiste el modulo `pubsub`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| topic\_name | El nombre del topico a crear | `string` | n/a | yes |
| subscription\_name | Nombre de la subscripcion al topico | `string` | n/a | yes |
| project\_id | id del proyecto en gcp | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| pubsub\_topic\_id | identificador del dataset creado |
| pubsub\_subscription\_id | identificador de la tabla creada |

## Requirements

Esta seccion muestra los requerimientos para el uso de este modulo.

### Software

The following dependencies must be available:

- [Terraform](https://www.terraform.io/downloads.html) >= Terraform v1.9.7
