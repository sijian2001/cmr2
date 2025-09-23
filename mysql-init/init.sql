-- Create test database
CREATE DATABASE IF NOT EXISTS crm2_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant permissions to crm2user
GRANT ALL PRIVILEGES ON crm2.* TO 'crm2user'@'%';
GRANT ALL PRIVILEGES ON crm2_test.* TO 'crm2user'@'%';
FLUSH PRIVILEGES;