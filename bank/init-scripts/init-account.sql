-- Initialize Account Service Database
USE account_db;

-- Note: The tables will be created automatically by JPA/Hibernate
-- This script adds dummy test data for load testing

-- Example account data (will be inserted if tables exist)
-- Note: These will be inserted after JPA creates the tables
INSERT IGNORE INTO accounts (id, customer_id, email, balance, currency, status, created_date, created_by)
VALUES 
('account-001', 'customer-001', 'john.doe@example.com', 1000.00, 'USD', 'ACTIVATED', NOW(), 'system'),
('account-002', 'customer-002', 'jane.smith@example.com', 500.00, 'USD', 'ACTIVATED', NOW(), 'system'),
('account-003', 'customer-003', 'bob.johnson@example.com', 2500.00, 'USD', 'ACTIVATED', NOW(), 'system'),
('account-004', 'customer-004', 'alice.williams@example.com', 750.00, 'USD', 'ACTIVATED', NOW(), 'system'),
('account-005', 'customer-005', 'charlie.brown@example.com', 1500.00, 'USD', 'ACTIVATED', NOW(), 'system');

