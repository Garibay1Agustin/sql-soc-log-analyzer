DROP DATABASE IF EXISTS soc_monitoreo_db;
CREATE DATABASE soc_monitoreo_db;
USE soc_monitoreo_db;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    departamento VARCHAR(50),
    estado VARCHAR(50) DEFAULT 'activo'
);

CREATE TABLE dispositivos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ip_address VARCHAR(15),
    hostname VARCHAR(50),
    tipo_os VARCHAR(30)
);

CREATE TABLE logs_autenticacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    dispositivo_id INT,
    resultado VARCHAR(20),
    fecha_hora DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (dispositivo_id) REFERENCES dispositivos(id)
);

INSERT INTO usuarios (nombre, departamento) VALUES
('Agustín', 'Cybersecurity'),
('Carlos', 'Finanzas'),
('Lucía', 'RRHH'),
('Marcos', 'Desarrollo');

INSERT INTO dispositivos (ip_address, hostname, tipo_os) VALUES
('192.168.1.10', 'SRV-DB-01', 'Linux Ubuntu'),
('192.168.1.25', 'WORK-FIN-02', 'Windows 11'),
('10.0.0.50', 'SRV-WEB-01', 'Linux Debian');

INSERT INTO logs_autenticacion (usuario_id, dispositivo_id, resultado, fecha_hora) VALUES
(1, 1, 'EXITOSO', '2026-08-07 08:30:00'),
(2, 2, 'FALLIDO', '2026-08-07 09:00:00'),
(2, 2, 'FALLIDO', '2026-08-07 09:00:15'),
(2, 2, 'FALLIDO', '2026-08-07 09:00:30'),
(2, 2, 'EXITOSO', '2026-08-07 09:01:00'),
(3, 3, 'EXITOSO', '2026-08-07 10:15:00');


SELECT usuarios.nombre, COUNT(logs_autenticacion.id) AS intentos_fallidos
FROM logs_autenticacion
JOIN usuarios ON logs_autenticacion.usuario_id = usuarios.id
WHERE logs_autenticacion.resultado = 'FALLIDO'
GROUP BY usuarios.nombre
ORDER BY intentos_fallidos DESC;

SELECT usuarios.nombre, usuarios.departamento
FROM usuarios
LEFT JOIN logs_autenticacion ON usuarios.id = logs_autenticacion.usuario_id
WHERE logs_autenticacion.id IS NULL;

SELECT 
    logs_autenticacion.fecha_hora,
    usuarios.nombre AS usuario,
    dispositivos.hostname,
    dispositivos.ip_address,
    logs_autenticacion.resultado
FROM logs_autenticacion
INNER JOIN usuarios ON logs_autenticacion.usuario_id = usuarios.id
INNER JOIN dispositivos ON logs_autenticacion.dispositivo_id = dispositivos.id
ORDER BY logs_autenticacion.fecha_hora DESC;