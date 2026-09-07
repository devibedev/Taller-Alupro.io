-- backend/schema_conalum.sql
-- INSERTs Conalum validados

INSERT INTO series (nombre, descripcion, tipo, espesor_perfil_mm) VALUES
('Corrediza 3"', 'Sistema corredizo residencial Conalum', 'corrediza', 76.2),
('Fijo 3"', 'Ventana fija Conalum', 'fija', 76.2),
('Finestra 1400', 'Sistema europeo Conalum', 'europea', 70.0);

-- Perfiles Corrediza 3"
INSERT INTO perfiles (serie_id, clave_conalum, nombre, costo_ml, peso_kg_ml) VALUES
(1, 'CR-301', 'Riel Superior', 185.50, 1.250),
(1, 'CR-302', 'Riel Inferior', 185.50, 1.250),
(1, 'CR-303', 'Jamba', 175.00, 1.180),
(1, 'CR-304', 'Cerco', 168.00, 1.130),
(1, 'CR-305', 'Traslape', 165.00, 1.110),
(1, 'CR-306', 'Zoclo', 162.00, 1.090),
(1, 'CR-307', 'Cabezal', 162.00, 1.090);

-- Fórmulas Corrediza 3"
INSERT INTO formulas_descuento (serie_id, perfil_id, formula, descripcion) VALUES
(1, 1, 'W', 'Riel Superior = Ancho total'),
(1, 2, 'W', 'Riel Inferior = Ancho total'),
(1, 3, 'H', 'Jamba = Alto total'),
(1, 4, 'H-20', 'Cerco = Alto - 20mm'),
(1, 5, 'H-20', 'Traslape = Alto - 20mm'),
(1, 6, '(W+25)/2-45', 'Zoclo = (Ancho+25)/2 - 45mm'),
(1, 7, '(W+25)/2-45', 'Cabezal = (Ancho+25)/2 - 45mm');

-- Accesorios
INSERT INTO accesorios (nombre, clave_conalum, costo_unitario) VALUES
('Jaladera', 'JA-001', 45.00),
('Rueda', 'RU-002', 35.00),
('Felpa', 'FE-003', 15.00),
('Tornillo', 'TO-004', 2.50),
('Silicon', 'SI-005', 25.00);

-- Accesorios por serie
INSERT INTO accesorios_por_serie (serie_id, accesorio_id, cantidad_por_ventana) VALUES
(1, 1, 2), -- 2 jaladeras
(1, 2, 4), -- 4 ruedas
(1, 3, 4), -- 4 felpas
(1, 4, 20), -- 20 tornillos
(1, 5, 1); -- 1 silicon
