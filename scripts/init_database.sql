/*
Create Database and Schemas

Script Purpose:
  This script creates a new database named "DataWarehouse" after checking if it already exists.
  If the database exists, it is dropped and recreated.
  It also creates three schemas:
    - bronze
    - silver
    - gold

WARNING:
  Running this script will permanently delete the existing
  DataWarehouse database and all its data.
*/

/*-------------------------------------------------------
Step 1: Connect to the default database (postgres)
-------------------------------------------------------*/

-- Terminate all active connections to DataWarehouse
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'DataWarehouse'
  AND pid <> pg_backend_pid();

-- Drop the database if it exists
DROP DATABASE IF EXISTS "DataWarehouse";

-- Create a new database
CREATE DATABASE "DataWarehouse";

\c "DataWarehouse"

-- Create Schemas

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE SCHEMA IF NOT EXISTS silver;

CREATE SCHEMA IF NOT EXISTS gold;
