@echo off
SET PGPASSWORD=IAMSHER_09
psql -U postgres -d entrega3 -f actualizar_antiguedad_semanalmente.sql