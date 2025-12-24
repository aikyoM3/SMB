-- Initialize Account Service Database
CREATE DATABASE IF NOT EXISTS account_db;
USE account_db;

-- Create accounts table if it doesn't exist
-- Note: JPA/Hibernate will also create tables, but this ensures they exist for initial data
CREATE TABLE IF NOT EXISTS accounts (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    status VARCHAR(50) NOT NULL,
    balance DECIMAL(19,2) NOT NULL,
    currency VARCHAR(50) NOT NULL,
    customer_id VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_date DATETIME(6) NOT NULL,
    created_by VARCHAR(255) NOT NULL,
    last_modified_date DATETIME(6),
    last_modified_by VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create operations table if it doesn't exist (for account operations)
CREATE TABLE IF NOT EXISTS operations (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    date_time DATETIME(6) NOT NULL,
    amount DECIMAL(19,2) NOT NULL,
    type VARCHAR(50) NOT NULL,
    description VARCHAR(255) NOT NULL,
    created_by VARCHAR(255) NOT NULL,
    account_id VARCHAR(255),
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create account_email_customer_id table if it doesn't exist
CREATE TABLE IF NOT EXISTS account_email_customer_id (
    account_id VARCHAR(255) NOT NULL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    customer_id VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert dummy test data for load testing
INSERT IGNORE INTO accounts (id, customer_id, email, balance, currency, status, created_date, created_by)
VALUES 
('account-001', 'customer-001', 'john.doe@example.com', 1000.00, 'USD', 'ACTIVATED', NOW(), 'system'),
('account-002', 'customer-002', 'jane.smith@example.com', 500.00, 'USD', 'ACTIVATED', NOW(), 'system'),
('account-003', 'customer-003', 'bob.johnson@example.com', 2500.00, 'USD', 'ACTIVATED', NOW(), 'system'),
('account-004', 'customer-004', 'alice.williams@example.com', 750.00, 'USD', 'ACTIVATED', NOW(), 'system'),
('account-005', 'customer-005', 'charlie.brown@example.com', 1500.00, 'USD', 'ACTIVATED', NOW(), 'system');
