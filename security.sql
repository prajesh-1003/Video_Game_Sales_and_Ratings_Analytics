
--  ROLE-BASED ACCESS CONTROL (RBAC) CONFIGURATION

-- 1. CREATE ROLES (No inheritance for security)
CREATE ROLE analyst_user NOINHERIT;
CREATE ROLE app_user NOINHERIT;

-- 2. ASSIGN LOGIN CREDENTIALS
ALTER ROLE analyst_user WITH LOGIN PASSWORD 'analyst123';
ALTER ROLE app_user WITH LOGIN PASSWORD 'appuser123';

-- 3. DATABASE ACCESS PERMISSIONS
GRANT CONNECT ON DATABASE videogamesdb TO analyst_user;
GRANT CONNECT ON DATABASE videogamesdb TO app_user;

-- 4. SCHEMA-LEVEL PERMISSIONS
-- Analyst: read-only access to schema
GRANT USAGE ON SCHEMA public TO analyst_user;

-- Application: usage only (NO CREATE!)
GRANT USAGE ON SCHEMA public TO app_user;

-- IMPORTANT: app_user should NOT have CREATE on schema
-- So we ensure it is revoked (in case previously granted)
REVOKE CREATE ON SCHEMA public FROM app_user;

-- 5. TABLE-LEVEL PERMISSIONS

-- Analyst: read-only tables
GRANT SELECT ON 
    game,
    sales,
    reviews,
    developer,
    genre,
    platform,
    publisher
TO analyst_user;

-- Application user: CRUD access but NOT create/drop/truncate
GRANT SELECT, INSERT, UPDATE, DELETE ON 
    game,
    sales,
    reviews,
    developer,
    genre,
    platform,
    publisher
TO app_user;

-- 6. SEQUENCE PERMISSIONS (required for AUTO INCREMENT)
-- Analyst: can read sequences (not modify)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO analyst_user;

-- Application user: can use sequences for INSERTs (safe)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_user;

-- 7. DEFAULT PRIVILEGES (FOR FUTURE TABLES & SEQUENCES)

-- For future tables (analyst = read only)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO analyst_user;

-- For future tables (app_user = CRUD)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

-- Future sequences (analyst can read)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT ON SEQUENCES TO analyst_user;

-- Future sequences (app_user can use them)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT ON SEQUENCES TO app_user;

