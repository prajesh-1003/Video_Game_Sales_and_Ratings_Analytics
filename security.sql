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

-- Application user: usage only (NO CREATE!)
GRANT USAGE ON SCHEMA public TO app_user;

-- Ensure app_user cannot create tables
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

-- Analyst: can only read sequences
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO analyst_user;

-- Application user: must be able to increment sequences → need UPDATE
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO app_user;

-- 7. DEFAULT PRIVILEGES (FUTURE TABLES AND SEQUENCES)

-- Future tables (analyst read-only)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO analyst_user;

-- Future tables (app_user CRUD)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

-- Future sequences (analyst read)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT ON SEQUENCES TO analyst_user;

-- Future sequences (app_user must use and update)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO app_user;
