-- Initialize Customer Service Database
USE customer_db;

-- Note: The tables will be created automatically by JPA/Hibernate
-- This script adds dummy test data for load testing

-- Example customer data (will be inserted if tables exist)
-- Note: These will be inserted after JPA creates the tables
INSERT IGNORE INTO customers (id, name, email, cin, phone, address, created_date, created_by)
VALUES 
('customer-001', 'John Doe', 'john.doe@example.com', 'CIN123456', '+1234567890', '123 Main St', NOW(), 'system'),
('customer-002', 'Jane Smith', 'jane.smith@example.com', 'CIN789012', '+0987654321', '456 Oak Ave', NOW(), 'system'),
('customer-003', 'Bob Johnson', 'bob.johnson@example.com', 'CIN345678', '+1122334455', '789 Pine Rd', NOW(), 'system'),
('customer-004', 'Alice Williams', 'alice.williams@example.com', 'CIN456789', '+2233445566', '321 Elm St', NOW(), 'system'),
('customer-005', 'Charlie Brown', 'charlie.brown@example.com', 'CIN567890', '+3344556677', '654 Maple Dr', NOW(), 'system');

