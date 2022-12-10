# Adventure Works Analytics

[**dbt docs**](https://cmpbj.github.io/dbt-adventureworks/)

## Description
---

This repository contains the code responsible for the T process of the ELT (Extract - Load - Transform), for the Adventure Work project of analytics.

In this project we have four mains data sources:

* SAP ERP
* Salesforce - CRM
* Google ANAlytics - Web Analytics
* Wordpress - Site

After the extraction and load (EL) process, the data is transformed using dbt, a framework that helps us to transform data in the data warehouse using SQL statements


### How to set up the enviroment
---
To start to work with dbt, we have to clone this repository and set up the work environment correctly. The first step is create a virtualenv

### Virtualenv

The first step is clone the project and create a virtualenv on the root folder of the project, this will isolete the work enviroment. The command to create the virtualenv is:

`virtualenv venv -p python3`

To activate the virtualenv, the command is:

`source venv/bin/activate`to linux

or:

`.\venv\Scripts\activate.bat` to windows

### Installing the required packages
---
The second step is install the required packages as listed in requirements.txt. To do this run the following command:

`pip install -r requirements.txt`

### Config profiles.yml
---
To configure your profiles.yml, after your dbt is already installed in your environment, you must access the dbt home directory (`~/.dbt/profiles.yml` or `C:\Users\your-user\.dbt \profiles.yml`)

See the documentation for more information about how to config your profiles.yml --> [dbt docs](https://docs.getdbt.com/reference/profiles.yml)

### Running the dbt
---
It is recommended to run a command which confirms that your profiles.yml and project have been set up correctly and your connection is ok. This can be done through:

`dbt debug`

If everything is working correctly, you can move on to transforming and loading the data.

The transform and load steps point to the production bench. Each project participant will have their personal schema for development.