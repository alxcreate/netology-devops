--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE "test-admin-user";
ALTER ROLE "test-admin-user" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE "test-simple-user";
ALTER ROLE "test-simple-user" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE "user";
ALTER ROLE "user" WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:OdcOmpwZ9qyK3B//jLnc+w==$V7ypPHY1F1Bdp4IenQYaq/Vz3db91srR9mp8g0I+shI=:N20LeFKeGO8h6AVy5kMR+mJ+gIAyJ1tkOECoq07J1Pc=';




--
-- PostgreSQL database cluster dump complete
--

