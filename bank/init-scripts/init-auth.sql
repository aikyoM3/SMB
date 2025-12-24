-- Initialize Authentication Service Database with test users
USE db_user_new_devs_nours;

-- Note: The tables will be created automatically by JPA/Hibernate
-- This script creates test users that can be used for testing

-- Insert test roles (if they don't exist)
-- Note: Adjust based on your actual Role entity structure
-- INSERT INTO roles (id, name) VALUES 
-- ('role-1', 'USER'),
-- ('role-2', 'ADMIN'),
-- ('role-3', 'SUPER_ADMIN')
-- ON DUPLICATE KEY UPDATE name=name;

-- Insert test user
-- Note: Password should be BCrypt encoded for 'testpass123'
-- You can generate this using: BCrypt.hashpw("testpass123", BCrypt.gensalt())
-- For now, this is a placeholder - the actual password encoding will be handled by the service
-- INSERT INTO users (id, username, email, password, enabled, password_need_to_be_modified, ...)
-- VALUES ('user-1', 'testuser', 'testuser@example.com', '$2a$10$...', true, false, ...)
-- ON DUPLICATE KEY UPDATE username=username;

-- Note: Since JPA will auto-create tables, we'll let the service handle user creation
-- This file is here for future use if manual SQL initialization is needed

