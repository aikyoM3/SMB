-- Initialize Customer Service Database
CREATE DATABASE IF NOT EXISTS customer_db;
USE customer_db;

-- Create customers table if it doesn't exist
-- Note: JPA/Hibernate will also create tables, but this ensures they exist for initial data
CREATE TABLE IF NOT EXISTS customers (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    place_of_birth VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    gender VARCHAR(50) NOT NULL,
    cin VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_date DATETIME(6) NOT NULL,
    created_by VARCHAR(255),
    last_modified_date DATETIME(6),
    last_modified_by VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert dummy test data for load testing
INSERT IGNORE INTO customers (id, firstname, lastname, place_of_birth, date_of_birth, nationality, gender, cin, email, created_date, created_by)
VALUES 
('customer-001', 'John', 'Doe', 'New York', '1990-01-15', 'American', 'MALE', 'CIN123456', 'john.doe@example.com', NOW(), 'system'),
('customer-002', 'Jane', 'Smith', 'Los Angeles', '1985-03-22', 'American', 'FEMALE', 'CIN789012', 'jane.smith@example.com', NOW(), 'system'),
('customer-003', 'Bob', 'Johnson', 'Chicago', '1992-07-10', 'American', 'MALE', 'CIN345678', 'bob.johnson@example.com', NOW(), 'system'),
('customer-004', 'Alice', 'Williams', 'Houston', '1988-11-05', 'American', 'FEMALE', 'CIN456789', 'alice.williams@example.com', NOW(), 'system'),
('customer-005', 'Charlie', 'Brown', 'Phoenix', '1995-05-20', 'American', 'MALE', 'CIN567890', 'charlie.brown@example.com', NOW(), 'system');
