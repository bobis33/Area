# EPITECH | B-DEV-500 | AREA

![Epitech_banner](assets/Epitech_banner.png)

## Introduction

The AREA project is a project that aims to create a platform that allows users to create and manage their own automation scenarios. The platform is composed of three main parts:
- A backend that manages the user's data and the automation scenarios.
- A web frontend that allows users to create and manage their automation scenarios.
- A mobile frontend that allows users to create and manage their automation scenarios.

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)

You will have to create a `.env` file at the root of each service and copy the content of the `.env.example` file in it.
You will have to fill the variables with your own values. For more information, please refer to the documentation of each service.

### Launch

```bash
sudo docker-compose up --build
```
> You should down the container before relaunching it with the following command:

```bash
sudo docker-compose down
```

For more information, please refer to the documentation of each service:
- [Backend](back/README.md)
- [Frontend-web](front/web/README.md)
- [Frontend-mobile](front/mobile/README.md)

## Commit Norms

| Commit Type | Description                                                                                                               |
|:------------|:--------------------------------------------------------------------------------------------------------------------------|
| build       | Changes that affect the build system or external dependencies (npm, make, etc.)                                           |
| ci          | Changes related to integration files and scripts or configuration (Travis, Ansible, BrowserStack, etc.)                   |
| feat        | Addition of a new feature                                                                                                 |
| fix         | Bug fix                                                                                                                   |
| perf        | Performance improvements                                                                                                  |
| refactor    | Modification that neither adds a new feature nor improves performance                                                     |
| style       | Change that does not affect functionality or semantics (indentation, formatting, adding space, renaming a variable, etc.) |
| docs        | Writing or updating documentation                                                                                         |
| test        | Addition or modification of tests                                                                                         |
