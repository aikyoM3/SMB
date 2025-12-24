-- Initialize Authentication Service Database
CREATE DATABASE IF NOT EXISTS db_user_new_devs_nours;
USE db_user_new_devs_nours;

-- Create roles table if it doesn't exist
-- Note: JPA/Hibernate will also create tables, but this ensures they exist for initial data
CREATE TABLE IF NOT EXISTS roles (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create users table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    place_of_birth VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    gender VARCHAR(50) NOT NULL,
    cin VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    password_need_to_be_modified BOOLEAN NOT NULL DEFAULT FALSE,
    last_login DATETIME(6),
    create_by VARCHAR(255),
    created_date DATETIME(6),
    last_modified_by VARCHAR(255),
    last_modified_date DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user_roles join table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_roles (
    user_id VARCHAR(255) NOT NULL,
    role_id VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Note: User creation with proper password hashing is handled by the Authentication Service
-- This script only ensures tables exist for the service to work with
